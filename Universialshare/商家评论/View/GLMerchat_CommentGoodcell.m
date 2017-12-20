//
//  GLMerchat_CommentGoodsell.m
//  Universialshare

//  Created by 龚磊 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_CommentGoodcell.h"


@interface GLMerchat_CommentGoodCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation GLMerchat_CommentGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMerchat_CommentGoodsModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.goods_name;
    
    //超过一万处理长度
    if([model.goods_price floatValue] > 10000){
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f万",[model.goods_price floatValue] / 10000];
    }else{
        
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.goods_price];
    }
    
    if([model.pl_count floatValue] > 10000){
        self.commentCountLabel.text = [NSString stringWithFormat:@"%.2f万",[model.pl_count floatValue] / 10000];
    }else{
        
        self.commentCountLabel.text = [NSString stringWithFormat:@"%@",model.pl_count];
    }
    
}
@end
