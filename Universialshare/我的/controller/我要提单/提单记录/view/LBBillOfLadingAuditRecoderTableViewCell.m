//
//  LBBillOfLadingAuditRecoderTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingAuditRecoderTableViewCell.h"

@interface LBBillOfLadingAuditRecoderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *reasonlb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;


@end

@implementation LBBillOfLadingAuditRecoderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBBillAuditRecoderModel *)model{
    _model = model;

    self.orderId.text = [NSString stringWithFormat:@"订单号:%@",_model.order_num];
    self.priceLb.text = [NSString stringWithFormat:@"订单总额:¥%@      奖励总额:¥%@ ",_model.total_money,_model.total_rl_money];
    if (_model.fail_reason.length>0) {
        self.reasonlb.text = [NSString stringWithFormat:@"原因:%@",_model.fail_reason];
    }
    self.timelb.text = [NSString stringWithFormat:@"%@",_model.addtime];

}

@end
