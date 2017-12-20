//
//  LBMineCenterMyOrderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMyOrderViewController.h"
#import "LBMyOrderAlreadyCompletedViewController.h"
#import "LBMyOrderPendingPaymentViewController.h"
#import "LBMyOrderPendingEvaluationViewController.h"
#import "LBMyOrderPendingRefundViewController.h"
#import "LBMyOrderAlreadyPaymentViewController.h"
#import "LBOrderRebatePendingViewController.h"
#import "LBMineCenterReceivingGoodsViewController.h"
#import "LBMyOrderReturnRequestViewController.h"

@interface LBMineCenterMyOrderViewController ()


@end

@implementation LBMineCenterMyOrderViewController

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:45])
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;

     [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
     self.hidesBottomBarWhenPushed=YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderJumptype:) name:@"orderJumptype" object:nil];
    
}

-(void)orderJumptype:(NSNotification*)info{

    NSString *order_type = info.userInfo[@"order_type"];

    if ([order_type isEqualToString:@"1"]) {
        [self selectTagByIndex:3 animated:YES];
    }else{
        [self selectTagByIndex:4 animated:YES];

    }
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 4, 45);
    
    NSArray *titleArray = @[
                            @"待付款",
                            @"已付款",
                            @"待收货",
                            @"待奖励",
                            @"已完成",
                            @"待评价",
                            @"退货",
                            
                            ];
    
    NSArray *classNames = @[
                            [LBMyOrderPendingPaymentViewController class],
                             [LBMyOrderAlreadyPaymentViewController class],
                             [LBMineCenterReceivingGoodsViewController class],
                             [LBOrderRebatePendingViewController class],
                            [LBMyOrderAlreadyCompletedViewController class],
                            [LBMyOrderPendingEvaluationViewController class],
                            [LBMyOrderReturnRequestViewController class],
                           
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = YYSRGBColor(191, 0, 0, 1);
    self.selectedIndicatorColor = YYSRGBColor(191, 0, 0, 1);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

@end
