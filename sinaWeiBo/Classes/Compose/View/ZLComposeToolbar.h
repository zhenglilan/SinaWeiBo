//
//  ZLComposeToolbar.h
//  sinaWeiBo
//
//  Created by 郑丽兰 on 16/5/7.
//  Copyright © 2016年 zhenglilan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLComposeToolbar;

typedef NS_ENUM(NSUInteger, ZLComposeToolbarButtonType) {
    ZLComposeToolbarButtonTypeCamera, // 照相
    ZLComposeToolbarButtonTypePicture, // 相册
    ZLComposeToolbarButtonTypeMention, // @
    ZLComposeToolbarButtonTypeTrend,  // #
    ZLComposeToolbarButtonTypeEmotion // 表情
};


@protocol ZLComposeToolbarDelegate <NSObject>
- (void)composeToolbar:(ZLComposeToolbar *)toolbar didClickBtn:(ZLComposeToolbarButtonType)buttonType;
@end


@interface ZLComposeToolbar : UIView
@property (nonatomic, assign)id<ZLComposeToolbarDelegate>delegate;
@property (nonatomic, assign)BOOL showKeyboardButton;
@end
