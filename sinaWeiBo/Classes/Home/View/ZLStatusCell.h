//
//  ZLStatusCell.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/4/25.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLStatusFrame;

@interface ZLStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableview;

@property (nonatomic, strong)ZLStatusFrame *statusFrame;
@end
