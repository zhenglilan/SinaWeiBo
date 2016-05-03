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
/** string	微博信息内容*/
@property (nonatomic, copy)NSString *text;

/** object	微博作者的用户信息字段*/
@property (nonatomic, strong)ZLUser *user;

/** 微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	微博来源*/
@property (nonatomic, copy) NSString *source;

/** 配图缩略图 数组*/
@property (nonatomic, strong) NSArray *pic_urls;

/** retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回*/
@property (nonatomic, strong) ZLStatus *retweeted_status;

/**	int	转发数 */
@property (nonatomic, assign) int reposts_count;
/**	int	评论数 */
@property (nonatomic, assign) int comments_count;
/**	int	表态数 */
@property (nonatomic, assign) int attitudes_count;


//+ (instancetype)statusWithDictionary:(NSDictionary *)dic;

@end
