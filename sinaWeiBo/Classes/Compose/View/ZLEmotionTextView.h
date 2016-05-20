//
//  ZLEmotionTextView.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/18.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLPlaceholderTextView.h"
@class ZLEmotions;

@interface ZLEmotionTextView : ZLPlaceholderTextView

- (void)insertEmotion:(ZLEmotions *)emotion;

- (NSAttributedString *)fullText;
@end
