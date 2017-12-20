//
//  LBTextLength.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTextLength : NSObject
//判断一段字符串长度(汉字2字节)
+(NSUInteger)textLength: (NSString *) text;

@end
