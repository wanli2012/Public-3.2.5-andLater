//
//  LBMyOrderlistHeaderFooterView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMyOrderlistHeaderFooterView : UITableViewHeaderFooterView

@property(copy,nonatomic)void(^retrunshowsection)(NSInteger index,LBMyOrderlistHeaderFooterView *headview);
@property (assign, nonatomic)NSInteger index;
@property (strong, nonatomic)UIImageView *imagev;
@property(nonatomic , strong) UILabel *orderName;//订单名字
@property(nonatomic , strong) UILabel *ordermoney;//订单价格

@property(nonatomic , strong) UILabel *orderinfo;//订单 描述
@property(nonatomic , strong) UILabel *orderstore;//商店名
@property(nonatomic , strong) UILabel *numlb;//数量
@property(nonatomic , strong) UILabel *typelabel;

@property (strong, nonatomic)UIImageView *imagevo;

@end
