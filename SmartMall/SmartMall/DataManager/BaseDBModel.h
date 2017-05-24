//
//  BaseDBModel.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 JianRongCao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDBModel : NSObject

@property (nonatomic,copy)   NSString *primaryKey; //主键

@property (nonatomic,strong) NSMutableDictionary *operateDic;    //用于修改，删除,查询

@property (nonatomic,assign) NSInteger rowId;

@end
