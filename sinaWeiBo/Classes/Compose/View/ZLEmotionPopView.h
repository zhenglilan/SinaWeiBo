//
//  ZLEmotionPopView.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/17.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLEmotions;

@interface ZLEmotionPopView : UIView
+ (instancetype)popView;

@property (nonatomic, strong)ZLEmotions *emotion;
@end
