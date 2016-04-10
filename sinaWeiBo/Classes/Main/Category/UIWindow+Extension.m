//
//  UIWindow+Extension.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MainTabBarController.h"
#import "ZLNewFeatureViewController.h"

@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    NSString *key = @"CFBundleVersion";
    // 上一次使用的版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([lastVersion isEqualToString:currentVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本号
        self.rootViewController = [[MainTabBarController alloc] init];
    }else {// 版本号不同，这次打开的版本和上一次不一样，显示新特性
        self.rootViewController = [[ZLNewFeatureViewController alloc] init];
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];// 存版本号立刻同步。
    }
}
@end
