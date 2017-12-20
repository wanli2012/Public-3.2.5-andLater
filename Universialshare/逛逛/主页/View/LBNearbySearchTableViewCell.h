//
//  LBNearbySearchTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLNearby_NearShopModel.h"

@interface LBNearbySearchTableViewCell : UITableViewCell

@property (strong , nonatomic)GLNearby_NeargoodsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;

@end
