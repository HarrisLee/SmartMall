//
//  RMUtils+View.h
//  SmartMall
//
//  Created by JianRongCao on 27/06/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "RMUtils.h"

@interface RMUtils (View)

+ (UIViewController *)getVisibleViewController;

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc;

@end
