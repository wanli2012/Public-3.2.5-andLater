//
//  MineCollectionHeaderV.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "MineCollectionHeaderV.h"
#import <Masonry/Masonry.h>
#import "UIButton+SetEdgeInsets.h"
#import "SDCycleScrollView.h"

#import "LBMineCenterHeaderView.h"

@interface MineCollectionHeaderV ()

@property(nonatomic , strong) LBMineCenterHeaderView *mineCenterHeaderView;//用户ID

@end

@implementation MineCollectionHeaderV

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];

    }
    return self;
    
}

-(void)loadUI{
  
    [self addSubview:self.mineCenterHeaderView];
    [self.mineCenterHeaderView.baseView addSubview:self.cycleScrollView];
    
    [self.mineCenterHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.mineCenterHeaderView.baseView).offset(0);
        make.leading.equalTo(self.mineCenterHeaderView.baseView).offset(0);
        make.top.equalTo(self.mineCenterHeaderView.baseView).offset(0);
        make.bottom.equalTo(self.mineCenterHeaderView.baseView).offset(0);
    }];
    
    [self.mineCenterHeaderView.moreBt addTarget:self action:@selector(checkMoreinfo) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureGeadimage)];
    [self.mineCenterHeaderView.headview addGestureRecognizer:tapgesture];
    
}
//查看更多信息
-(void)checkMoreinfo{

    [self.delegete tapgesturecheckMoreinfo];
}

-(void)tapgestureGeadimage{
    [self.delegete tapgestureHeadimage];

}
//刷新数据
-(void)refreshDataInfo{

    [self.mineCenterHeaderView.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
    if ([UserModel defaultUser].lastFanLiTime.length > 0 ) {
        self.mineCenterHeaderView.timeLb.text =  [UserModel defaultUser].lastFanLiTime;
    }
    self.mineCenterHeaderView.riceqLb.text =  [UserModel defaultUser].mark;//米券
    self.mineCenterHeaderView.ricezLb.text =  [UserModel defaultUser].ketiBean;//米子
    self.mineCenterHeaderView.ricefLb.text =  [UserModel defaultUser].loveNum;//米分
    self.mineCenterHeaderView.riceAlb.text =  [NSString stringWithFormat:@"%@",[UserModel defaultUser].meeple];//米宝
    
    if ([self.mineCenterHeaderView.riceAlb.text rangeOfString:@"null"].location != NSNotFound || self.mineCenterHeaderView.riceAlb.text.length <= 0) {
        
        self.mineCenterHeaderView.riceAlb.text = @"0.00";
    }
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
        self.mineCenterHeaderView.userTypeLb.text = @"会员";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]){
        self.mineCenterHeaderView.userTypeLb.text  = @"商家";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER]){
        self.mineCenterHeaderView.userTypeLb.text  = @"大区创客";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:TWOSALER]){
        self.mineCenterHeaderView.userTypeLb.text  = @"城市创客";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]){
        self.mineCenterHeaderView.userTypeLb.text  = @"创客";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:PROVINCE]){
        self.mineCenterHeaderView.userTypeLb.text  = @"省级服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:CITY]){
        self.mineCenterHeaderView.userTypeLb.text  = @"市级服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:DISTRICT]){
        self.mineCenterHeaderView.userTypeLb.text  = @"区级服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:PROVINCE_INDUSTRY]){
        self.mineCenterHeaderView.userTypeLb.text  = @"省级行业服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:CITY_INDUSTRY]){
        self.mineCenterHeaderView.userTypeLb.text  = @"市级行业服务中心";
    }
    
    self.mineCenterHeaderView.usernameLb.text = [UserModel defaultUser].truename;
    if ([UserModel defaultUser].truename.length <= 0 || [[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
         self.mineCenterHeaderView.usernameLb.text = [UserModel defaultUser].name;
    }

}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {

        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"商家placeholder"];
         _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.localizationImageNamesGroup = @[];
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);

    }

    return _cycleScrollView;

}

-(LBMineCenterHeaderView*)mineCenterHeaderView{

    if (!_mineCenterHeaderView) {
        _mineCenterHeaderView = [[NSBundle mainBundle]loadNibNamed:@"LBMineCenterHeaderView" owner:nil options:nil].firstObject;
        _mineCenterHeaderView.autoresizingMask = 0;
        _mineCenterHeaderView.headview.layer.cornerRadius = 35;
        _mineCenterHeaderView.headimage.layer.cornerRadius = 34;
    }

    return _mineCenterHeaderView;
}

@end
