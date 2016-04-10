//
//  ZLTabBar.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLTabBar;
#warning 因为ZLTabBar继承自UITabBar , 所以成为ZLTabBar的代理，也必须实现UITabBar的代理协议
@protocol ZLTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickPlusBtn:(ZLTabBar *)tabbar;

@end


@interface ZLTabBar : UITabBar
@property (nonatomic, weak) id<ZLTabBarDelegate> delegate;

@end
