//
//  LBStoreDetailHeaderView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreDetailHeaderView.h"
#import <Masonry/Masonry.h>

@implementation LBStoreDetailHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
        
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return self;
}

-(void)initerface{

    [self addSubview:self.baseView];
    [self.baseView addSubview:self.titleLb];
    [self.baseView addSubview:self.moreBt];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.top.equalTo(self).offset(4);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.baseView).offset(10);
        make.top.equalTo(self.baseView).offset(3);
        make.bottom.equalTo(self.baseView).offset(-3);
        make.width.equalTo(@120);
    }];
    
    [self.moreBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.baseView).offset(-10);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.baseView);
    }];

}

-(void)checkMoreInfo{

    [self.delegete checkmoreinfo:self.index];

}

-(UIView*)baseView{
    
    if (!_baseView) {
        
        _baseView=[[UIView alloc]init];
        _baseView.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _baseView;
}
-(UILabel*)titleLb{
    
    if (!_titleLb) {
        _titleLb=[[UILabel alloc]init];
        _titleLb.backgroundColor=[UIColor clearColor];
        _titleLb.textColor=[UIColor blackColor];
        _titleLb.font=[UIFont systemFontOfSize:14];
        _titleLb.text = @"热卖";
        _titleLb.textAlignment = NSTextAlignmentLeft;
        
    }
    
    return _titleLb;
    
}

-(UIButton*)moreBt{
    
    if (!_moreBt) {
        _moreBt=[[UIButton alloc]init];
        //_moreBt.backgroundColor=TABBARTITLE_COLOR;
        [_moreBt setTitle:@"查看物流" forState:UIControlStateNormal];
        _moreBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_moreBt addTarget:self action:@selector(checkMoreInfo) forControlEvents:UIControlEventTouchUpInside];
        [_moreBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _moreBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    return _moreBt;
    
}

@end
