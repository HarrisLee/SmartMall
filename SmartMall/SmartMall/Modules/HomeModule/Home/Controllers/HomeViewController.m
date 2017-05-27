//
//  HomeViewController.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "HomeViewController.h"
#import "NextViewController.h"

#import "RITLPhotoNavigationViewController.h"
#import "RITLPhotoNavigationViewModel.h"

#import "RMBannerView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    [self setRightButtonWithTitle:@"购物车" action:@selector(showShoppingCart)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 300, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(ssssss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    RMBannerView *banner = [[RMBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [banner itemClicked:^(NSDictionary *obj) {
        
    }];
    [self.view addSubview:banner];
}

- (void)showShoppingCart
{
    RITLPhotoNavigationViewModel *viewModel = [[RITLPhotoNavigationViewModel alloc] init];
    viewModel.maxNumberOfSelectedPhoto = 6;
//    __weak typeof(self) weakSelf = self;
    //    设置需要图片剪切的大小，不设置为图片的原比例大小
    //    viewModel.imageSize = _assetSize;
    
    viewModel.RITLBridgeGetImageBlock = ^(NSArray <UIImage *> * images){
        
        //获得图片
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        
//        strongSelf.assets = images;
//        
//        [strongSelf.collectionView reloadData];
        DLog(@"%@",images);
        
    };
    
    viewModel.RITLBridgeGetImageDataBlock = ^(NSArray <NSData *> * datas){
        
        //可以进行数据上传操作..
        DLog(@"%@",datas);
        
    };
    
    RITLPhotoNavigationViewController * viewController = [RITLPhotoNavigationViewController photosViewModelInstance:viewModel];
    
    [self presentViewController:viewController animated:true completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ssssss
{
    [self.navigationController pushViewController:[[NextViewController alloc] init] animated:YES];
//    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
}

@end
