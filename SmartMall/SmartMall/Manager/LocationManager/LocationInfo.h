//
//  LocationInfo.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject
// 名称
@property (nonatomic, strong) NSString* name;
// 拼音
@property (nonatomic, copy) NSString *letter;


- (id)initWithString:(NSString*)locName;

@end
