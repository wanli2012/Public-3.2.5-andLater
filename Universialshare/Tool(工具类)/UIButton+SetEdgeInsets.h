//
//  UIButton+SetEdgeInsets.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SetEdgeInsets)

//上下居中，图片在上，文字在下
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;


//左右居中，文字在左，图片在右
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing andButtonWidth:(CGFloat)buttonWidth;
- (void)layoutButtonImageTitleSpace:(CGFloat)space;
//左右居中，图片在左，文字在右
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;


//文字居中，图片在左边
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;


//文字居中，图片在右边
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;

@end
