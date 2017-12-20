//
//  LBFaceToFacePayHeaderView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersModel.h"

@interface LBFaceToFacePayHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)LBMyOrdersModel *sectionModel;

@property(nonatomic , strong) UILabel *orderCode;//订单号
@property(nonatomic , strong) UILabel *orderTime;//订单时间
@property(nonatomic , strong) UILabel *orderStaues;//订单类型
@property(nonatomic , strong) UILabel *orderMoney;//订单金额
@property(nonatomic , strong) UILabel *orderStore;//订单商铺
@property(nonatomic , strong) UIView *lineview;


@property(nonatomic , strong) UIButton *DeleteBt;
@property(nonatomic , assign) NSInteger section;

@property(nonatomic , copy)void(^returnDeleteBt)(NSInteger section);


@end
