//
//  ZLEmotionPopView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/17.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionPopView.h"
#import "ZLEmotions.h"
#import "ZLEmotionButton.h"

@interface ZLEmotionPopView()
@property (weak, nonatomic) IBOutlet ZLEmotionButton *emotionButton;

@end

@implementation ZLEmotionPopView
+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZLEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)setEmotion:(ZLEmotions *)emotion
{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}

@end
