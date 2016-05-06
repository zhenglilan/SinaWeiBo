//
//  ZLStatusPhotosView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/5.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLStatusPhotosView.h"
#import "ZLPhoto.h"
#import "ZLStatusPhotoView.h"

#define kPhotoWH 76
#define kPhotoMargin 5
#define kStatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation ZLStatusPhotosView

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSInteger photosCount = photos.count;
   
    // 如果子控件里没有UIImageView，就创建
    // 创建足够数量的imageView
    while (self.subviews.count < photosCount) {
        ZLStatusPhotoView *photoView = [[ZLStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历图片控件，设置图片
    // 取出所有子控件
    for (int i = 0; i < self.subviews.count; i++) {
        ZLStatusPhotoView *photoView = self.subviews[i];
        
        // photos.count = 3;
        // i = 0,1,2
        if (i < photosCount) {
            // 显示
            photoView.hidden  = NO;
            // 设置图片
            photoView.photo = photos[i];
        } else {
            // 隐藏
            photoView.hidden = YES;
        }
    }
}

/**
 *  图片的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
     // 设置图片的尺寸和位置
    NSInteger photosCount = self.photos.count;
    for (int i = 0; i < photosCount; i++) {
        ZLStatusPhotoView *photoView = self.subviews[i];
        
        NSInteger maxCol = kStatusPhotoMaxCol(photosCount);
        NSInteger cols = i % maxCol;
        photoView.x = cols * (kPhotoMargin + kPhotoWH);
        NSInteger row = i / maxCol;
        photoView.y = row = row * (kPhotoMargin + kPhotoWH);
        
        photoView.width = kPhotoWH;
        photoView.height = kPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSInteger)count
{
    // 最大列数
    NSInteger maxCols = kStatusPhotoMaxCol(count);
    // 列数 （宽度）
    NSInteger cols = (count >= maxCols) ? maxCols : count;
    CGFloat photoViewW = cols * kPhotoWH + (cols - 1) * kPhotoMargin;
    
    // 行数 （高度）
    // 行数写法三 (公式)
    NSInteger row = (count + maxCols - 1) / maxCols;
    CGFloat photoViewH = row * kPhotoWH + (row - 1) * kPhotoMargin;
    
    return CGSizeMake(photoViewW, photoViewH);
}

// 行数写法一：
//    NSInteger row = 0;
//    if (count % 3 == 0) {// count = 3 / 6 / 9
//        row = count / 3;
//    }else { // count = 1 / 2 / 4 / 5 / 7 / 8
//        row = count / 3 + 1;
//    }
// 行数写法二
//    NSInteger row = count / 3;
//    if (count % 3 != 0) {
//        row += 1;
//    }
@end
