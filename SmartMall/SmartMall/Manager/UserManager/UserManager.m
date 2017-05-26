//
//  UserManager.m
//  SmartMall
//
//  Created by JianRongCao on 26/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

static UserManager *manager = nil;

+ (instancetype)shareInstance
{
    @synchronized (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[UserManager alloc] init];
        });
    }
    return manager;
}

@end
