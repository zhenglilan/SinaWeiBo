//
//  ZLComposePhotosView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLComposePhotosView.h"

@implementation ZLComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds = YES;
    photoView.image = photo;
    [self addSubview:photoView];
    [self.photos addObject:photo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    NSInteger maxCol = 3;
    NSInteger imgViewMargin = 10;
    CGFloat imgViewWH = (self.width - (maxCol - 1) * imgViewMargin) / maxCol;
   
    for (int i = 0; i < count; i++) {
        UIImageView *photoView = self.subviews[i];
        photoView.width = imgViewWH;
        photoView.height = imgViewWH;
        
        NSInteger col = i % maxCol;
        photoView.x = col * (imgViewWH + imgViewMargin);
        
        NSInteger row = i / maxCol;
        photoView.y = row * (imgViewWH + imgViewMargin);
    }
}

@end
