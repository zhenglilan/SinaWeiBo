//
//  ZLComposePhotosView.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLComposePhotosView : UIView

@property (nonatomic, strong, readonly) NSMutableArray *photos;

// @property (nonatomic, strong) NSMutableArray *photos
// 默认会自动生成setter和getter的声明和实现、_开头的成员变量
// 如果手动实现了setter和getter，那么就不会再生成setter和getter的实现、_开头的成员变量

// @property (nonatomic, strong, readonly) NSMutableArray *photos
// 默认会自动生成getter的声明和实现、_开头的成员变量
// 如果手动实现了getter，那么就不会再生成getter的实现、_开头的成员变量。

- (void)addPhoto:(UIImage *)photo;

@end
