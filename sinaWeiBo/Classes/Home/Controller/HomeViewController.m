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
#import "ZLLoadMoreFooter.h"
#import "ZLStatusCell.h"
#import "ZLStatusFrame.h"


@interface HomeViewController ()<ZLDropDownMenuDelegate>
/** 微博数组 （里面放的都是ZLStatusFrame模型，一个ZLStatusFrame对象代表一条微博*/
@property (nonatomic, strong)NSMutableArray *statuseFrames;
@end

@implementation HomeViewController
/**
 *  懒加载
 *
 *  @return statuses
 */
- (NSMutableArray *)statuseFrames
{
    if (!_statuseFrames) {
        _statuseFrames = [NSMutableArray array];
    }
    return _statuseFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kColor(211, 211, 211);
    // 每个大Cell之间的间距－－方法一：设置cell的内边距
//    self.tableView.contentInset = UIEdgeInsetsMake(kStatusCellMargin, 0, 0, 0);
    // 方法二： 原创微博整个的Y＋kstatusCellMargin
    // 方法三： 重写setFrame方法，每个cell都加一定的高度。
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获取用户信息（昵称）
    [self setupUserInfo];
    
    // 加载最新的微博数据
     //[self loadNewStatus];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    // 获取未读数
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer （不管主线程是否正在其他事件）
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    ZLLog(@"viewWillAppear--%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
//}

/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    ZLLoadMoreFooter *footer = [ZLLoadMoreFooter footer];
    self.tableView.tableFooterView = footer;
    footer.hidden = YES;
    
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    
    // 1.添加刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        // 只有用户手动下拉刷新，才会触发UIControlEventValueChanged事件
    [refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [refreshControl beginRefreshing];
    
    // 3.马上加载数据
    [self refreshStateChange:refreshControl];
}

/**
 *  将ZLStatus数组 转为 ZLStatusFrame数组
 *
 *
 */
- (NSArray *)statusFrameWithStatus:(NSArray *)statuses {
    //
    NSMutableArray *frames = [NSMutableArray array];
    for (ZLStatus *status in statuses) {
        ZLStatusFrame *f = [[ZLStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}
/**
 *  UIRefreshControl 进入刷新状态：加载最新数据
 */
- (void)refreshStateChange:(UIRefreshControl *)refreshControl
{
    // 1.请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    
    // 2.请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    parameters[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    ZLStatusFrame *firstStatusFrame = [self.statuseFrames firstObject];
    if (firstStatusFrame) {
        // since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        parameters[@"since_id"] = firstStatusFrame.status.idstr;
    }

    // 3.发送请求
    [session GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        //ZLLog(@"关注人微博请求成功－%@",responseObject);
        
        /** 这段代码简化成下面那一句代码。
         // 取得 “微博字典” 数组
         NSArray *dicArray = responseObject[@"statuses"];
         // 将 “微博字典” 转为 “微博模型” 数组
         for (NSDictionary *dictionary in dicArray) {
         ZLStatus *status = [ZLStatus mj_objectWithKeyValues:dictionary];
         [self.statuses addObject:status];
         }
         */
        
        // 将 “微博字典”数组 转为 “微博模型” 数组(MJExtension，利用下面这个方法，将微博字典数组 转为 微博模型数组)
        NSMutableArray *newStatuses = [ZLStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将ZLStatus数组 转为 ZLStatusFrame数组
        NSArray *newFrames = [self statusFrameWithStatus:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuseFrames insertObjects:newFrames atIndexes:indexSet];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [refreshControl endRefreshing];
        
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"关注人微博请求失败－%@",error);
        // 结束刷新
        [refreshControl endRefreshing];
    }];

}

/**
 *  加载更多的微博数据 （上拉加载更多）
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    
    // 2.拼接请求参数
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    parames[@"access_token"] = account.access_token;
    // 取出最后面的微博（最新的微博，ID最大的微博）
    ZLStatusFrame *lastStatusFrame = [self.statuseFrames lastObject];
    if (lastStatusFrame) {
        // 若指定次参数，则返回ID小于或等于max_id的微博，默认为0
        // id这种数据一般是比较大的，一般转成整数的话，最好是long long类型
        long long maxID = lastStatusFrame.status.idstr.longLongValue - 1;
        parames[@"max_id"] = @(maxID);
    }
    
    
    // 3.发送请求
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将 “微博字典”数组 转为 “微博模型”数组
        NSArray *newStatuses = [ZLStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        NSArray *newStatusFrames = [self statusFrameWithStatus:newStatuses];
        
        // 将更多的微博数据，添加到总数组到最后面
        [self.statuseFrames addObjectsFromArray:newStatusFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新（隐藏footer）
        self.tableView.tableFooterView.hidden = YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.tableView.tableFooterView.hidden = YES;
    }];
    
}

/**
 *  获取未读数
 */
- (void)setupUnreadCount
{
    //ZLLog(@"setupUnreadCount");
    // 1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain", nil];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    // 3.发送请求
    [manager GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //ZLLog(@"未读数%@", responseObject);
        // 设置提醒数字（微博未读数）
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {// 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            // 图标上的未读数
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else { //非零情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(NSInteger)count
{
    // 刷新成功（清空图标数字）
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建Label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    label.y = 64 - label.height;
    
    // 2.设置其他属性
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    if (count == 0) {
        label.text = @"没有新的微博";
    }else {
        label.text = [NSString stringWithFormat:@"%ld条微博更新", count];
    }
    
    // 3.添加 (UIWindow-不行；UITableView-不行，会跟着滚；UINavigation-可以)
    //  label添加到导航控制器的view当中，并且是盖在导航栏下面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画 ： 如果某个动画执行完毕后，又要回到动画执行前状态，建议使用transform来做动画
        // 先利用1S的时间，让label往下移动自己高度的距离
    NSTimeInterval duration = 1.0; // 动画持续时间
    [UIView animateWithDuration:duration animations:^{
//        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
        
    } completion:^(BOOL finished) {
        // 延迟1S，再先利用1S的时间，让label往上移动自己高度的距离（回到一开始的状态）
        NSTimeInterval delay = 1.0; // 延迟1S
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
//            label.y -= label.height;
            label.transform = CGAffineTransformIdentity; // 回到原来的高度
            
        } completion:^(BOOL finished) {
            [label  removeFromSuperview];
        }];
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
    return [self.statuseFrames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLStatusCell *cell = [ZLStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statuseFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLStatusFrame *statusFrames = self.statuseFrames[indexPath.row];
    return statusFrames.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}

/**
 *  scrollView的代理方法
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果tableview没有数据就直接返回
    if (self.statuseFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    // 当最后一个cell完全显示在眼前，contentOffset的y值
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) {
        self.tableView.tableFooterView.hidden = NO;
        [self loadMoreStatus];
    }
}


@end
