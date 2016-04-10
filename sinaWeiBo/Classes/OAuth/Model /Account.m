//
//  Account.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/5.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "Account.h"

@implementation Account
+ (instancetype)accountWithDictionary:(NSDictionary *)dic
{
    Account *account = [[self alloc] init];
    account.access_token = dic[@"access_token"];
    account.expires_in = dic[@"expires_in"];
    account.uid = dic[@"uid"];
    
    // access_token创建时间
    account.created_time = [NSDate date];
    
    return account;
}

// 归档（存）
// 当一个对象要归档进沙盒时，会调用这个方法
// 目的：在这个方法中说明这个对象的哪些属性要存进沙盒
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.name forKey:@"name"];
}

// 反归档（取）
// 当从沙盒中解档一个对象中，就会调用这个方法。
// 目的：在这个方法中说明沙盒中的属性该怎么解析。（需要取出哪些属性）
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
