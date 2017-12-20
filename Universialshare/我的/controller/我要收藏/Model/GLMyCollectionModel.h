//
//  GLMyCollectionModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMyCollectionModel : NSObject

@property (nonatomic, copy)NSString *name;//商品名

@property (nonatomic, copy)NSString *info;//详情

@property (nonatomic, copy)NSString *price;//价格

@property (nonatomic, copy)NSString *discount;//优惠,折扣

@property (nonatomic, copy)NSString *goodsID;//商品ID

@property (nonatomic, copy)NSString *thumb;//图片url

@property (nonatomic, copy)NSString *shop_name;//商店名

@property (nonatomic, copy)NSString *goods_type;//收藏类型

@property (nonatomic, copy)NSString *coupons;

@property (nonatomic, copy)NSString *rice;

@property (nonatomic, copy)NSString *status;

@end
