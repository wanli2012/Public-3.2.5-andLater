//
//  GLMerchat_StoreModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMerchat_StoreModel : NSObject

@property (nonatomic, copy)NSString *is_open;

@property (nonatomic, copy)NSString *phone;

@property (nonatomic, copy)NSString *shop_address;

@property (nonatomic, copy)NSString *shop_name;

@property (nonatomic, copy)NSString *status;//0:正在审核 1:审核通过

@property (nonatomic, copy)NSString *shop_id;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *total_money;//总销售额

@property (nonatomic, copy)NSString *today_money;//今日销售额

@property (nonatomic, copy)NSString *store_pic ;//今日销售额


@end
