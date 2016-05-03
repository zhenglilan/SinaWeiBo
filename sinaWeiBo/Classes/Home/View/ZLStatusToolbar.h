//
//  ZLStatusToolbar.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/3.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLStatus;

@interface ZLStatusToolbar : UIView

@property(nonatomic, strong)ZLStatus *status;

+ (instancetype)toolbar;
@end
