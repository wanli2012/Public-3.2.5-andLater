//
//  LBNearClassfityViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBNearClassfityViewController : UIViewController

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString  *trade_id;

@property (nonatomic, copy)NSString  *two_trade_id;

@property (nonatomic, copy)NSString  *limit;

@property (nonatomic, copy)NSString  *city_id;

@property (nonatomic, copy)NSString  *sort;

@property (nonatomic, copy)NSString  *lng;

@property (nonatomic, copy)NSString  *lat;

@property (nonatomic, strong)NSMutableArray *typeArr;

@end
