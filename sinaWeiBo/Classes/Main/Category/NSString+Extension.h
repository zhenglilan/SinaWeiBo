//
//  NSString+Extension.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/4.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize) sizeWithfont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize) sizeWithfont:(UIFont *)font;

@end
