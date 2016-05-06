//
//  ZLIconView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/5.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLIconView.h"
#import "ZLUser.h"
#import "UIImageView+WebCache.h"

@interface ZLIconView()
@property(nonatomic, weak) UIImageView *vertified_typeView;
@end

@implementation ZLIconView

- (UIImageView *)vertified_typeView
{
    if (!_vertified_typeView) {
        UIImageView *vertifiedView = [[UIImageView alloc] init];
        [self addSubview:vertifiedView];
        self.vertified_typeView = vertifiedView;
    }
    return _vertified_typeView;
}

- (void)setUser:(ZLUser *)user
{
    _user = user;
    
    // 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 设置加V图片
    switch (user.verified_type) {
        case ZLUserVertifiedTypePersonal: // 个人
            self.vertified_typeView.hidden = NO;
            self.vertified_typeView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case ZLUserVertifiedTypeOrgMedia:
        case ZLUserVertifiedTypeOrgWebsite:
        case ZLUserVertifiedTypeOrgEnterprice:// 官方
            self.vertified_typeView.hidden = NO;
            self.vertified_typeView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case ZLUserVertifiedTypeDaren: // 达人
            self.vertified_typeView.hidden = NO;
            self.vertified_typeView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
             break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.vertified_typeView.size = self.vertified_typeView.image.size;
    CGFloat scale = 0.7;
    self.vertified_typeView.x = self.width - self.vertified_typeView.width * scale;
    self.vertified_typeView.y = self.height - self.vertified_typeView.height * scale;
}
@end
