//
//  formattime.h
//  幼儿园平台
//
//  Created by admin on 16/1/20.
//  Copyright (c) 2016年 ZhiYiChuangXin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface formattime : NSObject
+ (NSString *)formateTime:(NSString *)time;

+ (NSString *)formateTimeYM:(NSString *)time;

+(NSString *)formateTimeYMD:(NSString*)time;
@end
