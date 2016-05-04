//
//  NSDate+Extension.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/3.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  判断日期是否是今年
 *
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCmp = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmp = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmp.year == nowCmp.year;
}

/**
 *  判断日期是否是昨天
 *
 */
- (BOOL)isYesterDay
{
    // 2016-4-30 00:00:00
    // 2016-5-1 00:00:00
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *now = [NSDate date];
    
    NSString *dateStr = [formatter stringFromDate:self];
    NSString *nowStr = [formatter stringFromDate:now];
    
    NSDate *date = [formatter dateFromString:dateStr];
    now = [formatter dateFromString:nowStr];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断日期是否是今天
 *
 */
- (BOOL)isToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *now = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:self];
    NSString *nowStr = [formatter stringFromDate:now];
    return [dateStr isEqualToString:nowStr];
}


@end
