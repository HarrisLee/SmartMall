//
//  RMViewController.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NaviColorBlue,
    NaviColorRed,
    NaviColorClear,
} NaviColor;

@interface RMViewController : UIViewController

@property (nonatomic,assign) NaviColor naviColor;

//设置左边的返回按钮
- (void)setLeftBackButton;
- (void)setLeftBackButtonAction:(SEL)selector;

//设置左边的按钮(文字按钮)
- (void)setLeftButtonWithTitle:(NSString*)title
                        action:(SEL)selector;
- (void)setLeftButtonWithTitle:(NSString*)title
                        action:(SEL)selector
                    titleColor:(UIColor*)color;

//设置左边的按钮(图片按钮)
- (void)setLeftButtonWithImageName:(NSString*)imageName
                            action:(SEL)selector;
- (void)setLeftButtonWithNormarlImageName:(NSString*)normarName
                     highlightedImageName:(NSString *)highlightedName
                                   action:(SEL)selector;
- (void)setHomeLeftButton:(BOOL)redicon
                   action:(SEL)selector;

//设置左边的按钮(通用按钮)
- (void)setLeftButton:(UIButton*)button
               action:(SEL)selector;

- (void)setLeftButtons:(NSArray *)btns;
- (void)navLeftButtonAction:(id)sender;

//控制左边按钮是否可见
- (void)hideLeftButtons:(BOOL)hide;


//设置中间的文本标题
- (void)setTitleViewWithText:(NSString*)text;
- (void)setTitleViewHidden:(BOOL)hidden;



//设置右边的按钮(文字按钮)
- (void)setRightButtonWithTitle:(NSString*)title
                         action:(SEL)selector;

- (void)setRightButtonWithTitle:(NSString*)title
                      withImage:(NSString *)image
                         action:(SEL)selector;

- (void)setRightButtonWithTitle:(NSString*)title
                      withImage:(NSString *)image1
           withHighlightedImage:(NSString *)image2
                         action:(SEL)selector
                     titleColor:(UIColor*)color;

- (void)setRightButtonWithTitle:(NSString*)title
                         action:(SEL)selector
                     titleColor:(UIColor*)color;

//设置右边的按钮(图片按钮)
- (void)setRightButtonWithImageName:(NSString*)imageName
                             action:(SEL)selector;
- (void)setRightButtonWithNormarlImageName:(NSString*)normarName
                      highlightedImageName:(NSString *)highlightedName
                                    action:(SEL)selector;

//设置右边的按钮(通用按钮)
- (void)setRightButton:(UIButton*)button
                action:(SEL)selector;

//控制右边按钮是否可见
- (void)hideRightButtons:(BOOL)hide;

// 网络变化，通知
- (void)userNetWorkChange;

// 网络加载错误，重新加载
- (BOOL)reloadAction;

//删除导航栏右侧按钮
- (void)removeRightNaviItemButton;

@end
