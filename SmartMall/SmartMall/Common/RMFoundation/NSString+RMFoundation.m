//
//  NSString+RMFoundation.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
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

- (CGFloat)contentWidthWithFont:(UIFont *)font limit:(CGFloat)limit
{
    if (self.length == 0) {
        return 0;
    }
    
    CGFloat width =0;
    CGRect  rect =[self boundingRectWithSize:CGSizeMake(limit, font.lineHeight)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    width = ceil(rect.size.width);
    return width;
}

- (CGFloat)contentWidthWithFont:(UIFont *)font
{
    return [self contentWidthWithFont:font limit:[UIScreen mainScreen].bounds.size.width];
}

@end
