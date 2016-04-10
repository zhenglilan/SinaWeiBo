//
//  ZLSearchBar.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLSearchBar.h"

@implementation ZLSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 创建左边搜索图标
        // 通过 init 来创建初始化的绝大多数控件，都没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        // 通过 initWithImage 初始化创建的UIImageView默认尺寸是UIImage大小
        //    UIImage *image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        //    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:image];
        searchIcon.width = 30;
        searchIcon.height = 30;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        searchIcon.contentMode = UIViewContentModeCenter;
    }
    return self;
}

+ (instancetype)searchBar
{
    // ［self alloc］init] 会调用 initWithFrame:方法。
    return [[self alloc] init];
}

@end
