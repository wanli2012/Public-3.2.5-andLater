//
//  GLShoppingCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLShoppingCell.h"


@interface GLShoppingCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xiajiaImageV;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UIView *typeview;

@end

@implementation GLShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    self.goodsNamelabel.font = [UIFont systemFontOfSize:ADAPT(15)];
    self.typeview.backgroundColor = YYSRGBColor(0, 0, 0, 0.3);

}
- (void)setModel:(GLShoppingCartModel *)model {
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    _goodsNamelabel.text = model.goods_name;
    _amountLabel.text =[NSString stringWithFormat:@"x%@",model.num];
    _detailLabel.text = model.info;

    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    
//    if (_imageV.image == nil) {
//        _imageV.image = [UIImage imageNamed:@"XRPlaceholder"];
//    }
    //判断是否下架
    if([model.status integerValue] == 2){
        
        self.xiajiaImageV.hidden = NO;
    }else{
        self.xiajiaImageV.hidden = YES;
    }
    
    if ([model.goods_type integerValue] == 1) {
        self.typeLabel.text = @"奖励商品";
    }else{
        self.typeLabel.text = @"米券商品";
        self.specLabel.text = [NSString stringWithFormat:@"规格:%@",model.spec];
    }
    if (model.isSelect == NO) {
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }else{
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        
    }

}


@end
