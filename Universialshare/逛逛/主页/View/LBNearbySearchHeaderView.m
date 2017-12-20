//
//  LBNearbySearchHeaderView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBNearbySearchHeaderView.h"
#import "LBNearbySearchView.h"
#import <Masonry/Masonry.h>

@interface LBNearbySearchHeaderView ()
@property (strong , nonatomic)LBNearbySearchView *view;
@end

@implementation LBNearbySearchHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
    }
    return self;
}

-(void)initerface{

    _view = [[NSBundle mainBundle]loadNibNamed:@"LBNearbySearchView" owner:nil options:nil].firstObject;
    
    [self addSubview:_view];
    
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    _view.starView.enabled = NO;
    _view.starView.type = LCStarRatingViewCountingTypeFloat;
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureshop)];
    [self addGestureRecognizer:tapgesture];
}

-(void)setModel:(GLNearby_NearShopModel *)model{

    _model = model;
    
    [_view.imagev sd_setImageWithURL:[NSURL URLWithString:model.store_pic] placeholderImage:nil];
    _view.namelb.text = [NSString stringWithFormat:@"店名:%@",model.shop_name];
     _view.adresslb.text = [NSString stringWithFormat:@"地址:%@",model.shop_address];
    
    if ([model.limit  integerValue]<  1000) {
        _view.limitlb.text = [NSString stringWithFormat:@"%@m",model.limit];
    }else{
       _view.limitlb.text = [NSString stringWithFormat:@"%ldkm",[model.limit integerValue] / 1000];
    }
    
    _view.starView.progress = [model.pj_mark floatValue];
    

}

-(void)tapgestureshop{

    if (self.retureShopID) {
        self.retureShopID(_model.shop_id);
    }


}

@end
