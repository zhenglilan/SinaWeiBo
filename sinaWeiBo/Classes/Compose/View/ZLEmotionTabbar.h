//
//  ZLEmotionTabbar.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/13.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//  表情的工具条

#import <UIKit/UIKit.h>
@class ZLEmotionTabbar;

typedef NS_ENUM(NSUInteger, EmotionButtonType) {
    EmotionButtonTypeRecent,// 最近
    EmotionButtonTypeDefault,// 默认
    EmotionButtonTypeEmoji,// Emoji
    EmotionButtonTypeLxh // 浪小花
};
@protocol ZLEmotionTabbarDelegate <NSObject>

- (void)emotionTabbar:(ZLEmotionTabbar *)tabbar buttonType:(EmotionButtonType)buttonType;

@end

@interface ZLEmotionTabbar : UIView
@property (nonatomic, assign)id<ZLEmotionTabbarDelegate>delegate;
@end
