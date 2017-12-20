//
//  LBBurstingWithPopularityTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRecomendShopModel.h"

@protocol LBBurstingWithPopularitydelegete <NSObject>

-(void)clickBurstingWithPopularity:(NSInteger)index;

@end

@interface LBBurstingWithPopularityTableViewCell : UITableViewCell

@property (strong , nonatomic)NSArray<LBRecomendShopModel*> *dataArr;

@property (assign , nonatomic)id<LBBurstingWithPopularitydelegete> delegte;

@end
