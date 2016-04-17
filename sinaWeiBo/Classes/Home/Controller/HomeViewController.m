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
#import "UIImageView+WebCache.h"
#import "ZLStatus.h"
#import "MJExtension.h"


@interface HomeViewController ()<ZLDropDownMenuDelegate>
/** 微博数组 （里面放的都是ZLStatus模型，一个ZLStatus对象代表一条微博*/
@property (nonatomic, strong)NSMutableArray *statuses;
@end

@implementation HomeViewController
/**
 *  懒加载
 *
 *  @return statuses
 */
- (NSMutableArray *)statuses
{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获取用户信息（昵称）
    [self setupUserInfo];
    
    // 获取用户所关注人的微博
     [self setupUserStatus];
}

/**
 *  获取用户所关注人的微博
 *  https://api.weibo.com/2/statuses/friends_timeline.json
 *  请求参数：access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得
 *  count	false	int	单页返回的记录条数，最大不超过100，默认为20。
 */
- (void)setupUserStatus
{
    // 1.请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    
    // 2.请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    parameters[@"access_token"] = account.access_token;
//    parameters[@"count"] = @10;
    
    // 3.发送请求
    [session GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        ZLLog(@"关注人微博请求成功－%@",responseObject);
        
        /** 这段代码简化成下面那一句代码。
        // 取得 “微博字典” 数组
        NSArray *dicArray = responseObject[@"statuses"];
        // 将 “微博字典” 转为 “微博模型” 数组
        for (NSDictionary *dictionary in dicArray) {
            ZLStatus *status = [ZLStatus mj_objectWithKeyValues:dictionary];
            [self.statuses addObject:status];
        }
        */
        
        // 将 “微博字典” 转为 “微博模型” 数组(MJExtension，利用下面这个方法，将微博字典数组 转为 微博模型数组)
        self.statuses = [ZLStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"关注人微博请求失败－%@",error);
    }];
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
        //ZLLog(@"请求成功%@",responseObject);
        // 标题按钮
        UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
        // 设置名字(MJExtension: 利用下面这个方法，将字典转化成模型)
        ZLUser *user = [ZLUser mj_objectWithKeyValues:responseObject];
//        NSString *name = responseObject[@"name"];
        [titleBtn setTitle:user.name forState:UIControlStateNormal];
        // 存储用户名称
        account.name = user.name;
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
    
    /* 中间的标题按钮 */
    ZLTitleButton *titleButton = [[ZLTitleButton alloc] init];
    // 设置图片和文字
        // 导航栏标题显示用户上一次使用的名称
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    // 监听标题点击
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"status";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    // 取出这行对应的微博字典
//    NSDictionary *statusDic = [self.statuses objectAtIndex:indexPath.row];
    ZLStatus *status = self.statuses[indexPath.row];
    
    // 设置微博的文字
//    cell.detailTextLabel.text = statusDic[@"text"];
    cell.detailTextLabel.text = status.text;
    
    // 取出微博的用户作者的用户信息（user）
        // 用户名称
//    NSDictionary *userDic = statusDic[@"user"];
//    cell.textLabel.text = userDic[@"name"];
    ZLUser *user = status.user;
    cell.textLabel.text = user.name;
    
        // 用户头像
//    NSString *imageURL = userDic[@"profile_image_url"];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    
    return cell;
}



@end
