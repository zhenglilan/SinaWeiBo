//
//  NSString+Extension.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/4.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize) sizeWithfont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}

- (CGSize) sizeWithfont:(UIFont *)font
{
    return [self sizeWithfont:font maxWidth:MAXFLOAT];
}

@end
