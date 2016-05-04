//
//  ZLStatusFrame.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/25.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLStatusFrame.h"
#import "ZLStatus.h"
#import "ZLUser.h"





@implementation ZLStatusFrame


- (void)setStatus:(ZLStatus *)status
{
    _status = status;
    ZLUser *user = status.user;
 
    
    // cell的宽度／整个原创View的宽度／屏幕的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** －－－－原创微博－－－－*/
    /** 头像图片*/
    CGFloat iconWH = 50;
    CGFloat iconX = kStatusCellBorderW;
    CGFloat iconY = kStatusCellBorderW;
    self.iconImageViewFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称*/
    CGFloat nameX = CGRectGetMaxX(self.iconImageViewFrame) + kStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithfont:kStatusCellNameFont];
//    self.nameLabelFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    self.nameLabelFrame = (CGRect){{nameX, nameY}, nameSize};
    
    /** VIP图片*/
    if (status.user.isVIP) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelFrame) + kStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipImageViewFrame = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间*/
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelFrame) + kStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithfont:kStatusCellTimeFont];
    self.timeLabelFrame = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源*/
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelFrame) + kStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithfont:kStatusCellSourceFont];
    self.sourceLabelFrame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文*/
    CGFloat contentX = iconX;
        // 正文的y值需要取 头像和时间的最大Y值
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconImageViewFrame), CGRectGetMaxY(self.timeLabelFrame)) + kStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithfont:kStatusCellContentFont maxWidth:maxW];
    self.contentLabelFrame = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图*/
    CGFloat originH = 0;
    if (status.pic_urls.count) {
        CGFloat photoWH = 100;
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelFrame) + kStatusCellBorderW;
        self.photoImageViewFrame = CGRectMake(photoX, photoY, photoWH, photoWH);
        // 原创微博整个的高度
        originH = CGRectGetMaxY(self.photoImageViewFrame) + kStatusCellBorderW;
    }else {
        originH = CGRectGetMaxY(self.contentLabelFrame) + kStatusCellBorderW;
    }
    
    /** 原创微博的整个的view*/
    CGFloat originX = 0;
    CGFloat originY = kStatusCellMargin;
    CGFloat originW = cellW;
    self.originViewFrame = CGRectMake(originX, originY, originW, originH);
    
    CGFloat toolbarY = 0;
    
    /** －－－----被转发微博-----－－－*/
    if (status.retweeted_status) {
        /** 被转发微博的正文 ＋ 昵称*/
        CGFloat retweetContentX = kStatusCellBorderW;
        CGFloat retweetContentY = kStatusCellBorderW;
        CGSize retweetContentSize = [status.retweeted_status.text sizeWithfont:kStatusCellRetweetContentFont maxWidth:maxW];
        self.retweetContentLabelFrame = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博的配图*/
        CGFloat retweetViewH = 0;
        if (status.retweeted_status.pic_urls.count) {
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelFrame) + kStatusCellBorderW;
            CGFloat retweetPhotoWH = 100;
            self.retweetPhotoImageFrame = (CGRect){{retweetPhotoX, retweetPhotoY}, retweetPhotoWH};
            retweetViewH = CGRectGetMaxY(self.retweetPhotoImageFrame) + kStatusCellBorderW;
            
        }else {
            retweetViewH = CGRectGetMaxY(self.retweetContentLabelFrame) + kStatusCellBorderW;
        }
        
        /** 被转发微博的整个View*/
        CGFloat retweetViewX = 0;
        CGFloat retweetViewY = CGRectGetMaxY(self.originViewFrame);
        CGFloat retweetViewW = cellW;
        self.retweetViewFrame = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);

        // 工具条的高度
        toolbarY = CGRectGetMaxY(self.retweetViewFrame);
    
    }else {
        toolbarY = CGRectGetMaxY(self.originViewFrame);
    }
    
    /** －－－－－－－工具条－－－－－－*/
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame);
    
}
@end
