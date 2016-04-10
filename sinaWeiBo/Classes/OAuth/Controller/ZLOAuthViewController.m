//
//  ZLOAuthViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/24.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLOAuthViewController.h"
#import "AFNetworking.h"
#import "AccountTool.h"
#import "MBProgressHUD.h"

@interface ZLOAuthViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@end

@implementation ZLOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    webView.delegate = self;
    // 2. 用webView加载登录界面（新浪微博提供的）
    /*
        请求地址：https://api.weibo.com/oauth2/authorize
        请求参数：client_id	true	string	申请应用时分配的AppKey。
                redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=132500766&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark -- UIWebView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
    [hud removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    hud.center = self.view.center;
    [self.view addSubview:hud];
    [hud show:YES];
}

// 拦截网址
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1. 获得URL(absoluteString --> 完整的URL字符串)
    NSString *url = request.URL.absoluteString;
    // 2. 判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { // 有地址
        NSInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        [self accessTokenWithCode:code];
        // 禁止加载回调地址
        return NO;
    }
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hud hide:YES];
    [hud removeFromSuperview];
}

// 利用code (code就是授权成功后的request token) 用code换取一个access token
- (void)accessTokenWithCode:(NSString *)code
{
    /*
     url:https://api.weibo.com/oauth2/access_token
     client_id:	申请应用时分配的AppKey。
     client_secret:	申请应用时分配的AppSecret。
     grant_type: 请求的类型，填写authorization_code
     code:	调用authorize获得的code值。
     redirect_uri: 回调地址，需需与注册应用里的回调地址一致。
     */
    // 1.请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
//    session.responseSerializer = [AFJSONResponseSerializer serializer];
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"132500766";
    params[@"client_secret"] = @"3b5bd5b4e11dda9de831541ed32136ad";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.baidu.com";
    // 3. 发送请求
    [session  POST:@"https://api.weibo.com/oauth2/access_token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        [hud hide:YES];
        [hud removeFromSuperview];
        
        // 存储帐号信息（将字典数据转化成对象存储在沙盒中）
        Account *account = [Account accountWithDictionary:responseObject];
        [AccountTool saveAccount:account];
        
        // 封装 切换窗口的根控制器 这段代码 有四种方法： UIWindow的分类，ZLWindowTool; UIViewController的分类，ZLViewControllerTool;
        // 切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"请求失败, %@",error);
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
}
     
@end
