//
//  SNPageControl.h
//  SmartHome
//
//  Created by JianRongCao on 15/11/23.
//  Copyright © 2015年 SmartMall. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SNPageControlAlignment) {
    SNPageControlAlignmentLeft,
    SNPageControlAlignmentCenter,
    SNPageControlAlignmentRight
};

@interface SNPageControl : UIView

@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property(nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property(nonatomic) BOOL defersCurrentPageDisplay;    // if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO
- (void)updateCurrentPageDisplay;                      // update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

@property (nonatomic) SNPageControlAlignment pageAlignment;

@property (nonatomic) CGSize itemSize;

@end
