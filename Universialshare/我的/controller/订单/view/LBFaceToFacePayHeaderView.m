//
//  LBFaceToFacePayHeaderView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFaceToFacePayHeaderView.h"
#import <Masonry/Masonry.h>

@implementation LBFaceToFacePayHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
    }
    return self;
}

-(void)initerface{

    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.orderCode];
    [self addSubview:self.orderTime];
    [self addSubview:self.lineview];
    [self addSubview:self.orderStaues];
    [self addSubview:self.DeleteBt];
    [self addSubview:self.orderMoney];
    [self addSubview:self.orderStore];
    
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
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
    
    [self.orderStaues mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderTime.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    [self.orderStore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderStaues.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    [self.orderMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.orderStore.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    
    [self.DeleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        //make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@25);
        make.width.equalTo(@25);
    }];
    
    
}

-(void)setSectionModel:(LBMyOrdersModel *)sectionModel{
    
    if (_sectionModel != sectionModel) {
        _sectionModel = sectionModel;
    }
    
    self.orderCode.text = [NSString stringWithFormat:@"订单号:%@" , _sectionModel.order_num];
    self.orderTime.text = [NSString stringWithFormat:@"店铺:%@" , _sectionModel.shop_name];
    self.orderStaues.text = [NSString stringWithFormat:@"时间:%@" , _sectionModel.addtime];
     self.orderMoney.text = [NSString stringWithFormat:@"金额:¥%@" , _sectionModel.realy_price];
    
    NSRange range = [self.orderMoney.text rangeOfString:_sectionModel.realy_price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.orderMoney.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    self.orderMoney.attributedText = str;
    
    if ([_sectionModel.order_type integerValue] == 1) {
        self.orderStore.text = @"订单类型:消费订单";
    }else if ([_sectionModel.order_type integerValue] == 2){
        self.orderStore.text = @"订单类型:米券订单";
        
    }else if ([_sectionModel.order_type integerValue] == 3){
        self.orderStore.text = @"订单类型:面对面订单";
        
    }
    
}


//删除
-(void)delegeteEvent{
    
    if (self.returnDeleteBt) {
        self.returnDeleteBt(self.section);
    }
}

-(UILabel*)orderCode{
    
    if (!_orderCode) {
        _orderCode=[[UILabel alloc]init];
        _orderCode.backgroundColor=[UIColor clearColor];
        _orderCode.textColor=[UIColor blackColor];
        _orderCode.font=[UIFont systemFontOfSize:13];
    }
    
    return _orderCode;
    
}
-(UILabel*)orderTime{
    
    if (!_orderTime) {
        _orderTime=[[UILabel alloc]init];
        _orderTime.backgroundColor=[UIColor clearColor];
        _orderTime.textColor=[UIColor blackColor];
        _orderTime.font=[UIFont systemFontOfSize:13];
        
    }
    
    return _orderTime;
    
}
-(UIView*)lineview{
    
    if (!_lineview) {
        
        _lineview=[[UIView alloc]init];
        _lineview.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
    }
    
    return _lineview;
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

-(UILabel*)orderMoney{
    
    if (!_orderMoney) {
        _orderMoney=[[UILabel alloc]init];
        _orderMoney.backgroundColor=[UIColor clearColor];
        _orderMoney.textColor=[UIColor blackColor];
        _orderMoney.font=[UIFont systemFontOfSize:13];

    }
    
    return _orderMoney;
    
}

-(UILabel*)orderStore{
    
    if (!_orderStore) {
        _orderStore=[[UILabel alloc]init];
        _orderStore.backgroundColor=[UIColor clearColor];
        _orderStore.textColor=[UIColor blackColor];
        _orderStore.font=[UIFont systemFontOfSize:13];
        
    }
    
    return _orderStore;
    
}

-(UIButton*)DeleteBt{
    
    if (!_DeleteBt) {
        _DeleteBt=[[UIButton alloc]init];
        _DeleteBt.hidden = YES;
        [_DeleteBt setImage:[UIImage imageNamed:@"address_dele"] forState:UIControlStateNormal];
        [_DeleteBt addTarget:self action:@selector(delegeteEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _DeleteBt;
    
}

@end
