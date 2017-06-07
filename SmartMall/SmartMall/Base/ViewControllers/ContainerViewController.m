//
//  ContainerViewController.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "ContainerViewController.h"
#import "HomeViewController.h"
#import "RMNavigationController.h"

@interface ContainerViewController ()<UITabBarControllerDelegate>

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showTabItems];
}

- (void)showTabItems
{
    HomeViewController *home = [[HomeViewController alloc] init];
    home.title = @"首页";
    RMNavigationController *homeNavi = [[RMNavigationController alloc] initWithRootViewController:home];
    homeNavi.tabBarItem.title = @"首页";
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"tab_icon_home"];
    homeNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_icon_home_sel"];
    
    HomeViewController *home1 = [[HomeViewController alloc] init];
    home1.title = @"首页1";
    RMNavigationController *homeNavi1 = [[RMNavigationController alloc] initWithRootViewController:home1];
    homeNavi1.tabBarItem.title = @"购物车";
    homeNavi1.tabBarItem.image = [UIImage imageNamed:@"tab_icon_home"];
    homeNavi1.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_icon_home_sel"];
    
    HomeViewController *home2 = [[HomeViewController alloc] init];
    home2.title = @"首页2";
    RMNavigationController *homeNavi2 = [[RMNavigationController alloc] initWithRootViewController:home2];
    homeNavi2.tabBarItem.title = @"我的订单";
    homeNavi2.tabBarItem.image = [UIImage imageNamed:@"tab_icon_home"];
    homeNavi2.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_icon_home_sel"];
    
    HomeViewController *home3 = [[HomeViewController alloc] init];
    home3.title = @"首页3";
    RMNavigationController *homeNavi3 = [[RMNavigationController alloc] initWithRootViewController:home3];
    homeNavi3.tabBarItem.title = @"个人中心";
    homeNavi3.tabBarItem.image = [UIImage imageNamed:@"tab_icon_home"];
    homeNavi3.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_icon_home_sel"];
    
    [self.tabBar setTintColor:[UIColor colorWithRed:0.14 green:0.71 blue:0.97 alpha:1.00]];
    self.delegate = self;
    self.viewControllers = @[homeNavi,homeNavi1,homeNavi2,homeNavi3];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    DLog(@"%ld-%ld",tabBarController.selectedIndex,index);
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
