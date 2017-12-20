//
//  LBBillOfLadingAuditRecoderoneTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingAuditRecoderoneTableViewCell.h"

@implementation LBBillOfLadingAuditRecoderoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBBillOfLadingModel *)model{
    
    _model = model;
    
    if (_model.truename.length <=0) {
         self.userId.text = [NSString stringWithFormat:@"用户:%@",_model.user_name];
    }
    self.userId.text = [NSString stringWithFormat:@"用户:%@",_model.truename];
    self.modellb.text = _model.rlmodel_type;
    self.moneylb.text = [NSString stringWithFormat:@"¥%@",_model.line_money];
    self.timelb.text = _model.addtime;
    if (_model.phone.length >= 11) {
        self.phonelb.text = [NSString stringWithFormat:@"电话:%@*****%@",[_model.phone substringToIndex:3],[_model.phone substringFromIndex:7]];
    }
    
    if (_model.fail_reason.length >0 || [_model.fail_reason rangeOfString:@"null"].location == NSNotFound) {
        self.reasonLb.text = [NSString stringWithFormat:@"拒绝原因:%@",_model.fail_reason];
    }
    
}

@end
