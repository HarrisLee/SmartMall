//
//  UserManager.h
//  SmartMall
//
//  Created by JianRongCao on 26/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,copy) NSString *userAvater;

@property (nonatomic,copy) NSString *phoneNumber;

+ (instancetype)shareInstance;

@end
