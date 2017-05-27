//
//  LaunchManager.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "LaunchManager.h"

@implementation LaunchManager

static LaunchManager *manager = nil;

+ (instancetype)shareInstance
{
    @synchronized (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[LaunchManager alloc] init];
        });
    }
    return manager;
}

- (void)globalConfiguration
{
    [[LocationManager defaultManager] startLocation];
}

- (void)launchApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self globalConfiguration];
    

}

@end
