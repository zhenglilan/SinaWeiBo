//
//  ZLComposeViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLComposeViewController.h"
#import "AccountTool.h"
#import "ZLPlaceholderTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface ZLComposeViewController ()
@property (nonatomic, weak)ZLPlaceholderTextView *textView;
@end

@implementation ZLComposeViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setupNav];
    
    // 设置输入控件
    [self setupTextView];
    
    // 这个属性默认是Yes：当ScrollView遇到UINavigationBar、UITabBar等控件时，默认会设置scrollView等contentSize
//    self.automaticallyAdjustsScrollViewInsets
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - 初始化方法
/**
 *  设置导航栏
 */
- (void)setupNav {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发微博" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentCenter;
    // 自动换行
    title.numberOfLines = 0;
    title.width = 200;
    title.height = 50;
    
    NSString *name = [AccountTool account].name;
    NSString *prefix = @"发微博";
    if (name) {
        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        // 创建一个带有属性的字符串（比如颜色属性，字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:name]];
        //    [attrStr addAttribute:NSStrokeWidthAttributeName value:@1 range:[str rangeOfString:name]]; // 文字空心
        title.attributedText = attrStr;
        self.navigationItem.titleView = title;
    }else {
        self.title = prefix;
    }
}

/**
 *  设置TextView
 */
- (void)setupTextView {
    
    // 在这个控制器中，textView的contentInset.top默认为64
    ZLPlaceholderTextView *textView = [[ZLPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    textView.placeholder = @"分享新鲜事...";
    self.textView = textView;
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
}

#pragma mark - 监听方法
/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
    
//    if (self.textView.hasText) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }else {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    //https://api.weibo.com/2/statuses/update.json
    /*
    必选	类型及范围	说明
    access_token   string	       采用OAuth授权方式为必填参数，OAuth授权后获得。
    status		   string	       要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
    pic		       binary(NSDate)  要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     */
    
    // 1. 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    
    // 2. 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    parameters[@"access_token"] = account.access_token;
    parameters[@"status"] = self.textView.text;
    
    
    // 3. 发送请求
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    
    // 4. dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
