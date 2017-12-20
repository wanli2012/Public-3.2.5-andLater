//
//  LBBurstingWithPopularityOneTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBurstingWithPopularityOneTableViewCell.h"

@implementation LBBurstingWithPopularityOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBRecomendShopModel *)model{
    _model = model;
   [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:@""]];

}

@end
