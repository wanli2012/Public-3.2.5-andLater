//
//  LBWaitOrdersListModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBWaitOrdersListModel : NSObject

@property (copy, nonatomic)NSString *image_cover;
@property (copy, nonatomic)NSString *goods_name;
@property (copy, nonatomic)NSString *goods_mes;
@property (copy, nonatomic)NSString *goods_num;
@property (copy, nonatomic)NSString *goods_price;
@property (copy, nonatomic)NSString *shop_name;
@property (copy, nonatomic)NSString *is_receipt;
@property (copy, nonatomic)NSString *orderGoodsId;
@property (copy, nonatomic)NSString *odd_num;

@end
