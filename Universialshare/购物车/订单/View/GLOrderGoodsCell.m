//
//  GLOrderGoodsCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLOrderGoodsCell.h"


@interface GLOrderGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation GLOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.fanliLabel.layer.cornerRadius = 5.f;
//    self.fanliLabel.clipsToBounds = YES;
//    self.fanliLabel.layer.borderWidth = 1;
//    self.fanliLabel.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setModel:(GLConfirmOrderModel *)model{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.cart_url] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    _nameLabel.text = model.cart_name;
    
    if (model.cart_spec.length <=0) {
        _sumLabel.text = [NSString stringWithFormat:@"数量:  x%@",model.cart_number];
    }else{
        _sumLabel.text = [NSString stringWithFormat:@"[%@]  x%@",model.cart_spec,model.cart_number];
    }
    _detailLabel.text = [NSString stringWithFormat:@"类型:%@",model.cart_type];
    
    if ([model.is_discount integerValue]==1) {
        _fanliLabel.text = [NSString stringWithFormat:@"现价:%@;原价:%@",model.cart_discount,model.cart_price];
        _priceLabel.text = [NSString stringWithFormat:@"折扣价:%@",model.cart_one_price];
    }else{
        _fanliLabel.text = [NSString stringWithFormat:@"原价:%@",model.cart_price];
        _priceLabel.text = [NSString stringWithFormat:@"现价:%@",model.cart_discount];
    }
}

@end
