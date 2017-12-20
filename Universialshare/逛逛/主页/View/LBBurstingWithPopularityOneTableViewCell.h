//
//  LBBurstingWithPopularityOneTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRecomendShopModel.h"


@interface LBBurstingWithPopularityOneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (strong , nonatomic)LBRecomendShopModel *model;

@end
