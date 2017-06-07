//
//  BannerCell.m
//  SmartMall
//
//  Created by JianRongCao on 27/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "BannerCell.h"

@interface BannerCell ()

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation BannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setViewConstraints];
    }
    return self;
}


- (void)setIconUrl:(NSString *)iconUrl
{
    self.iconView.contentMode = UIViewContentModeCenter;
    self.iconView.clipsToBounds = NO;
    [self.iconView setImage:[UIImage imageNamed:@"default_375_250"]];
    if (![RMUtils isValidString:iconUrl]) {
        _iconUrl = @"";
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView.clipsToBounds = YES;
        [self.iconView setImage:[UIImage imageNamed:@"icon_default_nopic"]];
        return ;
    }
    _iconUrl = iconUrl;
    NSURL *url = [NSURL URLWithString:iconUrl];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_375_250"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconView.contentMode = UIViewContentModeScaleAspectFill;
            self.iconView.clipsToBounds = YES;
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    if (![RMUtils isValidString:title]) {
        title = @"";
    }
    _title = title;
    self.nameLabel.text = title;
}

- (void)setViewConstraints
{
    self.backgroundColor = [UIColor redColor];
    WS(ws);
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(ws);
        make.size.mas_equalTo(ws.frame.size);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws).offset(-15);
        make.left.equalTo(ws).offset(15);
        make.right.equalTo(ws).offset(-15);
        make.height.mas_equalTo(20);
    }];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.backgroundColor = RandomColor;
        [self addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font = RM_COMMON_FONT_32PX;
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @"运动从此告别你的手机Ticwatch S运动手表测评";
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

@end
