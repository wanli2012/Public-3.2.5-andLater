//
//  LBMineCenterUsualUnderOrderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterUsualUnderOrderViewController.h"
#import "LBMineCenterUsualUnderOrderOneViewController.h"
#import "LBMineCenterUsualUnderOrderTwoViewController.h"
#import "LBMineCenterUsualUnderOrderThreeViewController.h"
#import "LBMineCenterUsualUnderOrderfourViewController.h"

@interface LBMineCenterUsualUnderOrderViewController ()

@end

@implementation LBMineCenterUsualUnderOrderViewController


//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:49])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"线下订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 4, 49);
    
    NSArray *titleArray = @[
                            @"待提交",
                            @"审核成功",
                            @"审核失败",
                            @"POS失败",
                            ];
    
    NSArray *classNames = @[
                            [LBMineCenterUsualUnderOrderThreeViewController class],
                            [LBMineCenterUsualUnderOrderTwoViewController class],
                           [LBMineCenterUsualUnderOrderOneViewController class],
                            [LBMineCenterUsualUnderOrderfourViewController class],
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = YYSRGBColor(191, 0, 0, 1);
    self.selectedIndicatorColor = YYSRGBColor(191, 0, 0, 1);
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
