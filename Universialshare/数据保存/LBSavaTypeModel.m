//
//  LBSavaTypeModel.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSavaTypeModel.h"

@implementation LBSavaTypeModel

/**< 线程安全的单例创建 */
+ (LBSavaTypeModel *)defaultUser {
    static LBSavaTypeModel *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[LBSavaTypeModel alloc]init];
            model.type = @"1";
        }
        
    });
    
    return model;
}

@end
