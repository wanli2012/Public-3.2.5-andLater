//
//  LBMyOrdersModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMyOrdersModel : NSObject

@property (copy, nonatomic)NSString *order_id;
@property (copy, nonatomic)NSString *order_money;
@property (copy, nonatomic)NSString *addtime;
@property (copy, nonatomic)NSString *order_num;
@property (copy, nonatomic)NSString *order_type;//1消费订单 (支付宝，微信，米子，面对面) 2其他订单(米券)
@property (copy, nonatomic)NSString *realy_price;
@property (copy, nonatomic)NSString *total;
@property (copy, nonatomic)NSString *mark;
@property (copy, nonatomic)NSString *shop_name;

@property (copy, nonatomic)NSString *rice;
@property (copy, nonatomic)NSString *coupus;

@property (copy, nonatomic)NSString *crypt;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (copy, nonatomic)NSArray *MyOrdersListModel;

@property (assign, nonatomic)BOOL isExpanded;//是否展开

@end
