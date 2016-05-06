//
//  ZLPlaceholderTextView.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPlaceholderTextView : UITextView

/** 占位文字*/
@property (nonatomic, copy)NSString *placeholder;
/** 占位文字的颜色*/
@property (nonatomic, strong)UIColor *placeholderColor;

@end
