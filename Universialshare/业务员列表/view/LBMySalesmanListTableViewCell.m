//
//  LBMySalesmanListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListTableViewCell.h"


@interface LBMySalesmanListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *tgLabel;
@property (weak, nonatomic) IBOutlet UILabel *gtLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLb;

@end

@implementation LBMySalesmanListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.imagev.layer.cornerRadius = 35;
    self.imagev.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureimage:)];
    [self.imagev addGestureRecognizer:tap];
    
}

- (void)tapgestureimage:(UITapGestureRecognizer *)sender {
    
    if (self.returntapgestureimage) {
        self.returntapgestureimage(self.index);
    }
}

- (void)setModel:(GLMySalesmanModel *)model{
    
    _model = model;

    if ([self.typestr isEqualToString:@"1"]) {
        self.IDLabel.text=[NSString stringWithFormat:@"用户ID:%@",model.username];
        self.tgLabel.text=[NSString stringWithFormat:@"商家:%@家",model.shop];
        self.gtLabel.text=[NSString stringWithFormat:@"时间:%@",model.addtime];
        self.trueNameLabel.text=[NSString stringWithFormat:@"%@",model.truename];
        self.saleLb.text=[NSString stringWithFormat:@"¥%@",model.money];
        self.shopNumLabel.hidden = YES;
        self.addTimeLabel.hidden = YES;
    }else{
    
        self.IDLabel.text=[NSString stringWithFormat:@"用户ID:%@",model.username];
        self.tgLabel.text=[NSString stringWithFormat:@"创客:%@人",model.djtg];
        self.gtLabel.text=[NSString stringWithFormat:@"城市创客:%@人",model.gjtg];
        self.shopNumLabel.text=[NSString stringWithFormat:@"商家:%@家",model.shop];
        self.addTimeLabel.text=[NSString stringWithFormat:@"推荐时间:%@",model.addtime];
        self.trueNameLabel.text=[NSString stringWithFormat:@"%@",model.truename];
        self.saleLb.text=[NSString stringWithFormat:@"¥%@",model.money];
        self.shopNumLabel.hidden = NO;
        self.addTimeLabel.hidden = NO;
    
    }
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];

}

@end
