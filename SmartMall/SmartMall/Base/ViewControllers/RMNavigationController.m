//
//  RMNavigationController.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "RMNavigationController.h"

@interface RMNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation RMNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]
                                                                  size:CGSizeMake(kScreenWidth, 64)]
                                 forBarMetrics:UIBarMetricsDefault];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0f],NSFontAttributeName,
                              [UIColor whiteColor],NSForegroundColorAttributeName,nil];
        self.navigationBar.titleTextAttributes = dict;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(ws)
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = ws;
        self.delegate = ws;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *topViewController = self.topViewController;
    topViewController.hidesBottomBarWhenPushed = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count == 2) {
        topViewController.hidesBottomBarWhenPushed = NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.childViewControllers count] == 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface UINavigationBar (hitBar)

@end

@implementation UINavigationBar (hitBar)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        self.userInteractionEnabled = YES;
    }
    else {
        self.userInteractionEnabled = NO;
    }
    return [super hitTest:point withEvent:event];
}

@end
