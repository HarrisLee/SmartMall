//
//  LocationManager.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, LOCNAMETYPE)
{
    LOCPROVICE         = 0, // 省
    LOCCITY            = 1, // 市
    LOCDIS             = 2, // 区
};

/**
 kLocationManager_Auto: 自动定位
 kLocationManager_Manual: 手动定位
 kLocationManager_NoAuth: 没有定位权限
 kLocationManager_END:定位结束
 */

#define kLocationManager_Auto         @"kLocationManager_Auto"
#define kLocationManager_Manual       @"kLocationManager_Manual"
#define kLocationManager_NoAuth       @"kLocationManager_NoAuth"
#define kLocationManager_END          @"kLocationManager_END"

@interface LocationManager : NSObject

+ (LocationManager *)defaultManager;

/**
 *GPS模块是否开启
 */
+ (BOOL)isGPSModuleAvailable;

/**
 *是否正在定位中
 */
+ (BOOL)isLocating;

/**
 *开始定位
 */
- (void)startLocation;

/**
 *如果权限由禁止定位改变成开启定位，则去主动调用定位功能
 */
- (void)reloadAuth;

/**
 *展示城市，优先展示手动定位的城市 默认北京市
 */
- (NSString *)showLocationCityName;

/**
 *获取自动定位的地址
 */
- (NSString *)getAutoLocationAddress;

/**
 *获取自动定位得到的地址，默认为北京-北京市-东城区，忽略权限问题
 */
- (NSString *)getAutoLocNameWithType:(LOCNAMETYPE)type;

/**
 *通过手动修改得到的地址，进行保存
 *kLocationManager_Manual
 */
- (void)manualSaveAddress:(NSString*)address;

@end
