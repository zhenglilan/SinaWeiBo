//
//  ZLLNavigationViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/8.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLLNavigationViewController.h"
#import "ItemTool.h"

@interface ZLLNavigationViewController ()

@end

@implementation ZLLNavigationViewController
+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置普通状态
    // key: NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];

    // 设置不可点状态
    // key: NS****AttributeName
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
}

/** 重写这个方法的目的是能够拦截push进来的控制器
 *
 * @param viewController  即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 当程序进入到这一步时，count为0,
    if (self.viewControllers.count > 0) {// 这时push进来的控制器viewController不是根控制器（第一个控制器）
    /* 设置tabbar的显示和隐藏 */
    viewController.hidesBottomBarWhenPushed = YES;
    /* 设置导航栏上面的部分 */
    // 设置左上角按钮图片（方法一：单独创建个类）
    //viewController.navigationItem.leftBarButtonItem = [ItemTool itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highlightedImage:@"navigationbar_back_highlighted"];
    // 方法二：利用category(给 UIBarButtonItem 添加 导航控制器左右按钮的方法)
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highlightedImage:@"navigationbar_back_highlighted"];
        
    
    // 设置右上角按钮图片
    viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(home) image:@"navigationbar_more" highlightedImage:@"navigationbar _more_highlighted"];
    }
    // 先隐藏tabbar,再push
    [super pushViewController:viewController animated:YES]; // count为1
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)home {
    [self popToRootViewControllerAnimated:YES];
}

@end
