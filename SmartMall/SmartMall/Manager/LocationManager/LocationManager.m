//
//  LocationManager.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationInfo.h"

static id _locationManager = nil;

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager     *cllLocationManager;
@property (nonatomic, assign) BOOL                   isSave;//是否保存定位数据
@property (nonatomic, assign) BOOL                   isLocating; //是否定位中

@end


@implementation LocationManager

- (instancetype)init
{
    if (self = [super init])
    {
        _isLocating = NO;
    }
    return self;
}

- (CLLocationManager *)cllLocationManager
{
    if (!_cllLocationManager) {
        _cllLocationManager = [[CLLocationManager alloc] init];
        _cllLocationManager.delegate = self;
        _cllLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _cllLocationManager.distanceFilter = 10;
      
        if([_cllLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_cllLocationManager requestWhenInUseAuthorization];
//            [_cllLocationManager requestAlwaysAuthorization];
        }
    }
    return _cllLocationManager;
}

+ (LocationManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[self alloc] init];
    });
    return _locationManager;
}
/**
 *GPS模块是否开启
 */
+ (BOOL)isGPSModuleAvailable
{
    if (![CLLocationManager locationServicesEnabled]
        ||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
        return NO;
    }
    else {
        return YES;
    }
}

/**
 是否正在定位中
 */
+ (BOOL)isLocating
{
    return [LocationManager defaultManager].isLocating;
}

/**
 *如果权限由禁止定位改变成开启定位，则去主动调用定位功能
 */
- (void)reloadAuth
{
    NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:kLocationManager_NoAuth];
    if ([RMUtils isValidString:value]) {
        if ([LocationManager isGPSModuleAvailable] == YES) {
            [self startLocation];
        }
    }
}

#pragma mark - private method
/**
 *开始定位
 */
- (void)startLocation
{
    if ([LocationManager isGPSModuleAvailable] == NO) {
        //  本地存储 定位无权限
        [[NSUserDefaults standardUserDefaults] setValue:kLocationManager_NoAuth forKey:kLocationManager_NoAuth];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 定位结束，通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManager_END object:nil];
        return;
    }
    //  本地清除 定位无权限
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kLocationManager_NoAuth];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //开始定位
    if (self.isLocating) {
        return;
    }
    self.isLocating = YES;
    [self.cllLocationManager startUpdatingLocation];
}

#pragma mark locationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
         if (array.count > 0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             NSMutableString *addrss = [NSMutableString stringWithString:@""];
             //获取城市
             NSString *city = placemark.locality;
             if (![RMUtils isValidString:city]) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
                 [addrss appendString:city];
             }
             else {
                 [addrss appendString:placemark.administrativeArea];
                 [addrss appendString:@"-"];
                 [addrss appendString:city];

                 if ([RMUtils isValidString:placemark.subLocality]) {
                     [addrss appendString:@"-"];
                     [addrss appendString:placemark.subLocality];
                 }
             }
             if (!self.isLocating) {
                 return ;
             }
             DLog(@"当前定位地点：%@",addrss);
             self.isLocating = NO;
             [self autoSaveAddress:addrss];
             [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManager_END object:nil];
             [self.cllLocationManager stopUpdatingLocation];
         }
         else {
             self.isLocating = NO;
             [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManager_END object:nil];
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.isLocating = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManager_END object:nil];
}

#pragma mark - event response

/**
 *展示城市，优先展示手动定位的城市 默认北京市
 */
- (NSString*)showLocationCityName
{
    NSString *cityName = @"";
    NSString *key = kLocationManager_Manual;
    if (![[NSUserDefaults standardUserDefaults] valueForKey:key]) {
        key = kLocationManager_Auto;
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key]) {
        NSString *addressString = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        /*含有“－” 代表 省－市*/
        if ([addressString rangeOfString:@"-"].location != NSNotFound) {
            NSArray *locArray = [addressString componentsSeparatedByString:@"-"];
            cityName = [locArray objectAtIndex:1];
        }
        else {
            cityName = addressString;
        }
    }
    if (![RMUtils isValidString:cityName]) {
        cityName = @"北京市";
    }
    return cityName;
}

/**
 *获取自动定位的地址
 */
- (NSString *)getAutoLocationAddress
{
    if (![LocationManager isGPSModuleAvailable]) {
        return @"定位服务未开启";
    }
    NSString *key = kLocationManager_Auto;

    NSString *address = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if (![RMUtils isValidString:address]) {
        address = @"未定位到当前城市";
    }
    return address;
}

/**
 *获取自动定位得到的地址，默认为北京-北京市-东城区，忽略权限问题
 */
- (NSString *)getAutoLocNameWithType:(LOCNAMETYPE)type;
{
    NSString *key = kLocationManager_Auto;
    NSString *allLocString = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if (![RMUtils isValidString:allLocString]) {
        allLocString = @"北京-北京市-东城区";
    }
    NSMutableArray *locS = [NSMutableArray arrayWithArray:[allLocString componentsSeparatedByString:@"-"]];
    //省－市－区
    return [locS objectAtIndex:type];
}

/**
 *通过手动修改得到的地址，进行保存
 *kLocationManager_Manual
 */
- (void)manualSaveAddress:(NSString*)address
{
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:kLocationManager_Manual];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManager_END object:nil];
}

/***
 *通过系统定位得到的地址，进行保存
 *kLocationManager_Auto
 */
- (void)autoSaveAddress:(NSString*)address
{
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:kLocationManager_Auto];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
