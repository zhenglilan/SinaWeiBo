//
//  AccountTool.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "AccountTool.h"

@implementation AccountTool
/**  存储帐号信息*/
+ (void)saveAccount:(Account *)account
{
    // 自定义对象存储用NSKeyedArchiver方法
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}

/** 返回帐号信息*/
+(Account *)account
{
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    /* 验证帐号是否过期*/
    // 获得access_token的保质时间
    long long expires_in = [account.expires_in longLongValue];
    // access_token创建时间 ＋ 保质时间
    NSDate *expriesTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    // 比较，if expriesTime <= now 说明过期
    NSComparisonResult result = [expriesTime compare:now];
    /* 
     NSOrderedAscending = -1L,升序,右边 > 左边
     NSOrderedSame, // 一样
     NSOrderedDescending 降序  ，右边 < 左边
     */
    if (result == NSOrderedSame || result == NSOrderedAscending) {
        return nil;
    }
    return account;
    

}
@end
