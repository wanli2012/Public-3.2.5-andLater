//
//  LBBillOfLadingRecoderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingRecoderViewController.h"
#import "LBBillOfLadingSucessRecoderViewController.h"
#import "LBBillOfLadingrefuseRecoderViewController.h"
#import "LBBillOfLadingFailRecoderViewController.h"
#import "LBBillOfLadingAuditRecoderViewController.h"

@interface LBBillOfLadingRecoderViewController ()

@end

@implementation LBBillOfLadingRecoderViewController

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
    self.navigationItem.title = @"提单记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
}
-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 4, 49);
    
    NSArray *titleArray = @[
                            @"审核中",
                            @"成功",
                            @"拒绝",
                            @"失败",
                            ];
    
    NSArray *classNames = @[
                            [LBBillOfLadingAuditRecoderViewController class],
                            [LBBillOfLadingSucessRecoderViewController class],
                            [LBBillOfLadingrefuseRecoderViewController class],
                            [LBBillOfLadingFailRecoderViewController class],
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = YYSRGBColor(191, 0, 0, 1);
    self.selectedIndicatorColor = YYSRGBColor(191, 0, 0, 1);
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
