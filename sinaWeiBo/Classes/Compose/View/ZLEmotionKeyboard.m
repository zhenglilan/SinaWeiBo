//
//  ZLEmotionKeyboard.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/13.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionKeyboard.h"
#import "ZLEmotionTabbar.h"
#import "ZLEmotionListView.h"
#import "ZLEmotions.h"
#import "MJExtension.h"

@interface ZLEmotionKeyboard()<ZLEmotionTabbarDelegate>
/** 用于容纳表情的listView*/
@property (nonatomic, strong)UIView *contentView;

/** 表情列表*/
@property (nonatomic, strong)ZLEmotionListView *recentListView;
@property (nonatomic, strong)ZLEmotionListView *defaultListView;
@property (nonatomic, strong)ZLEmotionListView *emojiListView;
@property (nonatomic, strong)ZLEmotionListView *lxhListView;

/** 表情键盘下面的tabbar*/
@property (nonatomic, weak)ZLEmotionTabbar *tabbar;
@end

@implementation ZLEmotionKeyboard

#pragma mark － 懒加载
- (ZLEmotionListView *)recentListView
{
    if (!_recentListView) {
        _recentListView = [[ZLEmotionListView alloc] init];
    }
    return _recentListView;
}

- (ZLEmotionListView *)defaultListView
{
    if (!_defaultListView) {
        _defaultListView = [[ZLEmotionListView alloc] init];
        _defaultListView.emotions = [self setupEmotionsWithPath:@"EmotionIcons/default/info.plist"];
    }
    return _defaultListView;
}

- (ZLEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        _emojiListView = [[ZLEmotionListView alloc] init];
        _emojiListView.emotions = [self setupEmotionsWithPath:@"EmotionIcons/emoji/info.plist"];
    }
    return _emojiListView;
}

- (ZLEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        _lxhListView = [[ZLEmotionListView alloc] init];
        _lxhListView.emotions = [self setupEmotionsWithPath:@"EmotionIcons/lxh/info.plist"];
    }
    return _lxhListView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (NSArray *)setupEmotionsWithPath:(NSString *)path
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    NSArray *emotionArray = [ZLEmotions mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:filePath] context:nil];
    return emotionArray;
}

#pragma mark - 系统方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ZLEmotionTabbar *tabbar = [[ZLEmotionTabbar alloc] init];
        [self addSubview:tabbar];
        tabbar.delegate = self;
        self.tabbar = tabbar;
        
//        UIView *contentView = [[UIView alloc] init];
//        [self addSubview:contentView];
//        self.contentView = contentView;
       
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. tabbar
    self.tabbar.height = 44;
    self.tabbar.x = 0;
    self.tabbar.width = self.width;
    self.tabbar.y = self.height - self.tabbar.height;
    
    // 2. contentView
    self.contentView.x = self.contentView.y = 0;
    self.contentView.height = self.tabbar.y;
    self.contentView.width = self.width;
    
    
    // 3. 设置各个listView的frame
    UIView *child = [self.contentView.subviews lastObject];
    child.frame = self.contentView.bounds;
}

#pragma mark - ZLEmotionTabbarDelegate
- (void)emotionTabbar:(ZLEmotionTabbar *)tabbar buttonType:(EmotionButtonType)buttonType
{
    // 移除之前显示的控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 根据按钮类型，切换contentView上面的listView
    switch (buttonType) {
        case EmotionButtonTypeRecent:
            [self.contentView addSubview:self.recentListView];
            break;
            
        case EmotionButtonTypeDefault:
            [self.contentView addSubview:self.defaultListView];
            break;
            
        case EmotionButtonTypeEmoji:
            [self.contentView addSubview:self.emojiListView];
            break;
            
        case EmotionButtonTypeLxh:
            [self.contentView addSubview:self.lxhListView];
            break;
            
            
        default:
            break;
    }
//    UIView *child = [self.contentView.subviews lastObject];
//    child.frame = self.contentView.bounds;
    // 重新计算子控件的frame（setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件）

    [self setNeedsLayout];
}



@end
