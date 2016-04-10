//
//  AccountTool.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

// 处理帐号相关操作：存储帐号信息，取出帐号，验证帐号

#import <Foundation/Foundation.h>
#import "Account.h"


@interface AccountTool : NSObject
/** 存储帐号信息*/
+ (void)saveAccount:(Account *)account;
/** 返回帐号信息 如果帐号过期，返回nil*/
+ (Account *)account;
@end
