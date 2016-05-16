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

@interface ZLEmotionKeyboard()<ZLEmotionTabbarDelegate>
@property (nonatomic, weak)ZLEmotionTabbar *tabbar;
@property (nonatomic, weak)ZLEmotionListView *listView;
@end

@implementation ZLEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ZLEmotionTabbar *tabbar = [[ZLEmotionTabbar alloc] init];
        [self addSubview:tabbar];
        self.tabbar = tabbar;
        
        ZLEmotionListView *listView = [[ZLEmotionListView alloc] init];
        [self addSubview:listView];
        listView.backgroundColor = kRandomColor;
        self.listView = listView;
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
    self.tabbar.delegate = self;
    
    // 2. listView
    self.listView.x = self.listView.y  = 0;
    self.listView.height = self.tabbar.y;
    self.listView.width = self.width;
}

#pragma mark - ZLEmotionTabbarDelegate
- (void)emotionTabbar:(ZLEmotionTabbar *)tabbar buttonType:(EmotionButtonType)buttonType
{
    switch (buttonType) {
        case EmotionButtonTypeRecent:
            ZLLog(@"最近");
            break;
            
        case EmotionButtonTypeDefault:{
            NSArray *defaultEmotions = [self getEmotionsWithFilePath:@"EmotionIcons/emoji/info.plist"];
            ZLLog(@"default--%@", defaultEmotions);
            break;
        }
            
        case EmotionButtonTypeEmoji: {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
            NSArray *emojiEmotions = [NSArray arrayWithContentsOfFile:filePath];
            ZLLog(@"emoji--%@", emojiEmotions);
            break;
        }
            
        case EmotionButtonTypeLxh: {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
            NSArray *lxhEmotions = [NSArray arrayWithContentsOfFile:filePath];
            ZLLog(@"lxh--%@",lxhEmotions);
           break;
        }
            
        default:
            break;
    }
}

- (NSArray *)getEmotionsWithFilePath:(NSString *)filePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
    NSArray *emotions = [NSArray arrayWithContentsOfFile:path];
    return emotions;
}

@end
