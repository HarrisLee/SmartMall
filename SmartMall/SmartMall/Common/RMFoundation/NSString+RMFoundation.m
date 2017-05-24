//
//  NSString+RMFoundation.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 JianRongCao. All rights reserved.
//

#import "NSString+RMFoundation.h"

@implementation NSString (RMFoundation)

- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

@end
