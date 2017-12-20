//
//  LBMineCenterHotPickModelF.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterHotPickModelF.h"
#import "LBMineCenterHotPickModel.h"

@implementation LBMineCenterHotPickModelF

+(NSArray *)getIndustryModels:(NSArray *)infos{
    NSMutableArray *dataArr = [@[]mutableCopy];
    [infos enumerateObjectsUsingBlock:^(LBMineCenterHotPickModel*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        LBMineCenterHotPickModelF *model = [[LBMineCenterHotPickModelF alloc]init];
        model.MineCenterHotPickModel = dict;
        [dataArr addObject:model];
        
        
    }];
    return [dataArr mutableCopy];
}

-(void)setMineCenterHotPickModel:(LBMineCenterHotPickModel *)MineCenterHotPickModel{

    _MineCenterHotPickModel = MineCenterHotPickModel;
    
    if (_MineCenterHotPickModel.count == 1) {
        _cellH = 400;
    }else{
       _cellH = 400;
    }
    

}



@end
