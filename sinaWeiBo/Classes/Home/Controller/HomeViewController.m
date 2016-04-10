//
//  HomeViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "HomeViewController.h"
#import "ZLDropDownMenu.h"
#import "ZLTitleListTableViewController.h"
#import "AFNetworking.h"
#import "AccountTool.h"
#import "ZLTitleButton.h"

@interface HomeViewController ()<ZLDropDownMenuDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获取用户信息（昵称）
    [self setupUserInfo];
}

/**
 *  获取用户信息（昵称）
 */
- (void)setupUserInfo
{
    // https://api.weibo.com/2/users/show.json
    // access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
    // uid	false	int64	需要查询的用户ID。
    
    // 1.请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    
    // 2.请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        // 从沙盒中取出account
    Account *account = [AccountTool account];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    // 3.发送请求
    [session GET:@"https://api.weibo.com/2/users/show.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZLLog(@"请求成功%@",responseObject);
        UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
        NSString *name = responseObject[@"name"];
        [titleBtn setTitle:name forState:UIControlStateNormal];
        // 存储用户名称
        account.name = name;
        [AccountTool saveAccount:account];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"请求失败%@",error);
    }];
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    // 导航栏左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted"];
    
    // 导航栏右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted"];
    
    // 导航栏标题
    ZLTitleButton *titleButton = [[ZLTitleButton alloc] init];
    titleButton.width = 230;
    titleButton.height = 30;
        // 导航栏标题显示用户上一次使用的名称
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [titleButton addTarget:self action: @selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
}
// 什么情况下建议使用imageEdgeInsets、titleEdgeInsets
// 如果按钮内部的图片、文字固定，用这两个属性来设置间距会比较简单。
// 导航栏标题和图片之间的间距
//    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
//    attri[NSFontAttributeName] = titleButton.titleLabel.font;
//    CGFloat titleW = [titleButton.currentTitle sizeWithAttributes:attri].width;
// [UIScreen mainScreen].scale 1,不是Retina屏幕，2是Retina屏幕
// 图片宽度 ＊ scale系数，保证Retina屏幕上的宽度是正确的
//    CGFloat imageW = titleButton.imageView.width * [UIScreen mainScreen].scale;
//    CGFloat titleLabelW = titleButton.titleLabel.width * [UIScreen mainScreen].scale;
//    CGFloat left = imageW + titleLabelW;
//    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);


/**
 *  点击导航栏标题弹出下拉菜单
 *
 *  @param titleBtn 导航栏标题按钮
 */
- (void)titleClick:(UIButton *)titleBtn
{
    // 1.创建下拉菜单
    ZLDropDownMenu *menu = [ZLDropDownMenu menu];
    
    menu.delegate = self;
//    menu.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 300)];
    
    // 因为没有人引用控制器，所以控制器就挂了，完善ZLDropDownMenu,加个方法可以添加内容控制器。或者，在上面写个属性接收控制器
//    ZLTitleListTableViewController *vc = [[ZLTitleListTableViewController alloc] init];
//    menu.contentView = vc.view;
    // 所以。。
    // 2. 设置内容
    ZLTitleListTableViewController *vc = [[ZLTitleListTableViewController alloc] init];
    vc.view.height = 44 * 3;
    vc.view.width = 200;
    menu.contentViewController = vc;
    
    // 3.显示下拉菜单
    [menu showFrom:titleBtn];
    
}

- (void)friendSearch
{
    
}

- (void)pop
{
    
}

#pragma mark -- ZLDropDownMenu的代理方法
- (void)dropDownMenuDidDismiss:(ZLDropDownMenu *)menu
{
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
    titleBtn.selected = NO;
//    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

- (void)dropDownMenuDidShow:(ZLDropDownMenu *)menu
{
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
//    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    titleBtn.selected = YES;


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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
