//
//  LBMineCenterPriviteInfoViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterPriviteInfoViewController.h"

@interface LBMineCenterPriviteInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *namelb;

@property (weak, nonatomic) IBOutlet UILabel *codelb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@end

@implementation LBMineCenterPriviteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"账号信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[UserModel defaultUser].idcard length]>=15) {
        self.namelb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].truename];
        self.codelb.text = [NSString stringWithFormat:@"%@******%@",[[UserModel defaultUser].idcard substringToIndex:6],[[UserModel defaultUser].idcard substringFromIndex:[[UserModel defaultUser].idcard length] - 4]];
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];

    self.contentVH.constant = SCREEN_HEIGHT - 64;
    self.contentVW.constant = SCREEN_WIDTH;

}

@end
