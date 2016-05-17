//
//  ZLEmotionPageView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/17.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionPageView.h"
#import "ZLEmotions.h"
#import "ZLEmotionPopView.h"
#import "ZLEmotionButton.h"

@interface ZLEmotionPageView()
@property (nonatomic, strong)ZLEmotionPopView *popView;
@end

@implementation ZLEmotionPageView

- (ZLEmotionPopView *)popView
{
    if (!_popView) {
        _popView = [ZLEmotionPopView popView];
    }
    return _popView;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        
        ZLEmotionButton *btn = [[ZLEmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        [btn setEmotion: emotions[i]];
        
        // 监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
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

/**
 *  监听按钮点击事件
 *
 *  @param button 被点击的按钮
 */
- (void)btnClick:(ZLEmotionButton *)button
{
    // 给popView传递数据
    self.popView.emotion = button.emotion;
    
    // 取到最上面的Window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.popView];
    
    // 计算出被点击的按钮在window中的坐标
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.popView.y = CGRectGetMidY(btnFrame) - self.popView.height;
    self.popView.centerX = CGRectGetMidX(btnFrame);
}
@end
