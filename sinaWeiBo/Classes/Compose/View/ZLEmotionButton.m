//
//  ZLEmotionButton.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/17.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionButton.h"
#import "ZLEmotions.h"

@implementation ZLEmotionButton

/**
 *  当控件不是从xib、storyboard中创建时，就会调用这个方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 *
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/**
 *  这个方法在initWithCoder：方法调用完毕后调用
 */
- (void)awakeFromNib
{
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
}

-(void)setEmotion:(ZLEmotions *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) {// 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if(emotion.code) {// 设置emoji
        [self setTitle:[emotion.code emoji] forState:UIControlStateNormal];
    }
}

@end
