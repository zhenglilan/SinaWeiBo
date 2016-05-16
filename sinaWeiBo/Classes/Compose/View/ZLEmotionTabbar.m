//
//  ZLEmotionTabbar.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/13.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionTabbar.h"
#import "ZLEmotionTabbarButton.h"

@interface ZLEmotionTabbar()
@property (nonatomic, weak)ZLEmotionTabbarButton *selectedBtn;
@end

@implementation ZLEmotionTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:EmotionButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:EmotionButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:EmotionButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:EmotionButtonTypeLxh];

    }
    return self;
}

/**
 *  创建按钮
 *
 */
- (ZLEmotionTabbarButton *)setupBtn:(NSString *)title buttonType:(EmotionButtonType)buttonType
{
    ZLEmotionTabbarButton *btn = [ZLEmotionTabbarButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [self addSubview:btn];

    // 设置默认选择
    if (buttonType == EmotionButtonTypeDefault) {
        [self btnClick:btn];
    }
    
    // 设置背景图片
    NSString *image = nil;
    NSString *selectedImage = nil;
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectedImage = @"compose_emotion_table_left_selected";
    } else if(self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectedImage = @"compose_emotion_table_right_selected";
    }else {
        image = @"compose_emotion_table_mid_normal";
        selectedImage = @"compose_emotion_table_mid_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat btnWidth = self.width / count;
    for (int i = 0; i < count; i++) {
        ZLEmotionTabbarButton *btn = self.subviews[i];
        btn.x = i *btnWidth;
        btn.y = 0;
        btn.height = self.height;
        btn.width = btnWidth;
    }
}

/**
 *  按钮点击
 *
 */
- (void)btnClick:(ZLEmotionTabbarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(emotionTabbar:buttonType:)]) {
        [self.delegate emotionTabbar:self buttonType:btn.tag];
    }
}


@end
