//
//  RMBannerView.m
//  SmartMall
//
//  Created by JianRongCao on 27/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "RMBannerView.h"
#import "BannerCell.h"

#define kNewsPlayTime 1

@interface RMBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIPageControl   *pageControl;
    NSTimer *timer;
    int currentPage;
}
@property (nonatomic,strong) UICollectionView *bannerCollection;
@property (nonatomic,strong) NSMutableArray *banners;
@end

@implementation RMBannerView

- (void)reloadRecipeList
{
    
}

- (void)setUpBannerView
{
    WS(ws);
    [self addSubview:self.bannerCollection];
    [self.bannerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(ws);
    }];
}

- (UICollectionView *)bannerCollection
{
    if (!_bannerCollection) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bannerCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _bannerCollection.backgroundColor = [UIColor clearColor];
        _bannerCollection.bounces = NO;
        _bannerCollection.pagingEnabled = YES;
        _bannerCollection.showsHorizontalScrollIndicator = NO;
        _bannerCollection.alwaysBounceHorizontal = YES;
        _bannerCollection.delegate = self;
        _bannerCollection.dataSource = self;
        [_bannerCollection registerClass:[BannerCell class] forCellWithReuseIdentifier:@"BannerCell"];
    }
    return _bannerCollection;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.banners count] * 5000;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndexPath:indexPath];
//    NSDictionary *obj = [self.banners objectAtIndex:indexPath.row%[self.banners count]];
    NSString *imageUrl = @"";//[obj valueForKey:@"recipePhoto"];
    cell.iconUrl = imageUrl;
    cell.title = [NSString stringWithFormat:@"今天的活动是%@",[NSNumber numberWithInteger:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* 点击之后跳转详情界面   自己取需要的值*/
    if ([self.banners count] == 0) {
        return ;
    }
    NSDictionary *obj = [self.banners objectAtIndex:indexPath.row%self.banners.count];
    itemClickedBlock block = self.itemBlock;
    if (block) {
        block(obj);
    }
}

- (void)itemClicked:(void (^)(NSDictionary *obj))completion
{
    self.itemBlock = [completion copy];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.banners count] == 0) {
        return ;
    }
    CGFloat pageWidth = scrollView.bounds.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger nearestNumber = lround(fractionalPage)%(self.banners.count) ;
    if (pageControl.currentPage != nearestNumber) {
        pageControl.currentPage = nearestNumber;
        // if we are dragging, we want to update the page control directly during the drag
        if (scrollView.dragging) {
        //    NSDictionary *obj = [self.banners objectAtIndex:page];
        //    self.recipeName.text = [obj valueForKey:@"recipeName"];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.bounds.size.width;
    NSInteger page = scrollView.contentOffset.x/width;
    [scrollView setContentOffset:CGPointMake((page%self.banners.count + 2500) * width, 0) animated:NO];
}

#pragma mark - timer
- (void)pageTurn: (UIPageControl *) aPageControl
{
    NSInteger whichPage = floor(self.bannerCollection.contentOffset.x/kScreenWidth) + 1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.bannerCollection setContentOffset:CGPointMake(CGRectGetWidth(self.frame) * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
//    aPageControl.currentPage = whichPage;
//    [pageControl updateCurrentPageDisplay];
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.banners = [[NSMutableArray alloc]init];
        [self.banners addObject:@"1"];
        [self.banners addObject:@"2"];[self.banners addObject:@"3"];
        [self.banners addObject:@"4"];[self.banners addObject:@"5"];
        self.backgroundColor = [UIColor whiteColor];
        [self setUpBannerView];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:kNewsPlayTime target:self
                                               selector:@selector(pageTurn:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.bannerCollection setContentOffset:CGPointMake(2500 * frame.size.width, 0) animated:NO];
        });
    }
    return self;
}


- (void)cancelTimer
{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)dealloc
{
    if([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

@end
