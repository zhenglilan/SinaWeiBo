//
//  ZLTabBar.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLTabBar.h"
@interface ZLTabBar()
@property (nonatomic, weak)UIButton *plusBtn;


@end

@implementation ZLTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(clickPlus) forControlEvents:UIControlEventTouchUpInside];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        self.plusBtn = plusBtn;
        [self addSubview:plusBtn];
    }
    return self;
}
// 加号按钮点击
- (void)clickPlus
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [self.delegate tabBarDidClickPlusBtn:self];
    }
}

- (void)layoutSubviews
{
    
    // 一定要调用。 不能删
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    // 2.设置其他tabBarButton的位置和尺寸
    CGFloat tabbarButtonWidth = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonWidth;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonWidth;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
     
    
   //    NSInteger count = self.subviews.count;
//    for (int i = 0; i <count; i++) {
//        UIView *child = self.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");
//        if ([child isKindOfClass:class]) {
//            // 设置宽度
//            child.width = tabbarButtonWidth;
//            // 设置x
//            child.x = tabbarButtonIndex * tabbarButtonWidth;
//            // 增加索引
//            tabbarButtonIndex++;
//            if(tabbarButtonIndex == 2) {
//                tabbarButtonIndex++;
//            }
//        }
//    }
}

@end
