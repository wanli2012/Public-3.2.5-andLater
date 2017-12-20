//
//  LBMineCenterMeeToTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMeeToTableViewCell.h"

@implementation LBMineCenterMeeToTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(LBMeeBomodel *)model{
    _model = model;
    
    self.timelb.text = _model.addtime;
    self.meebolb.text = [NSString stringWithFormat:@"米宝分: %@",_model.amount];
    self.miquanLb.text = [NSString stringWithFormat:@"米券: %@",_model.voucher];
    self.meeboLb1.text = [NSString stringWithFormat:@"结转米宝: %@",_model.meeple];

}

@end
