//
//  LBMineCenterAccountSafeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterAccountSafeViewController.h"
#import "LBMineCenterPriviteInfoViewController.h"
#import "LBMineCenterSafeBindPhoneViewController.h"
#import "LBMineCenterModifyLoginSecretViewController.h"
#import "LBMineCenterSafeSecondSecretViewController.h"

@interface LBMineCenterAccountSafeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *userId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@end

@implementation LBMineCenterAccountSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"账号安全";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.nameTF.text = [UserModel defaultUser].truename;
    self.userId.text = [UserModel defaultUser].name;
    
    
}
//账号信息
- (IBAction)AccountInfo:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterPriviteInfoViewController *vc=[[LBMineCenterPriviteInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//绑定手机
- (IBAction)bindPhone:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterSafeBindPhoneViewController *vc=[[LBMineCenterSafeBindPhoneViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//登录密码
- (IBAction)loginsecret:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterModifyLoginSecretViewController *vc=[[LBMineCenterModifyLoginSecretViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//二级密码
- (IBAction)secondSecret:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterSafeSecondSecretViewController *vc=[[LBMineCenterSafeSecondSecretViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.contentVW.constant = SCREEN_WIDTH;
    self.contentVH.constant = 310;
    

}
@end
