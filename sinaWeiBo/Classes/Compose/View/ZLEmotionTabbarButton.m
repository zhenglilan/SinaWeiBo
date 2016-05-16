//
//  ZLEmotionTabbarButton.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/13.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionTabbarButton.h"

@implementation ZLEmotionTabbarButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    // 按钮高亮所做的一切操作都不在了。
}
@end
