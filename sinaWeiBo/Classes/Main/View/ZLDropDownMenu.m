//
//  ZLDropDownMenu.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/3/16.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLDropDownMenu.h"

@interface ZLDropDownMenu()
@property (nonatomic, strong) UIImageView *containerView;// 可以用强指针，也可以用弱指针；弱指针相对安全一些。如果懒加载，只能用强指针。
@end

@implementation ZLDropDownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        // 添加灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;// 打开交互功能
        [self addSubview:containerView];
        _containerView = containerView;// 创建完containerView再赋值给self.containerView，可以用弱指针。
    }
    return _containerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// 重写set方法
- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    // 调整内容的位置
    _contentView.x = 10;
    _contentView.y = 15;
    
    // 设置灰色图片控件的高度
    self.containerView.height = CGRectGetMaxY(_contentView.frame ) + 10;
    // 设置灰色图片控件的宽度
    self.containerView.width = CGRectGetMaxX(_contentView.frame) + 10;
    
    // 添加内容到灰色图片控件中
    [self.containerView addSubview:self.contentView];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    self.contentView = _contentViewController.view;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)showFrom:(UIView *)from
{
    // 1. 获取最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2. 添加自己到窗口上
    [window addSubview:self];
    
    // 3. 设置尺寸
    self.frame = window.bounds;
    
    // 4.调整灰色图片的位置
    //  默认情况下，frame的是以父控件左上角为坐标原点
    //  转换坐标系
    //CGRect newFrame = [from.superview convertRect:from.frame toView:window]; // 将from.frame的坐标原点 从superview 转换到window, 或者nil,nil指的是window
    CGRect newFrame =  [from convertRect:from.bounds toView:window];// 将from.bounds的坐标原点从 from 转换到window
    self.containerView.y = CGRectGetMaxY(newFrame);
    self.containerView.centerX = CGRectGetMidX(newFrame);
    
    // 通知外界，自己显示了
    [self.delegate dropDownMenuDidShow:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
    
    // 告诉外界，自己销毁了。
    [self.delegate dropDownMenuDidDismiss:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
