//
//  GLMerchat_StoreDetailController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/18.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreDetailController.h"
#import "LBHomeIncomeFristViewController.h"
#import "LBHomeIncomesecondViewController.h"

@interface GLMerchat_StoreDetailController ()

@end

@implementation GLMerchat_StoreDetailController

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
    self.navigationItem.title = @"收益";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
    
}


-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 2, 50);
    
    NSArray *titleArray = @[
                            @"线上收益",
                            @"线下收益",
                            
                            ];
    
    NSArray *classNames = @[
                            [LBHomeIncomeFristViewController class],
                            [LBHomeIncomesecondViewController class],
                            
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = TABBARTITLE_COLOR;
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
