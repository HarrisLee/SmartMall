//
//  RMTimerHelper.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 JianRongCao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMTimerHelper : NSTimer

+ (RMTimerHelper *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

- (void)invalidate;

@end
