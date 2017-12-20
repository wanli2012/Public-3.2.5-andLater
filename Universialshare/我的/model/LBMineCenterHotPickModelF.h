//
//  LBMineCenterHotPickModelF.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBMineCenterHotPickModel;

@interface LBMineCenterHotPickModelF : NSObject

@property(nonatomic,assign)CGFloat  cellH;//cell的高度

@property(nonatomic,strong)LBMineCenterHotPickModel *MineCenterHotPickModel;

+(NSArray *)getIndustryModels:(NSArray *)infos;

@end
