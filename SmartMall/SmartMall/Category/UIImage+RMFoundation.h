//
//  UIImage+RMFoundation.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RMFoundation)

/**
 生成某一个颜色的纯色图片

 @param color 设置的颜色
 @param size 图片大小
 @return 图片数据
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 获取图片某一个点的像素

 @param point 点位
 @return 颜色值
 */
- (UIColor *)getPixelColor:(CGPoint)point;

/**
 判断该图片是否有透明通道

 @return 是否有透明通道 YES:有 NO:无
 */
- (BOOL)hasAlphaChannel;

@end
