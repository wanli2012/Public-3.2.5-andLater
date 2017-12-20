//
//  LBBurstingWithPopularityCollectionViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBurstingWithPopularityCollectionViewCell.h"

@implementation LBBurstingWithPopularityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(LBRecomendShopModel *)model{
    _model = model;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];
    self.titilelb.text = [NSString stringWithFormat:@"%@",_model.titile];
    self.subtitileLb.text = [NSString stringWithFormat:@"%@",_model.info];
    
    if ([self.titilelb.text rangeOfString:@"null"].location != NSNotFound) {
        self.titilelb.text = @"暂无标题";
    }
    if ([self.subtitileLb.text rangeOfString:@"null"].location != NSNotFound) {
        self.subtitileLb.text = @"暂无描述";
    }

}

@end
