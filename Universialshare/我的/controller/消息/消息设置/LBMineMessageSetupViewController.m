//
//  LBMineMessageSetupViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineMessageSetupViewController.h"

@interface LBMineMessageSetupViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@property (weak, nonatomic) IBOutlet UIButton *clearBt;


@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;


@end

@implementation LBMineMessageSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"消息设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

- (IBAction)clearBt:(UIButton *)sender {
    
    
}
- (IBAction)wuliutongzhi:(UIButton *)sender {
}
- (IBAction)kehufuwu:(UIButton *)sender {
}

- (IBAction)fuwutongzhi:(UIButton *)sender {
}
- (IBAction)remaijingxuan:(UIButton *)sender {
}


-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.clearBt.layer.cornerRadius = 4;
    self.clearBt.clipsToBounds =YES;
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = SCREEN_HEIGHT - 64;


}

@end
