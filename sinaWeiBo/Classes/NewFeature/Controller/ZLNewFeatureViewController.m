//
//  ZLNewFeatureViewController.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/21.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLNewFeatureViewController.h"
#import "MainTabBarController.h"
#define KNewfeatureCount 4


@interface ZLNewFeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UIScrollView *scrollview;
@end

@implementation ZLNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 创建scrollview，显示所有新特性的图片
    UIScrollView *newFeatureScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    newFeatureScrollView.delegate = self;
    self.scrollview = newFeatureScrollView;
    [self.view addSubview:newFeatureScrollView];

    // 2.添加图片到scrollview中
        // 只获取一次scrollview的宽和高。imageView的宽和高等于scrollview的宽和高
    CGFloat scrollW = newFeatureScrollView.width;
    CGFloat scrollH = newFeatureScrollView.height;
    for (int i = 0; i < KNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        [newFeatureScrollView addSubview:imageView];
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d",i + 1];
        imageView.image = [UIImage imageNamed:name];
        imageView.x = i * scrollW;
        imageView.y = 0;
        
        // 如果是最后一张 imageView， 往里面添加其他内容
        if (i == KNewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
#warning 默认情况下，scrollView一旦创建出来，里面可能就存在一些子控件。
#warning 就算不主动添加子控件到scrollview中，scrollView内部还是可能会有一些子控件
    
    
    // 3.设置scrollview的其他属性
    // 如果想某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可。
    newFeatureScrollView.contentSize = CGSizeMake(KNewfeatureCount * newFeatureScrollView.width, 0);
    newFeatureScrollView.bounces = NO; // 去除弹簧效果
    newFeatureScrollView.pagingEnabled = YES; //分页效果
    newFeatureScrollView.showsHorizontalScrollIndicator = NO; // 水平滚动条隐藏
    
    // 4. 设置 pageController
    UIPageControl *pageC = [[UIPageControl alloc] init];
    pageC.numberOfPages = KNewfeatureCount;
    pageC.centerX = scrollW * 0.5;
    pageC.centerY = scrollH - 50;
    pageC.currentPageIndicatorTintColor = kColor(253, 98, 42);
    pageC.pageIndicatorTintColor = kColor(189, 189, 189);
    self.pageControl = pageC;
    [self.view addSubview:pageC];
    //    UIPageControl就算是没有尺寸，里面的内容还是照常显示。只是点击不了。
    //    pageC.width = 100;
    //    pageC.height = 50;
    //    pageC.userInteractionEnabled = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    ZLLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
    // 四舍五入:只适用于一位小数
    // 1.3  1.3 + 0.5 = 1.8   强转为整数 (int)1.8 = 1
    // 1.5  1.5 + 0.5 = 2     强转为整数 (int)2 =2
    // 1.6  1.6 + 0.5 = 2.1   强转为整数 (int)2.1 =2
    //ZLLog(@"%@",self.scrollview.subviews);
}

// 初始化最后一个imageView
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    // 1.分享给大家按钮
    UIButton *shareBtn = [[UIButton alloc] init];
     shareBtn.width = 150;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareBtn addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [imageView addSubview:shareBtn];
    
    // 2. 开始微博
    UIButton *startSinaBtn = [[UIButton alloc] init];
    [startSinaBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startSinaBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startSinaBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    startSinaBtn.size = startSinaBtn.currentBackgroundImage.size;
    startSinaBtn.centerX = shareBtn.centerX ;
    startSinaBtn.centerY = imageView.height * 0.72;
    [startSinaBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startSinaBtn];
}

- (void)clickToShare:(UIButton *)shareBtn
{
//    if (shareBtn.selected) {
//        shareBtn.selected = NO;
//    }else {
//        shareBtn.selected = YES;
//    }
    // 状态取反。
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startClick
{
    /*
        切换控制器的方法
        1.push （依赖于UINavicationController, 控制器的切换是可逆的，比如A切换到B，B又可以回到A）
        2.modal： 控制器的切换是可逆的.
        3.切换window的rootViewController
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[MainTabBarController alloc] init];
}

- (void)dealloc
{
    ZLLog(@"新特性页面被销毁");
}
@end
