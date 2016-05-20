//
//  ZLEmotionTextAttachment.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/19.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionTextAttachment.h"
#import "ZLEmotions.h"

@implementation ZLEmotionTextAttachment

- (void)setEmotion:(ZLEmotions *)emotion
{
    _emotion = emotion;
    
    UIImage *image = [UIImage imageNamed:emotion.png];
    self.image = image;
}
@end
