//
//  GLNearby_MerchatListModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/18.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLNearby_MerchatListModel : NSObject

@property (nonatomic, copy)NSString *shop_name;

@property (nonatomic, copy)NSString *store_pic;

@property (nonatomic, copy)NSString *shop_id;

@property (nonatomic, copy)NSString *total_money;

@property (nonatomic, assign)CGFloat limit;//距离

@property (nonatomic, copy)NSString *shop_address;

@property (nonatomic, copy)NSString *phone;

@property (nonatomic, copy)NSString *lat;

@property (nonatomic, copy)NSString *lng;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *allLimit;

@property (nonatomic, copy)NSString *surplusLimit;

@property (nonatomic, copy)NSString *pj_mark;

@end
