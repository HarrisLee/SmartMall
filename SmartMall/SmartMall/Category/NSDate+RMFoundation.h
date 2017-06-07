//
//  NSDate+RMFoundation.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RMFoundation)

- (NSString *)stringWithDateFormat:(NSString *)formatString;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString;

@end
