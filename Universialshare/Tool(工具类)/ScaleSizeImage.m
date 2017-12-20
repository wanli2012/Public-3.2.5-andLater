//
//  ScaleSizeImage.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "ScaleSizeImage.h"

@implementation ScaleSizeImage
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIColor *) getColor:(NSString *)hexColor
{
    //    unsigned int alpha, red, green, blue;
    //    NSRange range;
    //    range.length =2;
    //
    //    range.location =1;
    //    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];//透明度
    //    range.location =3;
    //    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    //    range.location =5;
    //    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    //    range.location =7;
    //    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    //    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:(float)(alpha/255.0f)];
    
    NSString *color = hexColor;
    // 转换成标准16进制数
    [color stringByReplacingCharactersInRange:[color rangeOfString:@"#" ]  withString:@"0x"];
    // 十六进制字符串转成整形。
    long colorLong = strtoul([color cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    
    //string转color
    UIColor *wordColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    
    return wordColor;
}

+(UIImage *)drawXLine:(UIImageView*)imageview Dsize:(CGSize)Dsize Drect:(CGRect)Drect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint index:(NSInteger)index{
    UIGraphicsBeginImageContext(Dsize);   //开始画线
    [imageview.image drawInRect:Drect];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {1,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    if (index==1) {
        CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1].CGColor);
    }else if (index==3){
        CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
    }
    else if (index == 4){
        CGContextSetStrokeColorWithColor(line, [UIColor grayColor].CGColor);
    }
    else if (index == 2){
        CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor);
    }
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, startPoint.x,startPoint.y);    //开始画线
    CGContextAddLineToPoint(line, endPoint.x, endPoint.y);
    CGContextStrokePath(line);
    
    return UIGraphicsGetImageFromCurrentImageContext();
    
}

@end
