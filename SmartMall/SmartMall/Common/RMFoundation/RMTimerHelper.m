//
//  RMTimerHelper.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "RMTimerHelper.h"

@interface RMTimerHelper ()
{
    id __weak delegate_;
    SEL action_;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) SEL action;

@end

@implementation RMTimerHelper

- (void)dealloc {
    [self invalidate];
    delegate_ = nil;
    action_ = nil;
}

+ (RMTimerHelper *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    RMTimerHelper *helper = [[RMTimerHelper alloc] init];
    
    [helper invalidate];
    
    helper.delegate = aTarget;
    helper.action = aSelector;
    
    helper.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:helper selector:@selector(doSomething) userInfo:userInfo repeats:yesOrNo];
    
    return helper;
}

- (void)invalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)doSomething
{
    if (self.delegate && [self.delegate respondsToSelector:self.action]) {
        SuppressPerformSelectorLeakWarning
        ([self.delegate performSelector:self.action]);
    }
}
@end
