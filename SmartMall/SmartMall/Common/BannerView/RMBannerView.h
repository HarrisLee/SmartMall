//
//  RMBannerView.h
//  SmartMall
//
//  Created by JianRongCao on 27/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^itemClickedBlock)(NSDictionary *obj);

@interface RMBannerView : UIView

@property (nonatomic, copy) itemClickedBlock itemBlock;

- (void)reloadRecipeList;

- (void)itemClicked:(void (^)(NSDictionary *obj))completion;

- (void)cancelTimer;

@end
