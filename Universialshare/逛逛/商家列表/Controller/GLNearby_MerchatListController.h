//
//  GLNearby_MerchatListController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLNearby_MerchatListController : UIViewController

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString  *trade_id;

@property (nonatomic, copy)NSString  *two_trade_id;

@property (nonatomic, copy)NSString  *limit;

@property (nonatomic, copy)NSString  *city_id;

@property (nonatomic, copy)NSString  *sort;

@property (nonatomic, copy)NSString  *lng;

@property (nonatomic, copy)NSString  *lat;

@property (nonatomic, strong)NSArray *typeArr;

@end
