//
//  LBRedPaketRecorderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRedPaketRecorderViewController.h"
#import "LBSendRedPaketViewController.h"
#import "LBRecivedRedPaketViewController.h"

@interface LBRedPaketRecorderViewController ()

@end

@implementation LBRedPaketRecorderViewController

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
    self.navigationItem.title = @"红包记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
}
-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 2, 50);
    
    NSArray *titleArray = @[
                            @"已发红包",
                            @"已收红包",

                            ];
    
    NSArray *classNames = @[
                            [LBSendRedPaketViewController class],
                            [LBRecivedRedPaketViewController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor blackColor];
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}



@end
