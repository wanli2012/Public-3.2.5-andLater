//
//  GLNearby_NearShopModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/18.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLNearby_NeargoodsModel : NSObject

@property (nonatomic, copy)NSString *coupons;
@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy)NSString *goods_info;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_price;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *rice;

@end

@interface GLNearby_NearShopModel : NSObject


@property (nonatomic, copy)NSString *allLimit;

@property (nonatomic, copy)NSString *isapplication;

@property (nonatomic, copy)NSString *lat;

@property (nonatomic, copy)NSString *limit;

@property (nonatomic, copy)NSString *lng;

@property (nonatomic, copy)NSString *phone;

@property (nonatomic, copy)NSString *shop_address;

@property (nonatomic, copy)NSString *shop_id;

@property (nonatomic, copy)NSString *shop_name;

@property (nonatomic, copy)NSString *store_pic;


@property (nonatomic, copy)NSString *pic;

@property (nonatomic, copy)NSString *surplusLimit;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *today_money;

@property (nonatomic, copy)NSString *total_money;

@property (nonatomic, copy)NSString *pj_mark;

@property (nonatomic, copy)NSArray< GLNearby_NeargoodsModel *>*goods;

@end
