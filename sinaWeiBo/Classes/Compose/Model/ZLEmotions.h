//
//  ZLEmotions.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLEmotions : NSObject
/** 表情的文字描述 */
@property (nonatomic, copy)NSString *chs;
/** 表情png图片名*/
@property (nonatomic, copy)NSString *png;
/** emoji表情的16进制编码*/
@property (nonatomic, copy)NSString *code;

@end
