//
//  RMViewController.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "RMViewController.h"

#define kNaviItemMargin  15.0  //导航栏左右按钮举两边分别是15

@interface RMViewController ()

@property (nonatomic,strong) NSArray *leftItems;

@property (nonatomic,strong) NSArray *rightItems;

@end

@implementation RMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.naviColor = NaviColorBlue;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userNetWorkChange)
                                                 name:@"kUserNetWorkNotification"
                                               object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([ UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [[UINavigationBar appearance]setShadowImage:[UIImage new]];
        //[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320,3)]
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    if ([self isKindOfClass:NSClassFromString(@"LoginViewController")]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Setter.Getter
- (void)setNaviColor:(NaviColor)naviColor
{
    _naviColor = naviColor;
    UINavigationBar *bar = self.navigationController.navigationBar;
    UIColor *color = nil;
    switch (naviColor) {
        case NaviColorBlue:
            color = [UIColor colorWithHexString:@"#18b4ed"];
            break;
        case NaviColorRed:
            color = [UIColor colorWithHexString:@"#f35335"];
            break;
        case NaviColorClear:
            color = [UIColor clearColor];
            break;
        default:
            break;
    }
    [bar setBackgroundImage:[UIImage imageWithColor:color
                                               size:CGSizeMake(kScreenWidth, 64)]
              forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UI Actions
- (UIButton *)createBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* nmImage = [UIImage imageNamed:@"back"];
    UIImage* hlImage = [UIImage imageNamed:@"back"];
    CGFloat width = nmImage.size.width+kNaviItemMargin*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:nmImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    [button setContentMode:UIViewContentModeCenter];
    return button;
}

//设置左边的返回按钮
- (void)setLeftBackButton
{
    [self setLeftBackButtonAction:@selector(backButtonPressed:)];
}

- (void)setLeftBackButtonAction:(SEL)selector
{
    [self setLeftButton:[self createBackButton] action:selector];
}

//设置左边的按钮(文字按钮)
- (void)setLeftButtonWithTitle:(NSString*)title action:(SEL)selector
{
    [self setLeftButtonWithTitle:title action:selector titleColor:[UIColor whiteColor]];
}

- (void)setLeftButtonWithTitle:(NSString*)title action:(SEL)selector titleColor:(UIColor*)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIFont* font = [UIFont systemFontOfSize:15.0];
    CGFloat width = [title contentWidthWithFont:font] + kNaviItemMargin*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    [self setLeftButton:button action:selector];
}

//设置左边的返回按钮(图片按钮)
- (void)setLeftButtonWithImageName:(NSString*)imageName action:(SEL)selector
{
    [self setLeftButtonWithNormarlImageName:imageName highlightedImageName:imageName action:selector];
}

- (void)setLeftButtonWithNormarlImageName:(NSString*)normarName
                     highlightedImageName:(NSString *)highlightedName
                                   action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* nmImage = [UIImage imageNamed:normarName];
    UIImage* hlImage = [UIImage imageNamed:highlightedName];
    CGFloat width = nmImage.size.width+kNaviItemMargin*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    [button setImage:nmImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    [self setLeftButton:button action:selector];
}

- (void)setHomeLeftButton:(BOOL)redicon action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* nmImage = [UIImage imageNamed:@"san"];
    CGFloat width = nmImage.size.width+kNaviItemMargin*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    [button setImage:nmImage forState:UIControlStateNormal];
    
    if (redicon) {
        UIImageView *isHaveNewMsgPoint = [[UIImageView alloc] init];
        isHaveNewMsgPoint.frame = CGRectMake(CGRectGetMaxX(button.frame) - 5 - 10, 5, 10, 10);
        isHaveNewMsgPoint.layer.masksToBounds = YES;
        isHaveNewMsgPoint.layer.cornerRadius = 10 * 0.5;
        isHaveNewMsgPoint.backgroundColor = [UIColor redColor];
        [button addSubview:isHaveNewMsgPoint];
    }
    
    [self setLeftButton:button action:selector];
}

//设置左边的返回按钮(通用按钮)
- (void)setLeftButton:(UIButton*)button action:(SEL)selector
{
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, button.bounds.size.width, button.bounds.size.height);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,barButtonItem];
    
    self.leftItems = @[button];
}

