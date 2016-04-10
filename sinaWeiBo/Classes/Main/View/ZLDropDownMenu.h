//
//  ZLDropDownMenu.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLDropDownMenu;

@protocol ZLDropDownMenuDelegate <NSObject>

@optional
- (void)dropDownMenuDidDismiss:(ZLDropDownMenu *)menu;
- (void)dropDownMenuDidShow:(ZLDropDownMenu *)menu;
@end

@interface ZLDropDownMenu : UIView
+ (instancetype)menu;
// 显示menu
- (void)showFrom:(UIView *)from;
// 移除menu
- (void)dismiss;
// 添加内容到灰色图片控件
@property (nonatomic, strong)UIView *contentView;
// 内容控制器
@property (nonatomic, strong)UIViewController *contentViewController;
@property (nonatomic, weak) id<ZLDropDownMenuDelegate> delegate;

@end
