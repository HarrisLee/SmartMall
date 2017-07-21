//
//  RMUtils+View.m
//  SmartMall
//
//  Created by JianRongCao on 27/06/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "RMUtils+View.h"

@implementation RMUtils (View)

+ (UIViewController *)getVisibleViewController
{
    return [self getVisibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    }
    else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        }
        else {
            return vc;
        }
    }
}

@end
