//
//  LBMineCenterHotPickModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMineCenterHotPickModel : NSObject

@property(nonatomic,assign)NSInteger  count;

+(NSArray *)getIndustryModels:(NSArray *)infos;

@end
