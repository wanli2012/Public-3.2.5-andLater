//
//  GLNearby_RecommendMerchatCollectionCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_RecommendMerchatCollectionCell.h"


@interface GLNearby_RecommendMerchatCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GLNearby_RecommendMerchatCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageV.layer.cornerRadius = 5.f;
}

- (void)setModel:(LBRecomendShopModel *)model{
    _model = model;
    self.nameLabel.text = model.shop_name;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    if (self.picImageV.image == nil) {
        self.picImageV.image = [UIImage imageNamed:PlaceHolderImage];
    }
}
@end
