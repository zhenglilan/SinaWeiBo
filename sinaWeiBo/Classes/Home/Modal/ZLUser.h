//
//  ZLUser.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//
// 用户模型

#import <Foundation/Foundation.h>

typedef enum {
    ZLUserVertifiedTypeNone = -1, // 没有任何认证
    
    ZLUserVertifiedTypePersonal = 0, // 个人认证
    
    ZLUserVertifiedTypeOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    ZLUserVertifiedTypeOrgMedia = 3, // 媒体官方:程序员杂志、苹果汇
    ZLUserVertifiedTypeOrgWebsite = 5, // 网站官方：猫扑
    
    ZLUserVertifiedTypeDaren = 220  // 微博达人
    
} ZLUserVertifiedType;

@interface ZLUser : NSObject
/**
 *  string	字符串型的用户UID
 */
@property (nonatomic, copy)NSString *idstr;
/**
 *  string	用户头像地址（中图），50×50像素
 */
@property (nonatomic, copy)NSString *profile_image_url;
/**
 *  string  用户昵称
 */
@property (nonatomic, copy)NSString *name;

/** 会员类型的值> 2 才代表是会员*/
@property (nonatomic, assign) int mbtype;

/** 会员等级*/
@property (nonatomic, assign) int mbrank;

/** 是否是会员*/
@property (nonatomic, assign, getter=isVIP) BOOL VIP;

/** 认证类型*/
@property (nonatomic, assign)ZLUserVertifiedType verified_type;

//+ (instancetype)userWithDictionary:(NSDictionary *)dic;
@end
