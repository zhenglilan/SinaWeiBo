//
//  ZLEmotionTextView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/18.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionTextView.h"
#import "ZLEmotions.h"

@implementation ZLEmotionTextView

- (void)insertEmotion:(ZLEmotions *)emotion
{
    // 创建图文混排的字符串
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    // 拼接之前的文字（文字和图片）
    [attributeText appendAttributedString:self.attributedText];
    
    // 加载图片
    UIImage *image = [UIImage imageNamed:emotion.png];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    // 设置图片的大小
    CGFloat imgWH = self.font.lineHeight;
    attachment.bounds = CGRectMake(0, -3, imgWH, imgWH);
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 拼接图片
    NSUInteger loc = self.selectedRange.location;
    [attributeText insertAttributedString:imageStr atIndex:loc];
    
    // 设置字体
    [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributeText.length)];
    
    self.attributedText = attributeText;
    
    // 移动光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
    
}

/**
    selectedRange:
    1.本来是用来控制textView的文字选中范围
    2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置。
 
 
    关于textView文字的字体
    1. 如果是普通文字（text），文字大小由textView.font控制
    2. 如果是属性文字（attributedText）, 文字大小不受textView.font控制，应该利用 NSMutableAttributedString的 －(void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
 
 */

@end
