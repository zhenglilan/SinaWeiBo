//
//  MainTabBarController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/8.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "ZLLNavigationViewController.h"
#import "ZLTabBar.h"

@interface MainTabBarController ()<ZLTabBarDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    // 初始化子控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addchildVC:home  title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    MessageCenterViewController *messageCenter = [[MessageCenterViewController alloc] init];
    [self addchildVC:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addchildVC:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addchildVC:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 更换系统自带的tabbar
//    self.tabBar = [[ZLTabBar alloc] init];// 因为self.tabBar是readonly，不能修改。
    ZLTabBar *tabBar = [[ZLTabBar alloc] init];
    //tabBar.delega  te = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];// 相当于self.tabBar = tabBar;
    
    /*
     [self setValue:tabBar forKeyPath:@"tabBar"];  相当于self.tabBar = tabBar;
     [self setValue:tabBar forKeyPath:@"tabBar"];这行代码过后，tabbar的delegate就是ZLTabbarController.
      说明不用再设置tabBar.delegate = self;
     */
    
    /*
     1. 如果tabbar设置完delegate后，再执行下面代码修改delegate,就会报错。
     tabBar.delegate = self;
     
     2. 如果再次修改tabbar的delegate属性，就会报下面的错误。
     错误信息：Changing the delegate of a tab bar managed by a tab bar controller is not allowed.
     错误一次：不允许修改tabBar的delegate属性，（这个TabBar 是被tabbarController 所管的）
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


//  很多重复代码 ---> 将重复代码抽取到一个方法中
//  1.相同的代码放到一个方法中
//  2.不同的东西变成一个参数
//  3.在使用到这段代码中调用方法  传递参数

/**
 * 添加一个子控制器
 *
 * @param childVC           子控制器
 * @param title             标题
 * @param imageName         图片
 * @param selectedImageName 选中的图片
 **/
- (void)addchildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器标题（导航栏和tabbar）
    childVC.title = title; // 同时设置tabbar标题和navigation标题
//    childVC.tabBarItem.title = title;// 设置tabbar标题
//    childVC.navigationItem.title = title; // 设置navigation标题
    
    // 设置子控制器的图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = kColor(123, 123, 123);
    [childVC.tabBarItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    NSMutableDictionary *selectedTextAttributes = [NSMutableDictionary dictionary];
    selectedTextAttributes[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    
    // 设置子控制背景颜色
    // 控制器创建view 相当于 控制器走了viewDidLoad方法，再设置导航栏到样式就没有用了
//    childVC.view.backgroundColor = kRandomColor;
    
    // 先给外面传进来的小控制器 包装一个导航控制器
    ZLLNavigationViewController *nav = [[ZLLNavigationViewController alloc] initWithRootViewController:childVC];
    // 添加子控制器
    [self addChildViewController:nav];

}

#pragma mark -- ZLTabBar的代理方法
- (void)tabBarDidClickPlusBtn:(ZLTabBar *)tabbar
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor grayColor];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
