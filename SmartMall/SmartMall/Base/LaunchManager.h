//
//  LaunchManager.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchManager : NSObject

+ (instancetype)shareInstance;

- (void)launchApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
