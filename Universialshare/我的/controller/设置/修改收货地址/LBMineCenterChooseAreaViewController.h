//
//  LBMineCenterChooseAreaViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LBMineCenterChooseAreaViewController : UIViewController

@property (nonatomic , copy)void(^returnreslut)(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid);
//省市区
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *provinceArr;
@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSMutableArray *countryArr;

@end
