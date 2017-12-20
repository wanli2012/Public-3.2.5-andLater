//
//  LBWaitOrdersHeaderView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBWaitOrdersHeaderView.h"
#import <Masonry/Masonry.h>

@implementation LBWaitOrdersHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
    }

    return self;
}

-(void)initerface{
 
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureSection)];
    [self addGestureRecognizer:tapgesture];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.orderCode];
    [self addSubview:self.orderTime];
    [self addSubview:self.lineview];
    [self addSubview:self.orderStaues];
    [self addSubview:self.wuliuBt];
    [self addSubview:self.sureGetBt];
    
    [self.orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@20);
    }];
    
    [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderCode.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    [self.orderStaues mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderTime.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
    
    [self.sureGetBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderStaues.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];
    
    [self.wuliuBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.sureGetBt.mas_leading).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderStaues.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@80);
    }];

}

-(void)setSectionModel:(LBWaitOrdersModel *)sectionModel{

    if (_sectionModel != sectionModel) {
        _sectionModel = sectionModel;
    }
    
    self.orderCode.text = [NSString stringWithFormat:@"订单号:%@",_sectionModel.order_number];
    self.orderTime.text = [NSString stringWithFormat:@"订单时间:%@",_sectionModel.creat_time];
    
    if ([_sectionModel.order_type isEqualToString:@"1"]) {
         _orderStaues.text = @"订单类型:消费订单";
    }else{
         _orderStaues.text = @"订单类型:米券订单";

    }
    
}

-(void)tapgestureSection{
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    if (self.expandCallback) {
        self.expandCallback(self.sectionModel.isExpanded);
    }

}
//查看物流
-(void)CollectinGoodsBtbtton{

    if (self.returnwuliuBt) {
        self.returnwuliuBt(self.section);
    };

}
//确认收货
-(void)CollectinGoodsBtbttonOne{
    if (self.returnsureGetBt) {
        self.returnsureGetBt(self.section);
    };
    
}

-(UILabel*)orderCode{
    
    if (!_orderCode) {
        _orderCode=[[UILabel alloc]init];
        _orderCode.backgroundColor=[UIColor clearColor];
        _orderCode.textColor=[UIColor blackColor];
        _orderCode.font=[UIFont systemFontOfSize:13];
        _orderCode.text = @"订单号:";
    }
    
    return _orderCode;
    
}
-(UILabel*)orderTime{
    
    if (!_orderTime) {
        _orderTime=[[UILabel alloc]init];
        _orderTime.backgroundColor=[UIColor clearColor];
        _orderTime.textColor=[UIColor blackColor];
        _orderTime.font=[UIFont systemFontOfSize:13];
        _orderTime.text = @"订单时间:";
        
    }
    
    return _orderTime;
    
}
-(UILabel*)orderStaues{
    
    if (!_orderStaues) {
        _orderStaues=[[UILabel alloc]init];
        _orderStaues.backgroundColor=[UIColor clearColor];
        _orderStaues.textColor=[UIColor blackColor];
        _orderStaues.font=[UIFont systemFontOfSize:13];
        
    }
    
    return _orderStaues;
    
}
-(UIView*)lineview{
    
    if (!_lineview) {
        
        _lineview=[[UIView alloc]init];
        _lineview.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
    }
    
    return _lineview;
}

-(UIButton*)wuliuBt{
    
    if (!_wuliuBt) {
        _wuliuBt=[[UIButton alloc]init];
        _wuliuBt.backgroundColor=TABBARTITLE_COLOR;
        [_wuliuBt setTitle:@"查看物流" forState:UIControlStateNormal];
        _wuliuBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_wuliuBt addTarget:self action:@selector(CollectinGoodsBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_wuliuBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _wuliuBt.layer.cornerRadius =4;
        _wuliuBt.clipsToBounds =YES;
    }
    
    return _wuliuBt;
    
}

-(UIButton*)sureGetBt{
    
    if (!_sureGetBt) {
        _sureGetBt=[[UIButton alloc]init];
        _sureGetBt.backgroundColor=TABBARTITLE_COLOR;
        [_sureGetBt setTitle:@"确认收货" forState:UIControlStateNormal];
        _sureGetBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_sureGetBt addTarget:self action:@selector(CollectinGoodsBtbttonOne) forControlEvents:UIControlEventTouchUpInside];
        [_sureGetBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureGetBt.layer.cornerRadius =4;
        _sureGetBt.clipsToBounds =YES;
        
    }
    
    return _sureGetBt;
    
}
@end
