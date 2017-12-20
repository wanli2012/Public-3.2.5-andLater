//
//  LBProductManagementViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductManagementViewController.h"
#import "LBAddMineProductionViewController.h"
#import "LBProductAuditingViewController.h"
#import "LBProductAuditSucessViewController.h"
#import "LBProductAuditFailViewController.h"

@interface LBProductManagementViewController ()

@property (strong, nonatomic)UIButton *editButton;//编辑

@end

@implementation LBProductManagementViewController

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
    self.navigationItem.title = @"商品管理";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;

}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 3, 50);
    
    NSArray *titleArray = @[
                            @"审核中",
                            @"审核成功",
                            @"审核失败",
                            
                            ];
    
    NSArray *classNames = @[
                            [LBProductAuditingViewController class],
                            [LBProductAuditSucessViewController class],
                            [LBProductAuditFailViewController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor blackColor];
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

//编辑完成
-(void)edtingEventbutton:(UIButton*)button{
    self.hidesBottomBarWhenPushed = YES;
    LBAddMineProductionViewController *vc=[[LBAddMineProductionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIButton*)editButton{
    
    if (!_editButton) {
        _editButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
        [_editButton setTitle:@"添加" forState:UIControlStateNormal];
        [_editButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(edtingEventbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editButton;
    
}

@end
