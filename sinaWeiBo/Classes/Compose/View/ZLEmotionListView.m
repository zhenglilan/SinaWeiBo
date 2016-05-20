//
//  ZLEmotionListView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/13.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLEmotionListView.h"
#import "ZLEmotionPageView.h"

@interface ZLEmotionListView()<UIScrollViewDelegate>
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIPageControl *pageControl;
@end

@implementation ZLEmotionListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        // 1.设置scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        // 去除水平方向上的滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        // 去除垂直方向上的滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.设置pageController
        UIPageControl *pageControl = [[UIPageControl alloc] init];
//        pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
//        pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}


- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSInteger pageCount = (emotions.count + kEmotionPageSize - 1) / kEmotionPageSize;
    // 设置页数
    self.pageControl.numberOfPages = pageCount;
    
    // 创建用来显示每一页表情的控件
    for (int i = 0; i < pageCount; i++) {
        ZLEmotionPageView *pageView = [[ZLEmotionPageView alloc] init];
        // 每一页显示的表情的范围
        NSRange range;
        range.location = i * kEmotionPageSize;
        // 剩下的表情个数
        NSInteger leftCount = emotions.count - range.location;
        if (leftCount >= kEmotionPageSize) {// 这一页足够20
            range.length = kEmotionPageSize;
        } else {// 这一页不足20
            range.length = leftCount;
        }
        
        // 每一页显示的表情
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置pageControl的frame
    self.pageControl.x = 0;
    self.pageControl.height = 30;
    self.pageControl.y = self.height - self.pageControl.height;
    self.pageControl.width = self.width;
    
    // 2.设置scrollView的frame
    self.scrollView.x = 0;
    self.scrollView.y = 0;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.width = self.width;
    
    // 3.设置scrollView内部每一页的尺寸
    // scrollView里的子控件里不全是自己手动添加的，还有水平方向上的滚动条和垂直方向上的滚动条
    NSInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
//        if ([self.scrollView.subviews[i] isKindOfClass:[UIImageView class]]) continue;
        ZLEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.width = self.scrollView.width;
        pageView.height = self.scrollView.height;
        pageView.y = 0;
        pageView.x = i * pageView.width;
    }
    
    // 4.设置scrollView的ContentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (NSInteger)(pageNo + 0.5);
}
@end
