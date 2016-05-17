//
//  ZLEmotionPageView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/17.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionPageView.h"
#import "ZLEmotions.h"

@implementation ZLEmotionPageView
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        // 取表情
        ZLEmotions *emotion = emotions[i];
        if (emotion.png) {
            [btn setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        } else if(emotion.code) {
            // 设置emoji
            [btn setTitle:[emotion.code emoji] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:32];
            }
        [self addSubview:btn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.emotions.count;
    // 边距
    CGFloat padding = 10;
    // 3行7列 （暂时）
    CGFloat btnW = (self.width - 2 * padding) / kEmotionMaxCols;
    CGFloat btnH = (self.height - padding) / kEmotionMaxRows;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = padding + (i%kEmotionMaxCols) * btnW;
        btn.y = padding + (i/kEmotionMaxCols) * btnH;
    }
}
@end
