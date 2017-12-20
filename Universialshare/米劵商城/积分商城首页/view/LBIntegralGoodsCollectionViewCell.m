//
//  LBIntegralGoodsCollectionViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralGoodsCollectionViewCell.h"


@implementation LBIntegralGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _imageV.layer.borderWidth = 1;
    _imageV.layer.borderColor = YYSRGBColor(225, 225, 225, 1).CGColor;
}
//收藏
- (IBAction)collectionEvent:(UIButton *)sender {
    
    [self.delegate clickcheckcollectionbutton:self.index];
}


-(void)setModel:(GLintegralGoodsModel *)model{
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:nil];
    self.name.text = [NSString stringWithFormat:@"%@",model.goods_name];
    self.infoLb.text = [NSString stringWithFormat:@"%@",model.goods_info];
    self.price.text = [NSString stringWithFormat:@"¥%@",model.discount];
    if ([model.is_collection integerValue] == 1) {
        self.collectionBt.selected = YES;
    }else{
        self.collectionBt.selected = NO;
    }

}
@end
