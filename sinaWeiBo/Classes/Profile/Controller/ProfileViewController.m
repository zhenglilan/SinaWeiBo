//
//  ProfileViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ProfileViewController.h"
#import "Test1ViewController.h"


@interface ProfileViewController ()
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    ZLLog(@"%@-viewDidLoad", self);
    
}

- (void)setting
{
    Test1ViewController *test1 = [[Test1ViewController alloc] init];
    test1.title = @"测试1界面";
    [self.navigationController pushViewController:test1 animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}



@end
