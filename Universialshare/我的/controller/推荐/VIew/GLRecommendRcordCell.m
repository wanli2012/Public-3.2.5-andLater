//
//  GLRecommendRcordCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendRcordCell.h"


@interface GLRecommendRcordCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiaofeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinagliLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;


@end

@implementation GLRecommendRcordCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    
//    //是否设置边框以及是否可见
//    [self.pictureV.layer setMasksToBounds:YES];
//    //设置边框圆角的弧度
//    [self.pictureV.layer setCornerRadius:self.pictureV.yy_height * 0.5];
//    //设置边框线的宽
//    
//    [self.pictureV.layer setBorderWidth:1];
//    //设置边框线的颜色
//    [self.pictureV.layer setBorderColor:[[UIColor redColor] CGColor]];
    
}

- (void)setModel:(GLRecommendRecordModel *)model {
    _model = model;

    self.nameLabel.text = model.username;
    self.xiaofeiLabel.text = model.total_money;
    self.jinagliLabel.text = model.zyf_money;
    self.phoneNumLabel.text = model.phone;
    self.IDLabel.text = model.uid;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
    if ([model.group_id integerValue] == [OrdinaryUser integerValue]) {
        self.levelLabel.text = @"会员";
    }
    if ([model.group_id integerValue] == [Retailer integerValue]) {
        self.levelLabel.text = @"商户";
    }
    if ([model.group_id integerValue] == [ONESALER integerValue]) {
         self.levelLabel.text = @"大区创客";
    }
    if ([model.group_id integerValue] == [TWOSALER integerValue]) {
         self.levelLabel.text = @"城市创客";
    }
    if ([model.group_id integerValue] == [THREESALER integerValue]) {
         self.levelLabel.text = @"创客";
    }
    
    
}


@end
