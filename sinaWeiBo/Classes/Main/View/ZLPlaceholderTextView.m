//
//  ZLPlaceholderTextView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLPlaceholderTextView.h"

@interface ZLPlaceholderTextView()<UITextViewDelegate>
//{
//    UILabel *placeholerL;
//}
@end

@implementation ZLPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 不要设置自己的代理为自己
//        self.delegate = self;
        // 通知
        // 当UITextView的文字发生改变时，那么 UITextView自己就会发出一个UITextViewTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        // 一直可以竖直方向滑动
//        self.alwaysBounceVertical = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 如果有输入文字，直接返回，不画占位文字。
    if (self.hasText) return;
    
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    // 画文字
//    [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attrs];
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat width = rect.size.width - 2 * x;
    CGFloat height = rect.size .height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, width, height);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

- (void)textDidChange
{
    // 重绘 （重新调用）
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}



@end
