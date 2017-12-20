//
//  GLMerchant_IncomeCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLIncomeManagerModel.h"

@interface GLMerchant_IncomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iamgev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UILabel *moneylb;
@property (weak, nonatomic) IBOutlet UILabel *modellb;
@property (weak, nonatomic) IBOutlet UILabel *rlbael;
@property (weak, nonatomic) IBOutlet UILabel *timelb;

@property (strong , nonatomic)GLIncomeManagerModel *model;

@property (strong , nonatomic)GLIncomeManagerModel *model1;

@end
