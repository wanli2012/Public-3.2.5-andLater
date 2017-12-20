//
//  LBMineCenterHotPickModel.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterHotPickModel.h"

@implementation LBMineCenterHotPickModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        
    }
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //kvc赋值
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)getIndustryWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

+(NSArray *)getIndustryModels:(NSArray *)infos{
    NSMutableArray *dataArr = [@[]mutableCopy];
    [infos enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        LBMineCenterHotPickModel *model = [LBMineCenterHotPickModel getIndustryWithDict:dict];
        [dataArr addObject:model];
    
    }];
    return [dataArr mutableCopy];
}


@end
