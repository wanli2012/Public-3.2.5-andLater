//
//  GLMemberManagerCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMemberManagerCell.h"
@interface GLMemberManagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *allMoenyLb;
@property (weak, nonatomic) IBOutlet UILabel *bonusLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@end

@implementation GLMemberManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GLMemberModel *)model{
    _model = model;
    //消费总额
    if ([model.totalPrice floatValue] > 10000) {
        
        self.allMoenyLb.text = [NSString stringWithFormat:@"%.2f万",[model.totalPrice floatValue] / 10000];
    }else{
        self.allMoenyLb.text = [NSString stringWithFormat:@"%.2f",[model.totalPrice floatValue]];
    }
    //奖金
    if ([model.goods_fl floatValue] > 10000) {
        
        self.bonusLb.text = [NSString stringWithFormat:@"%.2f万",[model.goods_fl floatValue] / 10000];
    }else{
        self.bonusLb.text = [NSString stringWithFormat:@"%.2f",[model.goods_fl floatValue]];
    }
    
    self.nameLb.text = model.truename;
    self.phoneLb.text = model.phone;

}
@end
