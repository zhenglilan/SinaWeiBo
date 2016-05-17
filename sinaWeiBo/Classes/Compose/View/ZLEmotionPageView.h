//
//  ZLEmotionPageView.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/17.
//  Copyright © 2016年 zhenglilan. All rights reserved.
// 用来表示每一页的表情，（里面显示1—～20个表情）

#import <UIKit/UIKit.h>
// 一行中最多7列
#define kEmotionMaxCols 7
// 一页中最多3行
#define kEmotionMaxRows 3
// 每一页表情最多显示个数
#define kEmotionPageSize ((kEmotionMaxCols*kEmotionMaxRows)-1)

@interface ZLEmotionPageView : UIView
/** 每一页的表情（1～20个，里面装的是ZLEmotions模型）*/
@property (nonatomic, strong)NSArray *emotions;
@end
