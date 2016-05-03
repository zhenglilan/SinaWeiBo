//
//  ZLStatusCell.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/25.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLStatusCell.h"
#import "ZLStatusFrame.h"
#import "ZLStatus.h"
#import "UIImageView+WebCache.h"
#import "ZLUser.h"
#import "ZLPhoto.h"
#import "ZLStatusToolbar.h"

@interface ZLStatusCell()
/* 原创微博*/
/** 原创微博的整个的view*/
@property (nonatomic, weak)UIView *originView;
/** 头像*/
@property (nonatomic, weak)UIImageView *iconImageView;
/** VIP*/
@property (nonatomic, weak)UIImageView *vipImageView;
/** 配图*/
@property (nonatomic, weak)UIImageView *photoImageView;
/** 昵称*/
@property (nonatomic, weak)UILabel *nameLabel;
/** 时间*/
@property (nonatomic, weak)UILabel *timeLabel;
/** 来源*/
@property (nonatomic, weak)UILabel *sourceLabel;
/** 正文*/
@property (nonatomic, weak)UILabel *contentLabel;

/* 转发微博*/
/** 转发微博的整个View*/
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博的正文 ＋ 昵称*/
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发微博的配图*/
@property (nonatomic, weak) UIImageView *retweetPhotoImage;

/** 工具条*/
@property (nonatomic, weak) ZLStatusToolbar *toolbar;

@end


@implementation ZLStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *cellID = @"cell";
    ZLStatusCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZLStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)setStatusFrame:(ZLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    ZLStatus *status = statusFrame.status;
    ZLUser *user = status.user;
    
    /**------原创微博-----*/
    self.originView.frame = statusFrame.originViewFrame;
    /** 头像*/
    self.iconImageView.frame = statusFrame.iconImageViewFrame;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 会员图标*/
    if (user.isVIP) {
        self.vipImageView.hidden = NO;
        self.vipImageView.frame = statusFrame.vipImageViewFrame;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipImageView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }else {
        self.vipImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    /** 配图*/
    if (status.pic_urls.count) {
        self.photoImageView.frame = statusFrame.photoImageViewFrame;
        ZLPhoto *photo = [status.pic_urls firstObject];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.photoImageView.hidden = NO;
    }else {
        self.photoImageView.hidden = YES;
    }
    
    /** 昵称*/
    self.nameLabel.frame = statusFrame.nameLabelFrame;
    self.nameLabel.text = user.name;
    
    /** 时间*/
    self.timeLabel.frame = statusFrame.timeLabelFrame;
    self.timeLabel.text = status.created_at;
    
    /** 来源*/
    self.sourceLabel.frame = statusFrame.sourceLabelFrame;
    self.sourceLabel.text = status.source;
    
    /** 正文*/
    self.contentLabel.frame = statusFrame.contentLabelFrame;
    self.contentLabel.text = status.text;
    
    /**------被转发微博微博-----*/
    /** 被转发微博整体*/
    self.retweetView.frame = statusFrame.retweetViewFrame;
    
    /** 被转发微博正文 ＋ 昵称*/
    self.retweetContentLabel.frame = statusFrame.retweetContentLabelFrame;
    ZLStatus *retweetStatus = status.retweeted_status;
    self.retweetContentLabel.text = [NSString stringWithFormat:@"@%@: %@",retweetStatus.user.name, retweetStatus.text];
    self.retweetContentLabel.numberOfLines = 0;
    self.retweetContentLabel.font = kStatusCellRetweetContentFont;
    
    /** 被转发微博配图*/
    if (retweetStatus) {
        self.retweetPhotoImage.hidden = NO;
        self.retweetPhotoImage.frame = statusFrame.retweetPhotoImageFrame;
        ZLPhoto *photo = [retweetStatus.pic_urls firstObject];
        [self.retweetPhotoImage sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

    } else {
        self.retweetPhotoImage.hidden = YES;
    }
    
    /** 工具条*/
    self.toolbar.frame = statusFrame.toolbarFrame;
    self.toolbar.status = status;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 *  
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 选中cell的样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 选中cell的颜色
//        UIView *bg = [[UIView alloc] init];
//        bg.backgroundColor = [UIColor yellowColor];
//        self.selectedBackgroundView = bg;
        
        /** 原创微博*/
        [self setupOriginWeibo];
        
        /** 转发微博*/
        [self setupRetweetWeibo];
        
        /** 工具条*/
        [self setupToolbar];
    }
    return self;
}

/**
 *  原创微博
 */
- (void)setupOriginWeibo
{
    /** 原创微博的整个的view*/
    UIView *originView = [[UIView alloc] init];
    originView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originView];
    self.originView = originView;
    
    /** 头像图片*/
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.originView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    /** VIP图片*/
    UIImageView *vipImageView = [[UIImageView alloc] init];
    vipImageView.contentMode = UIViewContentModeCenter;
    [self.originView addSubview:vipImageView];
    self.vipImageView = vipImageView;
    
    /** 配图*/
    UIImageView *photoImageView = [[UIImageView alloc] init];
    [self.originView addSubview:photoImageView];
    self.photoImageView = photoImageView;
    
    /** 昵称*/
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.originView addSubview:nameLabel];
    nameLabel.font = kStatusCellNameFont;
    self.nameLabel = nameLabel;
    
    /** 时间*/
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.originView addSubview:timeLabel];
    timeLabel.font = kStatusCellTimeFont;
    self.timeLabel = timeLabel;
    
    /** 来源*/
    UILabel *sourceLabel = [[UILabel alloc] init];
    [self.originView addSubview:sourceLabel];
    sourceLabel.font = kStatusCellSourceFont;
    self.sourceLabel = sourceLabel;
    
    /** 正文*/
    UILabel *contentLabel = [[UILabel alloc] init];
    [self.originView addSubview:contentLabel];
    contentLabel.font = kStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
}

/**
 *  转发微博
 */
- (void)setupRetweetWeibo
{
    /** 转发微博的整个View*/
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_retweet_background"]];
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博的正文 ＋ 昵称*/
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    [self.retweetView addSubview:retweetContentLabel];
    retweetContentLabel.numberOfLines = 0;
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博的配图*/
    UIImageView *retweetPhotoImage = [[UIImageView alloc] init];
    [self.retweetView addSubview:retweetPhotoImage];
    self.retweetPhotoImage = retweetPhotoImage;
}

/**
 *  工具条
 */
- (void)setupToolbar
{
    ZLStatusToolbar *toolbar = [ZLStatusToolbar toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}
@end
