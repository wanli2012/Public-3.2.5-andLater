//
//  LBFrozenRiceViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFrozenRiceViewController.h"
#import "LBFrozenRiceOneViewController.h"
#import "LBFrozenRiceTwoViewController.h"

@interface LBFrozenRiceViewController ()

@end

@implementation LBFrozenRiceViewController

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
    self.navigationItem.title = @"冻结米分";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 2, 49);
    
    NSArray *titleArray = @[
                            @"激活米分",
                            @"奖励米分",
                            
                            ];
    
    NSArray *classNames = @[
                            [LBFrozenRiceOneViewController class],
                            [LBFrozenRiceTwoViewController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor blackColor];
    self.selectedIndicatorColor = YYSRGBColor(235, 136, 26, 1);
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
