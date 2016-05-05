//
//  ZLStatusToolbar.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/3.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLStatusToolbar.h"
#import "ZLStatus.h"

@interface ZLStatusToolbar()

@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong)NSMutableArray *separationLineArray;
@property (nonatomic, strong) UIButton *repostBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *attitudeBtn;

@end


@implementation ZLStatusToolbar

/**
 *  懒加载
 *
 */
- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
/**
 *  懒加载
 *
 */
- (NSMutableArray *)separationLineArray
{
    if (!_separationLineArray) {
        _separationLineArray = [NSMutableArray array];
    }
    return _separationLineArray;
}


+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        self.repostBtn = [self setupButtonWithTitle:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupButtonWithTitle:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupButtonWithTitle:@"赞" icon:@"timeline_icon_unlike"];
        
        [self setupSeparationLine];
        [self setupSeparationLine];
        
        
    }
    return self;
}

- (void)setStatus:(ZLStatus *)status
{
    _status = status;
    
//    status.reposts_count = 230000; // 23万
//    status.comments_count = 12345; // 1.2万
//    status.attitudes_count = 490; // 490
    // 转发
    [self setupBtnTitleWithCount:self.status.reposts_count button:self.repostBtn title:@"转发"];
    // 评论
    [self setupBtnTitleWithCount:self.status.comments_count button:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnTitleWithCount:self.status.attitudes_count button:self.attitudeBtn title:@"赞"];
}

/**
 *  设置转发、评论、赞按钮的文字显示内容
 *
 *  @param count 转发、评论、赞的数量
 *  @param btn   按钮
 *  @param title 文字
 */
- (void)setupBtnTitleWithCount:(int)count button:(UIButton *)btn title:(NSString *)title
{
    if (count) {// 有数不为0
        
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d", count];
        }else {
            CGFloat wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}


/**
 *  初始化一个按钮
 *
 *  @param title 文字
 *  @param icon  图片
 */
- (UIButton *)setupButtonWithTitle:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setImageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 5)];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:btn];
    [self.buttonArray addObject:btn];
    return btn;
}

/**
 *  初始化分割线
 */
- (void)setupSeparationLine
{
    UIImageView *separationLine = [[UIImageView alloc] init];
    separationLine.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    separationLine.height = self.height;
    [self addSubview:separationLine];
    [self.separationLineArray addObject:separationLine];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置按钮的frame
    NSInteger btnCount = self.buttonArray.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.buttonArray[i];
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
    }
    
    // 设置分割线的frame
    NSInteger lineCount = self.separationLineArray.count;
    for (int i = 0; i < lineCount; i++) {
        UIImageView *img = self.separationLineArray[i];
        img.width = 1;
        img.height = self.height;
        img.x = (i + 1) * btnW;
        img.y = 0;
    }
}

@end

