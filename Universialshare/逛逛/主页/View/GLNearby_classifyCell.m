//
//  GLNearby_classifyCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_classifyCell.h"
#import "GLNearby_ClassifyConcollectionCell.h"
#import "XHStarRateView.h"

@interface GLNearby_classifyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *starview;
@property (weak, nonatomic) IBOutlet UILabel *starLb;
@property (strong, nonatomic) XHStarRateView *starRateView;

@end

@implementation GLNearby_classifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 13)];
    _starRateView.isAnimation = YES;
    _starRateView.rateStyle = IncompleteStar;
    _starRateView.backgroundColor = [UIColor whiteColor];
    [self.starview addSubview:_starRateView];
}
- (void)setModel:(GLNearby_NearShopModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/guangguang",model.store_pic]] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];

    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.shop_address];

    _starRateView.currentScore = [model.pj_mark floatValue];
    if ([model.pj_mark floatValue] <= 0) {
         self.starLb.text = @"暂无评分";
    }else{
         self.starLb.text = [NSString stringWithFormat:@"%.1f",[model.pj_mark floatValue]];
    }
   

    if([model.limit floatValue] > 1000){
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[model.limit floatValue]/1000];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%@m",model.limit];
    }
    
}

-(void)setMerchatModel:(GLNearby_MerchatListModel *)merchatModel{
    _merchatModel = merchatModel;

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/guangguang",_merchatModel.store_pic]] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];
    
    self.nameLabel.text = _merchatModel.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",_merchatModel.shop_address];
    
    _starRateView.currentScore = [_merchatModel.pj_mark floatValue];
    if ([_merchatModel.pj_mark floatValue] <= 0) {
        self.starLb.text = @"暂无评分";
    }else{
        self.starLb.text = [NSString stringWithFormat:@"%.1f",[_merchatModel.pj_mark floatValue]];
    }
    
    if(_merchatModel.limit  > 1000){
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",_merchatModel.limit/1000];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fm",_merchatModel.limit];
    }

}

-(void)setShopmodel:(LBRecomendShopModel *)shopmodel{
    _shopmodel = shopmodel;

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/guangguang",_shopmodel.pic]] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];
    
    self.nameLabel.text = _shopmodel.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",_shopmodel.shop_address];

    self.distanceLabel.hidden = YES;
    
    _starRateView.currentScore = [_shopmodel.pj_mark floatValue];
    if ([_shopmodel.pj_mark floatValue] <= 0) {
        self.starLb.text = @"暂无评分";
    }else{
        self.starLb.text = [NSString stringWithFormat:@"%.1f",[_shopmodel.pj_mark floatValue]];
    }

}

@end
