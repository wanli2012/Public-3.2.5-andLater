//
//  ScaleSizeImage.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleSizeImage : NSObject
//具体尺寸改变图片大小
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height;

+(UIColor *) getColor:(NSString *)hexColor;
//画虚线  index用来判断的
+(UIImage *)drawXLine:(UIImageView*)imageview Dsize:(CGSize)Dsize Drect:(CGRect)Drect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint index:(NSInteger)index;
@end
