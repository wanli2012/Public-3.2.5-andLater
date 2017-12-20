//
//  LBBillOfLadingAuditRecoderoneTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBillOfLadingModel.h"

@interface LBBillOfLadingAuditRecoderoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *modellb;
@property (weak, nonatomic) IBOutlet UILabel *moneylb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *reasonLb;

@property (strong , nonatomic)LBBillOfLadingModel *model;
@end
