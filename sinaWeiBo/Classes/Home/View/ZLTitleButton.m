//
//  ZLTitleButton.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLTitleButton.h"

#define ZLMargin 10

@implementation ZLTitleButton
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 图片居中
//        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
        // 手动调用layoutSubvies方法
        [self layoutIfNeeded];
        // 测试用
//        self.backgroundColor = [UIColor redColor];
//        self.imageView.backgroundColor = [UIColor yellowColor];
//        self.titleLabel.backgroundColor = [UIColor blueColor];
    }
    return self;
}

// 目的：想在系统计算和设置完按钮的尺寸后，再修改下尺寸
/**
 *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸以后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
 */
//- (void)setFrame:(CGRect)frame
//{
//    frame.size.width += ZLMargin;
//    [super setFrame:frame];
//    
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    ZLLog(@"%@",NSStringFromCGRect(self.titleLabel.frame));
//    ZLLog(@"%@",NSStringFromCGRect(self.imageView.frame));
    
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置为之即可。
    // 1. 计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    // 2. 计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + ZLMargin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}
/**
 *  设置按钮内部的imageView的frame
 *
 *  @param contentRect 按钮的bounds
 *
 */
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x = 80;
//    CGFloat y = 0;
//    CGFloat width = 13;
//    CGFloat height =contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//}

/**
 *  设置按钮内部的titleLabel的frame
 *
 *  @param contentRect 按钮的bounds
 *
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    ZLLog(@"死循环");
//    CGFloat x = 0;
//    CGFloat y = 0;
//    CGFloat width = 80;
//    CGFloat height =contentRect.size.height;
//    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
//    // 一访问titleLabel就会走titleRectForContentRect方法，造成死循环
//    attri[NSFontAttributeName] = self.titleLabel.font;
//    CGFloat titleW = [self.currentTitle sizeWithAttributes:attri].width;
//    return CGRectMake(x, y, titleW, height);
//}

@end
