//
//  AppDelegate.m
//  sinaWeiBo 
//
//  Created by 郑丽兰 on 16/3/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLOAuthViewController.h"
#import "AccountTool.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()
@property (nonatomic, assign)UIBackgroundTaskIdentifier task;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    // 2.设置根控制器
    Account *account = [AccountTool account];
        // 判断帐号存在且不过期
    if (account) {
        [self.window switchRootViewController];
    }else {
        self.window.rootViewController = [[ZLOAuthViewController alloc] init];
    }
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  当app进入后台调用
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作、很难再做其他操作
     *  4.后台运行状态
     */
    
    /*
        1. 定义变量UIBackgroundTaskIdentifier task (定义的时候就已经赋值给task了，)
        2. 执行右边的代码
            [application beginBackgroundTaskWithExpirationHandler:^{
                [application endBackgroundTask:task];
            }];
        3.将右边方法返回值赋值给task（因为是局部变量， 所以task还是之前赋值的那个值。）
        解决方法，修饰变量 __block 或者 static(在这里不允许) 或者 变成全局变量，static需要直赋直接值，例如：static int = 10;

     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
            self.task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
           [application endBackgroundTask:self.task];
    }];
    
    /** __block 方法
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
   __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
     */
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // 1.取消下载
    [manager cancelAll];
    // 2.清除内存
    [manager.imageCache clearMemory];
}

@end
