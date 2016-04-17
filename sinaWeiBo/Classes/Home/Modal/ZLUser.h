//
//  ZLUser.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//
// 用户模型

#import <Foundation/Foundation.h>

@interface ZLUser : NSObject

@property (nonatomic, copy)NSString *idstr;
/**
 *  string	用户头像地址（中图），50×50像素
 */
@property (nonatomic, copy)NSString *profile_image_url;
/**
 *  string	字符串型的用户UID
 */
@property (nonatomic, copy)NSString *name;

+ (instancetype)userWithDictionary:(NSDictionary *)dic;
@end
