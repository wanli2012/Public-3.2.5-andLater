//
//  LBLoginNavigationViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBLoginNavigationViewController.h"

@interface LBLoginNavigationViewController ()

@end

@implementation LBLoginNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.tintColor=[UIColor whiteColor];
    
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    //     viewController.hidesBottomBarWhenPushed = YES; //隐藏底部标签栏
    
    [super pushViewController:viewController animated:animated];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.visibleViewController.navigationItem.backBarButtonItem = backButtonItem;
    
    [self.visibleViewController.navigationItem setHidesBackButton:YES];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"iv_back"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, -5, 5, 25)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.visibleViewController.navigationItem.leftBarButtonItem = ba;
    
}

-(void)popself

{
    
    [self popViewControllerAnimated:YES];
    
}

@end
