//
//  ZLComposeToolbar.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLComposeToolbar.h"

@interface ZLComposeToolbar()
@property (nonatomic, strong) UIButton *button;
@end


@implementation ZLComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtnWithImage:@"compose_camerabutton_background" highlightImage:@"compose_camerabutton_background_highlighted" type:ZLComposeToolbarButtonTypeCamera];
        [self setupBtnWithImage:@"compose_toolbar_picture" highlightImage:@"compose_toolbar_picture_highlighted" type:ZLComposeToolbarButtonTypePicture];
        [self setupBtnWithImage:@"compose_mentionbutton_background" highlightImage:@"compose_mentionbutton_background_highlighted" type:ZLComposeToolbarButtonTypeMention];
        [self setupBtnWithImage:@"compose_trendbutton_background" highlightImage:@"compose_trendbutton_background_highlighted" type:ZLComposeToolbarButtonTypeTrend];
        self.button = [self setupBtnWithImage:@"compose_emoticonbutton_background" highlightImage:@"compose_emoticonbutton_background_highlighted" type:ZLComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (void) setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    // 默认是表情按钮
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highlightImage = @"compose_emoticonbutton_background_highlighted";
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highlightImage = @"compose_keyboardbutton_background_highlighted";
    }
    [self.button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
}

/**
 *  创建一个按钮
 *
 */
- (UIButton *)setupBtnWithImage:(NSString *)image highlightImage:(NSString *)highlightImage type:(ZLComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)clickBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickBtn:)]) {
        [self.delegate composeToolbar:self didClickBtn:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = 44;
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
        btn.y = 0;
    }
}
@end
