//
//  GLGoodsDetailModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBShiftGoodes : NSObject

@property (nonatomic, copy)NSString *coupons;

@property (nonatomic, copy)NSString *goods_id;

@property (nonatomic, copy)NSString *goods_info;

@property (nonatomic, copy)NSString *goods_name;

@property (nonatomic, copy)NSString *goods_price;


@property (nonatomic, copy)NSString *is_collection;

@property (nonatomic, copy)NSString *rice;

@property (nonatomic, strong)NSString *thumb;

@end

@interface GLGoodsDetailModel : NSObject

@property (nonatomic, copy)NSString *thumb;

@property (nonatomic, copy)NSString *accid;

@property (nonatomic, copy)NSArray *details_banner;

@property (nonatomic, copy)NSString *money;

@property (nonatomic, copy)NSString *rebate;

@property (nonatomic, copy)NSString *posttage;

@property (nonatomic, copy)NSString *goods_info;

@property (nonatomic, copy)NSString *sell_count;

@property (nonatomic, copy)NSString *intea_type;

@property (nonatomic, strong)NSArray *attr;

@property (nonatomic, strong)NSString *is_collection;

@property (nonatomic, copy)NSString *coupons;

@property (nonatomic, copy)NSString *goods_id;

@property (nonatomic, copy)NSString *rice;

@property (nonatomic, copy)NSString *shop_name;

@property (nonatomic, copy)NSString *goods_name;

@property (nonatomic, copy)NSString *shop_phone;

@property (nonatomic, copy)NSString *goods_details;

@property (nonatomic, strong)NSArray<LBShiftGoodes*> *shift_goods;

@end




