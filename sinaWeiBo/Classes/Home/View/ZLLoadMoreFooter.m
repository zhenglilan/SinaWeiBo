//
//  ZLLoadMoreFooter.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/18.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLLoadMoreFooter.h"

@implementation ZLLoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZLLoadMoreFooter" owner:nil options:nil] lastObject];
}
@end
