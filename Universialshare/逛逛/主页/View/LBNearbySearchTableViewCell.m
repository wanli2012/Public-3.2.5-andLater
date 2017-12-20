//
//  LBNearbySearchTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBNearbySearchTableViewCell.h"

@implementation LBNearbySearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(GLNearby_NeargoodsModel *)model{

    _model = model;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:nil];
    self.namelb.text = [NSString stringWithFormat:@"%@",model.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
}
@end
