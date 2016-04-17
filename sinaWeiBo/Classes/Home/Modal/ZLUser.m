//
//  ZLUser.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLUser.h"

@implementation ZLUser
+(instancetype) userWithDictionary:(NSDictionary *)dic
{
    ZLUser *user = [[ZLUser alloc] init];
    user.name = dic[@"name"];
    user.profile_image_url = dic[@"profile_image_url"];
    user.idstr = dic[@"idstr"];
    return user;
}
@end
