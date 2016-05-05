//
//  ZLStatusPhotoView.m
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/5.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import "ZLStatusPhotoView.h"
#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"

@interface ZLStatusPhotoView()
@property (nonatomic, weak)UIImageView *gifView;
@end

@implementation ZLStatusPhotoView

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
         UIViewContentModeScaleToFill ： 图片拉伸至填充整个ImageView（图片可能会变形）
         UIViewContentModeScaleAspectFit：图片拉伸至完全显示在ImageView里面位置（图片不会变形）
         UIViewContentModeScaleAspectFill：图片拉伸至 和ImageView等宽或等高，居中显示，（图片不会变形）和clipsToBounds 配合使用
         UIViewContentModeRedraw：调用了setNeedsDisplay方法时，就会将图片重新渲染
         UIViewContentModeCenter：居中显示
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         
         规律：
         1.凡是带有Scale单词的图片，都会拉伸
         2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
         */
        self.backgroundColor = [UIColor redColor];
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都裁剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(ZLPhoto *)photo
{
    _photo = photo;
    
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

//    if ([photo.thumbnail_pic hasSuffix:@"gif"]) {
//        self.gifView.hidden = NO;// 不隐藏
//    }else {
//        self.gifView.hidden = YES;// 隐藏
//    }
    // 判断是否以GIF或者gif结尾
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}
@end