- (void)setLeftButtons:(NSArray *)btns
{
    self.navigationItem.leftBarButtonItem = nil;
    
    
    
    if (!btns || !self.navigationItem) {
        return;
    }
    
    if (btns.count < 1) {
        return;
    }
    
    NSMutableArray *attrs = [NSMutableArray arrayWithCapacity:btns.count];
    for (int i = 0; i < btns.count; i ++) {
        UIButton *btn = [btns objectAtIndex:i];
        
        [attrs addObject:btn];
    }
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 0, 44);
    CGFloat width = 0.0;
    for (int i = 0; i < btns.count; i ++) {
        
        UIButton *btn = [attrs objectAtIndex:i];
        if ([btn.allTargets anyObject] == nil || [[btn.allTargets anyObject] isEqual:[NSNull null]]) {
            [btn addTarget:self action:@selector(navLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.tag = i;
        btn.frame = CGRectMake(0, 0, 20, 20);
        
        CGRect btnFrame = btn.frame;
        btnFrame.origin.x = width + i*5;
        btn.frame = btnFrame;
        
        CGPoint btnCenter = btn.center;
        btnCenter.y = leftView.center.y;
        btn.center = btnCenter;
        
        [leftView addSubview:btn];
        
        width = CGRectGetMaxX(btnFrame);
    }
    
    leftView.frame = CGRectMake(leftView.frame.origin.x, leftView.frame.origin.y, width, leftView.frame.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
    
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        return;
    }
    
    //调整titleView
    UIView *titleView = self.navigationItem.titleView;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGRect tf = titleView.frame;
    CGRect nf = navBar.frame;
    CGFloat rw = nf.size.width - 2*(width + 20);
    if (rw < tf.size.width) {
        tf.size.width = rw;
        titleView.frame = tf;
        self.navigationItem.titleView = titleView;
    }
}

- (void)navLeftButtonAction:(id)sender
{
    //sub class overwrite
}

//控制左边按钮是否可见
- (void)hideLeftButtons:(BOOL)hide
{
    if (self.leftItems == nil) {
        return;
    }
    [self.leftItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* item = (UIView*)obj;
        item.hidden = hide;
    }];
}

//设置中间的文本标题
- (void)setTitleViewWithText:(NSString*)text
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.text = text;
    titleLabel.center = CGPointMake(kScreenWidth/2, 22);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
}

- (void)setTitleViewHidden:(BOOL)hidden
{
    self.navigationItem.titleView.hidden = hidden;
}

//设置右边的按钮(文字按钮), 可以指定按钮水平位置
- (void)setRightButtonWithTitle:(NSString*)title action:(SEL)selector
{
    [self setRightButtonWithTitle:title action:selector titleColor:[UIColor whiteColor]];
}

- (void)setRightButtonWithTitle:(NSString*)title withImage:(NSString *)image action:(SEL)selector {
    [self setRightButtonWithTitle:title withImage:image withHighlightedImage:image action:selector titleColor:[UIColor whiteColor]];
}

- (void)setRightButtonWithTitle:(NSString*)title withImage:(NSString *)image1 withHighlightedImage:(NSString *)image2 action:(SEL)selector titleColor:(UIColor*)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIFont* font = [UIFont systemFontOfSize:15.0];
    CGFloat width =  [title contentWidthWithFont:font] + kNaviItemMargin * 2 + 18;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -9)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    [self setRightButton:button action:selector];
}

- (void)setRightButtonWithTitle:(NSString*)title action:(SEL)selector titleColor:(UIColor*)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIFont* font = [UIFont systemFontOfSize:15.0];
    CGFloat width = [title contentWidthWithFont:font] + kNaviItemMargin * 2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [self setRightButton:button action:selector];
}

//设置右边的按钮(图片按钮), 可以指定按钮水平位置
- (void)setRightButtonWithImageName:(NSString*)imageName action:(SEL)selector
{
    [self setRightButtonWithNormarlImageName:imageName highlightedImageName:imageName action:selector];
}

- (void)setRightButtonWithNormarlImageName:(NSString*)normarName
                      highlightedImageName:(NSString *)highlightedName
                                    action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* nmImage = [UIImage imageNamed:normarName];
    UIImage* hlImage = [UIImage imageNamed:highlightedName];
    CGFloat width = nmImage.size.width+kNaviItemMargin*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    [button setImage:nmImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    
    [self setRightButton:button action:selector];
}

//设置右边的按钮
- (void)setRightButton:(UIButton*)button action:(SEL)selector
{
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, button.bounds.size.width, button.bounds.size.height);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,barButtonItem];
    
    self.rightItems = @[button];
    
}

//控制右边按钮是否可见
- (void)hideRightButtons:(BOOL)hide
{
    [self.rightItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* item = (UIView*)obj;
        item.hidden = hide;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//返回按钮的响应事件
- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userNetWorkChange
{
    
}

- (BOOL)reloadAction
{
    return [PPNetworkHelper isNetwork];
}

- (void)removeRightNaviItemButton
{
    self.navigationItem.rightBarButtonItems = nil;
}
@end
