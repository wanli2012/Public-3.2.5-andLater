//
//  LBStoreSendGoodsTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreSendGoodsTableViewCell.h"

@implementation LBStoreSendGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 4;
    self.button.clipsToBounds = YES;
    
}
//发货
- (IBAction)sendGoodsEvent:(UIButton *)sender {
    [self.delegete clickSendGoods:self.indexpath name:_WaitOrdersListModel.user_name];
}

-(void)setWaitOrdersListModel:(LBSendGoodsProductModel *)WaitOrdersListModel{
    _WaitOrdersListModel = WaitOrdersListModel;

    self.codelb.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"x%@  ¥%@",_WaitOrdersListModel.goods_num,_WaitOrdersListModel.goods_price];
   self.namelb.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_info];
    self.timelb.text = [NSString stringWithFormat:@"消费者: %@",_WaitOrdersListModel.user_name];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_WaitOrdersListModel.thumb] placeholderImage:[UIImage imageNamed:@"planceholder"]];
    
    if (_WaitOrdersListModel.goods_spec == nil || [_WaitOrdersListModel.goods_spec rangeOfString:@"null"].location != NSNotFound || _WaitOrdersListModel.goods_spec.length <= 0) {
         self.goods_specLb.text = [NSString stringWithFormat:@"规格: 默认"];
    }else{
         self.goods_specLb.text = [NSString stringWithFormat:@"规格: %@",_WaitOrdersListModel.goods_spec];
    }
    
    if ([_WaitOrdersListModel.is_receipt isEqualToString:@"2"]) {
        self.button.backgroundColor = TABBARTITLE_COLOR;
        [self.button setTitle:@"发货" forState:UIControlStateNormal];
        self.button.userInteractionEnabled = YES;
    }else {
        self.button.backgroundColor = [UIColor grayColor];
        self.button.userInteractionEnabled = NO;
        [self.button setTitle:@"已发货" forState:UIControlStateNormal];
    }
}

-(void)setWaitOrdersListModelone:(LBSendGoodsProductModel *)WaitOrdersListModelone{
    _WaitOrdersListModelone = WaitOrdersListModelone;
    
    self.codelb.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModelone.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"x%@  ¥%@",_WaitOrdersListModelone.goods_num,_WaitOrdersListModelone.goods_price];
    self.namelb.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModelone.goods_info];
    self.timelb.text = [NSString stringWithFormat:@"消费者: %@",_WaitOrdersListModelone.user_name];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_WaitOrdersListModelone.thumb] placeholderImage:[UIImage imageNamed:@"planceholder"]];
    
    if (_WaitOrdersListModelone.goods_spec == nil || [_WaitOrdersListModelone.goods_spec rangeOfString:@"null"].location != NSNotFound || _WaitOrdersListModelone.goods_spec.length <= 0) {
        self.goods_specLb.text = [NSString stringWithFormat:@"规格: 默认"];
    }else{
        self.goods_specLb.text = [NSString stringWithFormat:@"规格: %@",_WaitOrdersListModelone.goods_spec];
    }
    
   
        self.button.backgroundColor = [UIColor grayColor];
        self.button.userInteractionEnabled = NO;
        [self.button setTitle:@"待确认" forState:UIControlStateNormal];

}
@end
