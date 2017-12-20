//
//  GLMyheartRl_typeModel.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyheartRl_typeModel.h"

@implementation GLMyheartRl_typeModel

+ (GLMyheartRl_typeModel *)defaultUser {
    static GLMyheartRl_typeModel *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            
            model = [[GLMyheartRl_typeModel alloc]init];
        }
        
    });
    
    return model;
}

@end
