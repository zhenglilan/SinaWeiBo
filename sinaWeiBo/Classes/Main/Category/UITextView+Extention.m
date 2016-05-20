//
//  UITextView+Extention.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/18.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "UITextView+Extention.h"

@implementation UITextView (Extention)

- (void)insertAttributedText:(NSAttributedString *)text
{
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock
{
    // 创建图文混排的字符串
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    // 拼接之前的文字（文字和图片）
    [attributeText appendAttributedString:self.attributedText];
    
    // 拼接图片
    NSUInteger loc = self.selectedRange.location;
    [attributeText insertAttributedString:text atIndex:loc];
    
    // 调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attributeText);
    }
    
    self.attributedText = attributeText;
    
    // 移动光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}


@end
