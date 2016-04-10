//
//  ZLTitleButton.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLTitleButton.h"

@implementation ZLTitleButton
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 图片居中
//        self.imageView.contentMode = UIViewContentModeCenter;
        
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.backgroundColor = [UIColor redColor];
        self.imageView.backgroundColor = [UIColor yellowColor];
        self.titleLabel.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    ZLLog(@"%@",NSStringFromCGRect(self.titleLabel.frame));
//    ZLLog(@"%@",NSStringFromCGRect(self.imageView.frame));
    
    
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置为之即可。
    // 1. 计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    // 2. 计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
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
