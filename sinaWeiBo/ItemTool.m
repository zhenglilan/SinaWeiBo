//
//  ItemTool.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/8.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ItemTool.h"

@implementation ItemTool
/**
 * 创建一个item
 *
 * @param action   点击button后调用的方法
 * @param image    普通图片名称
 * @param highlightedImage 高亮图片名称
 * return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)hightlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置左上角按钮图片
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightlightedImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
