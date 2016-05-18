//
//  ZLComposeViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/6.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLComposeViewController.h"
#import "AccountTool.h"
#import "ZLEmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZLComposeToolbar.h"
#import "ZLComposePhotosView.h"
#import "ZLEmotionKeyboard.h"
#import "ZLEmotions.h"


@interface ZLComposeViewController ()<UITextViewDelegate, ZLComposeToolbarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 自定义输入框*/
@property (nonatomic, weak)ZLEmotionTextView *textView;
/** 工具条*/
@property (nonatomic, weak)ZLComposeToolbar *toolbar;
/** 相册（存放拍照或者相册中选择的图片*/
@property (nonatomic, weak)ZLComposePhotosView *photosView;
#warning 一定要用Strong
/** 自定义表情键盘*/
@property (nonatomic, strong)ZLEmotionKeyboard *emotionKeyboard;
@end

@implementation ZLComposeViewController
#pragma mark - 懒加载
/**
 *  自定义键盘懒加载
 *
 */
- (ZLEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[ZLEmotionKeyboard alloc] init];
        _emotionKeyboard.height = 216;
        // 键盘的宽度
        _emotionKeyboard.width = self.view.width;
        // 如果键盘宽度不为零，系统会强制让键盘的宽度等于屏幕的宽度
//        if (self.emotionKeyboard.width > 0) {
//            self.emotionKeyboard.width = [UIScreen mainScreen].bounds.size.width;
//        }
    }
    return _emotionKeyboard;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 设置导航栏
    [self setupNav];
    
    // 添加输入控件
    [self setupTextView];
    
    // 这个属性默认是Yes：当ScrollView遇到UINavigationBar、UITabBar等控件时，默认会设置scrollView等contentSize
//    self.automaticallyAdjustsScrollViewInsets
    
    // 添加工具条
    [self setupToolbar];
    
    // 添加相册
    [self setupPhotosView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}



#pragma mark - 初始化方法
/**
 *  设置相册
 */
- (void)setupPhotosView
{
    ZLComposePhotosView *photosView = [[ZLComposePhotosView alloc] init];
    photosView.x = 10;
    photosView.y = 100;
    photosView.width = self.view.width - 2 * photosView.x;
    photosView.height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

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
 *  添加TextView
 */
- (void)setupTextView {
    
    // 在这个控制器中，textView的contentInset.top默认为64
    ZLEmotionTextView *textView = [[ZLEmotionTextView alloc] init];
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    textView.placeholder = @"分享新鲜事...";
    textView.delegate = self;
    self.textView = textView;
    
    // 让textview成为第一响应者
    [textView becomeFirstResponder];
    
    // 监听文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 监听键盘显示／隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 监听点击表情按钮的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:kEmotionDidSelectNotification object:nil];
}

/**
 *  添加工具条
 */
- (void)setupToolbar
{
    ZLComposeToolbar *toolbar = [[ZLComposeToolbar alloc] init];
    toolbar.height = 44;
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    toolbar.delegate = self;
    
    // inputView 是 设置键盘
//    self.textView.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    // inputAccessoryView 是 设置显示在键盘顶部的内容
//    self.textView.inputAccessoryView = toolbar;

}

#pragma mark - 监听方法
/**
 *  表情按钮被点击了
 *
 */
- (void)emotionDidSelected:(NSNotification *)notification
{
    ZLEmotions *emotion = notification.userInfo[kSelectedEmotion];
    
    if (emotion.code) { // emoji表情
        
        [self.textView insertText:emotion.code.emoji];
    } else if(emotion.png) {// 其他表情
        
        [self.textView insertEmotion:emotion];
    }
}

/**
 *  键盘的frame发生改变时调用 （显示和隐藏）
 *
 */
- (void)keyboardChangeFrame:(NSNotification *)notification
{
    /* notification.userInfo:
     userInfo = {
     // 键盘弹出／隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 383.5}, {375, 283.5}},
     // 键盘弹出／隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出／隐藏动画的节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7,
     }}
     */
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.y = keyboardFrame.origin.y - self.toolbar.height;
    }];
}

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
    if (self.photosView.photos.count) {
        [self sendWithPhotos];
    }else {
        [self sendWithoutPhotos];
    }
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  发送请求带图片
 */
- (void)sendWithPhotos
{
    /*
     https://upload.api.weibo.com/2/statuses/upload.json
     必选	类型及范围	说明
     access_token   string	       采用OAuth授权方式为必填参数，OAuth授权后获得。
     status		   string	       要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     pic		       binary(NSDate)  要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     */
    
    // 1. 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSetsetWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    
    // 2. 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    parameters[@"access_token"] = account.access_token;
    parameters[@"status"] = self.textView.text;
    
    UIImage *img = [self.photosView.photos firstObject];
    NSData *data = UIImageJPEGRepresentation(img, 0.1);
    [parameters setObject:data forKey:@"pic"];
    
    // 3. 发送请求
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *img = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(img, 0.1);
//        [formData appendPartWithHeaders:@{@"ContentType" : @"multipart/form-data, image/jpeg"} body:data];
        [formData appendPartWithFileData:data name:@"pic" fileName:@"text.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showError:@"发送失败"];
    }];
}
/**
 *  发送请求不带图片
 */
- (void)sendWithoutPhotos
{
    //https://api.weibo.com/2/statuses/update.json
    /*
     必选	类型及范围	说明
     access_token   string	       采用OAuth授权方式为必填参数，OAuth授权后获得。
     status		   string	       要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
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
}

#pragma mark - textViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 收键盘
    [self.view endEditing:YES];
}

#pragma mark - ZLComposeToolbarDelegate
- (void)composeToolbar:(ZLComposeToolbar *)toolbar didClickBtn:(ZLComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ZLComposeToolbarButtonTypeCamera:
            [self openCamera];
            break;
        case ZLComposeToolbarButtonTypePicture:
            [self openPicture];
            break;
        case ZLComposeToolbarButtonTypeMention:
            ZLLog(@"@");
            break;
        case ZLComposeToolbarButtonTypeTrend:
            ZLLog(@"＃");
            break;
        case ZLComposeToolbarButtonTypeEmotion:
            [self switchKeyboard];
            break;
        default:
            break;
    }
}

#pragma mark - 其他方法
- (void)switchKeyboard
{
    if (self.textView.inputView == nil) {// 切换到 表情键盘
        
        self.textView.inputView = self.emotionKeyboard;
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
        
    }else { // 切换到系统键盘
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    // 退出键盘
    [self.textView endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
    });
}

- (void)openCamera
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework,利用这个框架可以获得手机上的所有相册图片
    
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openPicture
{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

}

#pragma mark - imagePickerControllerDelegate
/**
 *
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photosView addPhoto:image];
    
}


@end
