//
//  SNPageControl.m
//  SmartHome
//
//  Created by JianRongCao on 15/11/23.
//  Copyright © 2015年 SmartMall. All rights reserved.
//

#import "SNPageControl.h"

@interface SNPageControl ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation SNPageControl

#pragma mark - life cycle
- (instancetype)init
{
    if (self = [super init]) {
        self.numberOfPages = 0;
        self.currentPage = 0;
        self.pageAlignment = SNPageControlAlignmentRight;
        self.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        self.currentPageIndicatorTintColor = [UIColor orangeColor];
        self.hidesForSinglePage = YES;
        self.itemSize = CGSizeMake(5.0, 5.0);
    }
    return self;
}

#pragma mark - response
- (void)updateCurrentPageDisplay
{
    [self.subviews valueForKey:@"removeFromSuperview"];
    [self.items removeAllObjects];
    
    CGFloat width = self.itemSize.width;
    CGFloat height = self.itemSize.height;
    for (int idx = 0; idx < self.numberOfPages; idx++) {
        UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(width*2*idx, 0, width, height)];
        dot.layer.cornerRadius = height/2.0;
        dot.backgroundColor = (idx == self.currentPage) ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
        [dot setHidden:(self.numberOfPages == 1 && self.hidesForSinglePage)];
        [self.items addObject:dot];
        [self addSubview:dot];
    }
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGSize size = CGSizeZero;
    NSInteger count = [self.items count];
    if (count == 0) {
        return size;
    }
    return CGSizeMake((2*count - 1)*self.itemSize.width, self.itemSize.height);
}

#pragma mark - setter.getter
- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self updateCurrentPageDisplay];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self updateCurrentPageDisplay];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self updateCurrentPageDisplay];
}

- (void)setPageAlignment:(SNPageControlAlignment)pageAlignment
{
    _pageAlignment = pageAlignment;
    [self updateCurrentPageDisplay];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    [self updateCurrentPageDisplay];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    [self updateCurrentPageDisplay];
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

@end
