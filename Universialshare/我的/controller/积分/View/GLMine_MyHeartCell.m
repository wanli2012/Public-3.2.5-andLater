//
//  GLMine_MyHeartCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyHeartCell.h"

@interface GLMine_MyHeartCell ()

@property (weak, nonatomic) IBOutlet UILabel *consumptionLB;
@property (weak, nonatomic) IBOutlet UILabel *rewardFLb;
@property (weak, nonatomic) IBOutlet UILabel *rewardLB;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRewardLb;

@end

@implementation GLMine_MyHeartCell


- (void)setModel:(GLMyheartModel *)model{
    _model = model;
    
    _consumptionLB.text= [NSString stringWithFormat:@"¥%@",_model.money];
    _rewardFLb.text= [NSString stringWithFormat:@"¥%@",_model.jl_love];
    _rewardLB.text= [NSString stringWithFormat:@"¥%@",_model.zjl];
    _alreadyRewardLb.text= [NSString stringWithFormat:@"¥%@",_model.end_love];


}


@end
