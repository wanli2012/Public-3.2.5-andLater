//
//  GLAdModel.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLAdModel.h"

@implementation GLAdModel

+ (NSDictionary *)replacedKeyFromPropertyName{ // 模型的desc属性对应着字典中的description
    return @{@"ID" : @"id"};
}

@end
