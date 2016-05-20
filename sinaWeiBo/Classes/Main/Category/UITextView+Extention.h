//
//  UITextView+Extention.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/18.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extention)
- (void)insertAttributedText:(NSAttributedString *)text;

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString * attributedText))settingBlock;
@end
