//
//  ZLStatusFrame;.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/25.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <Foundation/Foundation.h>
// 昵称的字体
#define kStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define kStatusCellTimeFont [UIFont systemFontOfSize:13]
// 来源字体
#define kStatusCellSourceFont kStatusCellTimeFont
// 正文字体
#define kStatusCellContentFont [UIFont systemFontOfSize:15]
// 被转发正文字体
#define kStatusCellRetweetContentFont kStatusCellContentFont
// cell 的间距
#define kStatusCellMargin 10
// cell 的边框宽度
#define kStatusCellBorderW 10


@class ZLStatus;

@interface ZLStatusFrame : NSObject
/** 数据模型*/
@property (nonatomic, strong)ZLStatus *status;

/** 原创微博的整个的view*/
@property (nonatomic, assign)CGRect originViewFrame;
/** 头像图片*/
@property (nonatomic, assign)CGRect iconImageViewFrame;
/** VIP图片*/
@property (nonatomic, assign)CGRect vipImageViewFrame;
/** 配图*/
@property (nonatomic, assign)CGRect photoImageViewFrame;
/** 昵称*/
@property (nonatomic, assign)CGRect nameLabelFrame;
/** 时间*/
@property (nonatomic, assign)CGRect timeLabelFrame;
/** 来源*/
@property (nonatomic, assign)CGRect sourceLabelFrame;
/** 正文*/
@property (nonatomic, assign)CGRect contentLabelFrame;

/** 转发微博*/
/** 转发微博的整个View*/
@property (nonatomic, assign) CGRect retweetViewFrame;
/** 转发微博的正文 ＋ 昵称*/
@property (nonatomic, assign) CGRect retweetContentLabelFrame;
/** 转发微博的配图*/
@property (nonatomic, assign) CGRect retweetPhotoImageFrame;

/** 工具条*/
@property (nonatomic, assign) CGRect toolbarFrame;


/** cell的高度*/
@property (nonatomic, assign)CGFloat cellHeight;

@end 
