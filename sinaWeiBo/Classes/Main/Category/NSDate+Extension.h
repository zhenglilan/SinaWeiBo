//
//  NSDate+Extension.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/3.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  判断日期是否是今年
 *
 */
- (BOOL)isThisYear;

/**
 *  判断日期是否是昨天
 *
 */
- (BOOL)isYesterDay;

/**
 *  判断日期是否是今天
 *
 */
- (BOOL)isToday;
@end
