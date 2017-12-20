//
//  LBMyOrderlistHeaderFooterView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderlistHeaderFooterView.h"
#import <Masonry/Masonry.h>

@implementation LBMyOrderlistHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    
    return self;
}

-(void)initerface{

    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureview)];
    [self addGestureRecognizer:tapgesture];
    
    [self addSubview:self.imagev];
    [self addSubview:self.ordermoney];
    [self addSubview:self.orderName];
    [self addSubview:self.orderinfo];
    [self addSubview:self.orderstore];
    [self addSubview:self.imagevo];
    [self addSubview:self.typelabel];
    [self addSubview:self.numlb];
    
  
    [self.imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@80);
    }];
    
    [self.ordermoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.imagev).offset(0);
        make.width.greaterThanOrEqualTo(@30);
        make.height.equalTo(@15);

    }];
    
    [self.orderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imagev.mas_trailing).offset(10);
        make.trailing.equalTo(self.ordermoney.mas_leading).offset(-5);
        make.top.equalTo(self.imagev).offset(0);
        make.height.greaterThanOrEqualTo(@20);
        
    }];
    
    [self.orderinfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imagev.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.orderName.mas_bottom).offset(5);
        make.height.greaterThanOrEqualTo(@15);
        
    }];
    
    [self.orderstore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imagev.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.orderinfo.mas_bottom).offset(5);
        make.height.greaterThanOrEqualTo(@15);
        
    }];
    
    [self.numlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imagev.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.orderstore.mas_bottom).offset(5);
        make.height.greaterThanOrEqualTo(@15);
        
    }];
    
    [self.imagevo mas_makeConstraints:^(MASConstraintMaker *make) {

        make.trailing.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
        
    }];
    
    [self.typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.imagevo.mas_leading).offset(-3);
        make.height.equalTo(@10);
        make.width.greaterThanOrEqualTo(@30);
        make.centerY.equalTo(self.imagevo.mas_centerY);
        
    }];
}

-(void)tapgestureview{
    
    if (self.retrunshowsection) {
        self.retrunshowsection(self.index,self);
    }
    
}

-(UIImageView*)imagev{
    if (!_imagev) {
        _imagev=[[UIImageView alloc]init];
        _imagev.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }
    return _imagev;
}

-(UILabel*)orderName{
    
    if (!_orderName) {
        _orderName=[[UILabel alloc]init];
        _orderName.backgroundColor=[UIColor clearColor];
        _orderName.textColor=[UIColor blackColor];
        _orderName.font=[UIFont systemFontOfSize:12];
        _orderName.numberOfLines = 2;

    }
    
    return _orderName;
    
}

-(UILabel*)ordermoney{
    
    if (!_ordermoney) {
        _ordermoney=[[UILabel alloc]init];
        _ordermoney.textColor=[UIColor redColor];
        _ordermoney.font=[UIFont systemFontOfSize:15];
        _ordermoney.textAlignment = NSTextAlignmentRight;
    }
    
    return _ordermoney;
    
}

-(UILabel*)orderinfo{
    
    if (!_orderinfo) {
        _orderinfo=[[UILabel alloc]init];
        _orderinfo.backgroundColor=[UIColor clearColor];
        _orderinfo.textColor=[UIColor blackColor];
        _orderinfo.font=[UIFont systemFontOfSize:12];
        _orderinfo.numberOfLines = 2;
        
    }
    
    return _orderinfo;
    
}

-(UILabel*)orderstore{
    
    if (!_orderstore) {
        _orderstore=[[UILabel alloc]init];
        _orderstore.backgroundColor=[UIColor clearColor];
        _orderstore.textColor=[UIColor blackColor];
        _orderstore.font=[UIFont systemFontOfSize:12];
        
    }
    
    return _orderstore;
    
}

-(UILabel*)numlb{
    
    if (!_numlb) {
        _numlb=[[UILabel alloc]init];
        _numlb.backgroundColor=[UIColor clearColor];
        _numlb.textColor=[UIColor blackColor];
        _numlb.font=[UIFont systemFontOfSize:12];
        
    }
    
    return _numlb;
    
}

-(UILabel*)typelabel{
    
    if (!_typelabel) {
        _typelabel=[[UILabel alloc]init];
        _typelabel.backgroundColor=[UIColor clearColor];
        _typelabel.textColor=[UIColor blackColor];
        _typelabel.font=[UIFont systemFontOfSize:9];
        _typelabel.text = @"发表评论";
        _typelabel.textAlignment = NSTextAlignmentRight;
        
    }
    
    return _typelabel;
    
}

-(UIImageView*)imagevo{
    if (!_imagevo) {
        _imagevo=[[UIImageView alloc]init];
        _imagevo.image = [UIImage imageNamed:@"下选三角形"];
        _imagevo.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _imagevo;
}

@end
