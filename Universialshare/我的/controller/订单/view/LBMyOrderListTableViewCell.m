//
//  LBMyOrderListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderListTableViewCell.h"


@implementation LBMyOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.payBt.layer.borderColor = YYSRGBColor(191, 0, 0, 1).CGColor;
    self.payBt.layer.borderWidth = 1;
    
    self.deleteBt.layer.cornerRadius = 4;
    self.deleteBt.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureEvent:)];
    
    [self.stauesLb addGestureRecognizer:tapgesture];
    
}

- (IBAction)paEvent:(UIButton *)sender {
    
    if (self.retunpaybutton) {
        self.retunpaybutton(self.index);
    }
    
}
//查看进度
- (void)tapgestureEvent:(UITapGestureRecognizer *)sender {
    
    if (_delegete && [_delegete respondsToSelector:@selector(clickTapgesture)]) {
        
        [_delegete clickTapgesture];
    }

}

- (IBAction)deletebutton:(UIButton *)sender {
    
    if (self.retundeletebutton) {
        self.retundeletebutton(self.indexpath);
    }
    
}

-(void)setMyorderlistModel:(LBMyOrdersListModel *)myorderlistModel{
    _myorderlistModel = myorderlistModel;
    
    NSDictionary *dic = (NSDictionary*)_myorderlistModel;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:dic[@"thumb"]] placeholderImage:[UIImage imageNamed:@"熊"]];
    self.namelb.text = [NSString stringWithFormat:@"%@",dic[@"goods_name"]];
    self.numlb.text = [NSString stringWithFormat:@"数量: %@",dic[@"goods_num"]];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",dic[@"goods_price"]];
}

-(void)setMyorderRebateModel:(LBMyorderRebateModel *)myorderRebateModel{
    _myorderRebateModel = myorderRebateModel;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_myorderRebateModel.thumb] placeholderImage:[UIImage imageNamed:@"planceholder"]];
    self.namelb.text = [NSString stringWithFormat:@"%@",_myorderRebateModel.goods_name];
    self.numlb.text = [NSString stringWithFormat:@"数量: %@",_myorderRebateModel.goods_num];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",_myorderRebateModel.goods_price];

    if ([_myorderRebateModel.is_receipt isEqualToString:@"4"]) {//生效
        [self.deleteBt setTitle:@"已奖励" forState:UIControlStateNormal];
        self.deleteBt.backgroundColor = [UIColor grayColor];
        self.deleteBt.userInteractionEnabled = NO;
    }else  if([_myorderRebateModel.is_receipt isEqualToString:@"2"]){//未发货
        [self.deleteBt setTitle:@"未发货" forState:UIControlStateNormal];
        self.deleteBt.backgroundColor = [UIColor grayColor];
        self.deleteBt.userInteractionEnabled = NO;
    }else  if([_myorderRebateModel.is_receipt isEqualToString:@"3"]){//待收货
        [self.deleteBt setTitle:@"待收货" forState:UIControlStateNormal];
        self.deleteBt.backgroundColor = [UIColor grayColor];
        self.deleteBt.userInteractionEnabled = NO;
    }else{
    
        [self.deleteBt setTitle:@"开始奖励" forState:UIControlStateNormal];
        self.deleteBt.backgroundColor = TABBARTITLE_COLOR;
        self.deleteBt.userInteractionEnabled = YES;
    
    }

}

@end
