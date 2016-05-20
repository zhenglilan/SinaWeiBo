//
//  ZLEmotionTextView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/18.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionTextView.h"
#import "ZLEmotions.h"
#import "ZLEmotionTextAttachment.h"

@implementation ZLEmotionTextView

- (void)insertEmotion:(ZLEmotions *)emotion
{
    if (emotion.code) { // emoji表情
        
        [self insertText:emotion.code.emoji];
    } else if(emotion.png) {// 其他表情

        // 加载图片
        ZLEmotionTextAttachment *attachment = [[ZLEmotionTextAttachment alloc] init];
        // 传模型
        attachment.emotion = emotion;
       
        // 设置图片的大小
        CGFloat imgWH = self.font.lineHeight;
        attachment.bounds = CGRectMake(0, -3, imgWH, imgWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^ (NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
}

- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字，包括图片、emoji、普通文字
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        ZLEmotionTextAttachment *attach = attrs[@"NSAttachment"];
        
        if (attach) { // 有表情图片
            [fullText appendString:attach.emotion.chs];
        }else { // emoji/ 文字
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}
@end
    
    
    
/**
    selectedRange:
    1.本来是用来控制textView的文字选中范围
    2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置。
 
 
    关于textView文字的字体
    1. 如果是普通文字（text），文字大小由textView.font控制
    2. 如果是属性文字（attributedText）, 文字大小不受textView.font控制，应该利用 NSMutableAttributedString的 －(void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
 
 */
