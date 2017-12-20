//
//  MerchantInformationModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantInformationModel : NSObject
+(MerchantInformationModel*)defaultUser;

@property (nonatomic, copy)NSString  *loginPhone;//登录手机号
@property (nonatomic, copy)NSString  *secret;//密码
@property (nonatomic, copy)NSString  *legalPerson;//法人
@property (nonatomic, copy)NSString  *legalPersonCode;//法人身份证
@property (nonatomic, copy)NSString  *Email;//邮箱
@property (nonatomic, copy)NSString  *shopName;//店铺名称
@property (nonatomic, copy)NSString  *measureRrea;//门店面积
@property (nonatomic, copy)NSString  *BusinessBegin;//营业开始时间
@property (nonatomic, copy)NSString  *BusinessEnd;//营业结束时间
@property (nonatomic, copy)NSString  *BusinessContent;//经营内容
@property (nonatomic, copy)NSString  *provinceId;//省份id
@property (nonatomic, copy)NSString  *cityId;//城市id
@property (nonatomic, copy)NSString  *countryId;//区域id
@property (nonatomic, copy)NSString  *PrimaryClassification;//一级分类
@property (nonatomic, copy)NSString  *TwoClassification;//二级分类
@property (nonatomic, copy)NSString  *mapAdress;//地图选点
@property (nonatomic, copy)NSString  *lat;//经度
@property (nonatomic, copy)NSString  *lng;//纬度
@property (nonatomic, copy)NSString  *detailAdress;//具体地址
@property (nonatomic, copy)NSString  *openBankNameid;//开户银行id
@property (nonatomic, copy)NSString  *bankNumbers;//储蓄卡
@property (nonatomic, copy)NSString  *ReservePhone;//预留电话号
@property (nonatomic, copy)NSString  *SettlementName;//结算户名
@property (nonatomic, copy)NSString  *SubBranch;//所在支行

@end
