//
//  LBMineCenterMeeToTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMeeBomodel.h"

@interface LBMineCenterMeeToTableViewCell : UITableViewCell

@property (copy , nonatomic)LBMeeBomodel *model;

@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *meebolb;
@property (weak, nonatomic) IBOutlet UILabel *miquanLb;
@property (weak, nonatomic) IBOutlet UILabel *meeboLb1;


@end
