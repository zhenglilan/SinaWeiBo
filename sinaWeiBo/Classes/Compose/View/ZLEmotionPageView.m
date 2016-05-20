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
/** 放大镜*/
@property (nonatomic, strong)ZLEmotionPopView *popView;
/** 删除按钮*/
@property (nonatomic, weak)UIButton *deleteBtn;
@end

@implementation ZLEmotionPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [self addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn = deleteBtn;
    }
    return self;
}


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
        UIButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = padding + (i%kEmotionMaxCols) * btnW;
        btn.y = padding + (i/kEmotionMaxCols) * btnH;
    }
    
    // 设置删除按钮的位置
    self.deleteBtn.width = btnW;
    self.deleteBtn.height = btnH;
    self.deleteBtn.x = self.width - padding - btnW;
    self.deleteBtn.y = self.height - btnH;
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
    
    // 几秒之后，popView消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[kSelectedEmotion] = button.emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionDidSelectNotification object:nil userInfo:userInfo];
}

/**
 *  删除按钮被点击
 */
- (void)deleteBtnClick
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kEmotionDidDeleteNotification object:nil];
}
@end
