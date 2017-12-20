//
//  LBWaitOrdersModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBWaitOrdersModel : NSObject

@property (copy, nonatomic)NSString *order_id;
@property (copy, nonatomic)NSString *order_number;
@property (copy, nonatomic)NSString *creat_time;
@property (copy, nonatomic)NSString *logistics_sta;
@property (copy, nonatomic)NSString *order_type;
@property (copy, nonatomic)NSString *order_remark;

@property (copy, nonatomic)NSString *phone;
@property (copy, nonatomic)NSString *address;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (assign, nonatomic)BOOL isExpanded;//是否展开

@end
