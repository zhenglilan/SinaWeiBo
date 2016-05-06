//
//  MessageCenterViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "Test1ViewController.h"

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // style：这个参数是用来设置背景的， 在iOS7之前，效果比较明显。iOS7中没有任何效果（因为iOS7扁平化）
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStyleDone target:self action:@selector(composeMsg)];
    
    // 这个item不能点击 (这样就能显示disable下的主题)
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    ZLLog(@"%@-viewDidLoad", self);


}

- (void)composeMsg
{
    ZLLog(@"composeMsg");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 15;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"message-text-%ld", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Test1ViewController *test1VC = [[Test1ViewController alloc] init];
    test1VC.title = @"test1的页面";
    // 当test1 控制器被push的时候，test1所在的tabBarController的tabBar会自动隐藏
    // 当test1 控制器被pop的时候，test1所在的tabBarController的tabBar会自动显示
//    test1VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test1VC animated:YES];
    
}
@end
