//
//  Test1ViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/8.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "Test1ViewController.h"
#import "Text2ViewController.h"


@interface Test1ViewController ()
@end

@implementation Test1ViewController


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    Text2ViewController *text2VC = [[Text2ViewController alloc] init];
    text2VC.title = @"text2测试";
    [self.navigationController pushViewController:text2VC animated:YES];
}


@end
