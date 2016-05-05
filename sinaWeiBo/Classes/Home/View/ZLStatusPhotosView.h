//
//  ZLStatusPhotosView.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/5.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLStatusPhotosView : UIView

@property (nonatomic, strong)NSArray *photos;

+ (CGSize)sizeWithCount:(NSInteger)count;
@end
