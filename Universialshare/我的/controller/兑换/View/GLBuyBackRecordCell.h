//
//  GLBuyBackRecordCell.h
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBuyBackRecordModel.h"

@interface GLBuyBackRecordCell : UITableViewCell

@property(nonatomic, strong)GLBuyBackRecordModel *model;
@property (weak, nonatomic) IBOutlet UILabel *beanTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
