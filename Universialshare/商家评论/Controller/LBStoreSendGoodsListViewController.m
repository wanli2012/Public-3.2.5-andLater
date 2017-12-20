//
//  LBStoreSendGoodsListViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreSendGoodsListViewController.h"
#import "LBIncomeChooseHeaderFooterView.h"
#import "LBStoreSendGoodsListFirstViewController.h"
#import "LBStoreSendGoodsSecondViewController.h"
#import "LBStoreSendGoodsThreeViewController.h"

@interface LBStoreSendGoodsListViewController ()

@end

@implementation LBStoreSendGoodsListViewController

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:50])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 3, 50);
    
    NSArray *titleArray = @[
                            @"待发货",
                            @"已发货",
                            @"待确认",
                            ];
    
    NSArray *classNames = @[
                            [LBStoreSendGoodsListFirstViewController class],
                            [LBStoreSendGoodsSecondViewController class],
                            [LBStoreSendGoodsThreeViewController class],

                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = TABBARTITLE_COLOR;
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
