//
//  ZLStatus.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLStatus.h"
#import "ZLPhoto.h"
#import "MJExtension.h"

@implementation ZLStatus
/*
+ (instancetype)statusWithDictionary:(NSDictionary *)dic
{
    ZLStatus *status = [[ZLStatus alloc] init];
    status.idstr = dic[@"idstr"];
    status.text = dic[@"text"];
    status.user = [ZLUser userWithDictionary:dic[@"user"]];
    return status;
}
 */

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"pic_urls": @"ZLPhoto"};
    // 或者
//    return @{@"pic_urls": [ZLPhoto class]};
}

// 重写get方法 (ZLStatusCell.m 中 和 ZLStatusFrame.m 中 create_at 内容得一致，所以重写get方法)
// 数据是实时更新的

/*
 1. 今年
    1> 今天
        * 刚刚 （1分钟以内）
        * 几分钟前 （1分钟～59分钟）
        * 几小时前  (> 59分钟)
    2> 昨天
        * 昨天 XX:XX (几点几分)
    3> 其他
        * XX－XX （月－日）
 2. 非今年
    1> XXXX-XX-XX (年－月－日)
 */

-(NSString *)created_at
{
    //  Tue May 03 18:20:44 +0800 2016
    // E:星期几
    // NSString 转成 NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 如果是真机调试，转换这种欧美时间，需要设置locale
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    // 微博的创建日期
    NSDate *createDate = [formatter dateFromString:_created_at];
    // 当前时间
    NSDate *nowDate = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得那些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmp = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    
    if ([createDate isThisYear]) {// 今年
        if ([createDate isYesterDay]) { // 昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createDate];
            
        } else if ([createDate isToday]) {// 今天
            if (cmp.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前", cmp.hour];
            } else if (cmp.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前",cmp.minute];
            }else {
                return @"刚刚";
            }
        } else { // 其他
            formatter.dateFormat = @"MM-dd";
            return [formatter stringFromDate:createDate];
        }
    }else { // 非今年
        formatter.dateFormat = @"yyyy-MM-dd";
        return [formatter stringFromDate:createDate];
    }
}

// 重写set方法：source，只有在模型赋值的时候调用一次
- (void)setSource:(NSString *)source
{
    _source = source;
    //<a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
    // <a href="http://app.weibo.com/t/feed/1tqBja" rel="nofollow">360安全浏览器</a>
    ZLLog(@"%@",_source);
    // 1.正则表达式 NSRegularExpression
    // 2. 截串 NSString
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"<" options:NSBackwardsSearch].location - range.location;
    _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    
}
@end
