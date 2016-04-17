//
//  ZLStatus.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLUser.h"

@interface ZLStatus : NSObject

/**
*  string	字符串型的微博ID
*/
@property (nonatomic, copy)NSString *idstr;
/**
 *  string	微博信息内容
 */
@property (nonatomic, copy)NSString *text;
/**
 *  object	微博作者的用户信息字段
 */
@property (nonatomic, strong)ZLUser *user;

//+ (instancetype)statusWithDictionary:(NSDictionary *)dic;

@end
