//
//  LBBillOfLadingHeaderFooterView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingHeaderFooterView.h"
#import <Masonry/Masonry.h>
#import "formattime.h"

@implementation LBBillOfLadingHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initFace];//_init表示初始化方法
    }
    
    return self;

}

-(void)initFace{

    [self addSubview:self.headerv];
    [self.headerv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.headerv.select addTarget:self action:@selector(selectSingal:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerv.upImageBt addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerv.deleteBt addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpBillDetail)];
    [self.headerv addGestureRecognizer:tapgesture];

}

-(void)setModel:(LBBillOfLadingModel *)model{
    _model = model;

    self.headerv.userId.text = [NSString stringWithFormat:@"用户: %@",_model.truename];
    self.headerv.modellb.text = [NSString stringWithFormat:@"奖励模式: %@",_model.rlmodel_type];
    self.headerv.moneylb.text = [NSString stringWithFormat:@"消费:¥%@",_model.line_money];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:_model.addtime];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter1 stringFromDate: date];
    
    self.headerv.timelb.text = currentDateStr;
    
    if (_model.phone.length >= 11) {
        self.headerv.phonelb.text = [NSString stringWithFormat:@"电话:%@*****%@",[_model.phone substringToIndex:3],[_model.phone substringFromIndex:7]];
    }
    
    if (_model.truename.length <= 0 ) {
         self.headerv.userId.text = [NSString stringWithFormat:@"用户: %@",_model.user_name];
    }
    
    self.headerv.select.selected = _model.isSelect;
    
    if (_model.isImage) {
        [self.headerv.upImageBt setTitle:@"查 看 凭 证" forState:UIControlStateNormal];
    }else{
        [self.headerv.upImageBt setTitle:@"消 费 凭 证" forState:UIControlStateNormal];
    }
    
    if ([_model.group_id isEqualToString:OrdinaryUser]) {
        self.headerv.userType.text = @"类型:会员";
    }else if ([_model.group_id isEqualToString:Retailer]){
        self.headerv.userType.text  = @"类型:商家";
    }else if ([_model.group_id isEqualToString:ONESALER]){
       self.headerv.userType.text  = @"类型:大区创客";
    }else if ([_model.group_id isEqualToString:TWOSALER]){
        self.headerv.userType.text = @"类型:城市创客";
    }else if ([_model.group_id isEqualToString:THREESALER]){
       self.headerv.userType.text = @"类型:创客";
    }else if ([_model.group_id isEqualToString:PROVINCE]){
        self.headerv.userType.text  = @"类型:省级服务中心";
    }else if ([_model.group_id isEqualToString:CITY]){
      self.headerv.userType.text = @"类型:市级服务中心";
    }else if ([_model.group_id isEqualToString:DISTRICT]){
       self.headerv.userType.text  = @"类型:区级服务中心";
    }else if ([_model.group_id isEqualToString:PROVINCE_INDUSTRY]){
        self.headerv.userType.text  = @"类型:省级行业服务中心";
    }else if ([_model.group_id isEqualToString:CITY_INDUSTRY]){
        self.headerv.userType.text  = @"类型:市级行业服务中心";
    }

}

-(void)selectSingal:(UIButton*)sender{

    _model.isSelect = !_model.isSelect;
    
    if (self.refreshData) {
        self.refreshData(_model.isSelect,_model.line_id,_model.line_money);
    }

}

-(void)uploadImage:(UIButton*)sender{

    if (_model.isImage == YES) {
        if (self.refreshShow) {
            self.refreshShow(@"修 改 图 片",_model.imagev);
        }
    }else{
        if (self.refreshShow) {
            self.refreshShow(@"上 传 图 片",[UIImage imageNamed:@"uploadphoto"]);
        }
    }

}

-(void)jumpBillDetail{

    if (self.jumpBilldetail) {
        self.jumpBilldetail();
    }

}

-(void)deleteEvent:(UIButton*)sender{
    
    if (self.detateBill) {
        self.detateBill();
    }
    
}


-(LBBillOfLadingHeaderView*)headerv{

    if (!_headerv) {
        _headerv = [[NSBundle mainBundle] loadNibNamed:@"LBBillOfLadingHeaderView" owner:nil options:nil].lastObject;
    }

    return _headerv;

}

@end
