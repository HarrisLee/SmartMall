//
//  NSString+RMFoundation.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RMFoundation)

- (NSDate *)dateWithFormat:(NSString *)format;

- (CGFloat)contentWidthWithFont:(UIFont *)font limit:(CGFloat)limit;

- (CGFloat)contentWidthWithFont:(UIFont *)font;

@end
