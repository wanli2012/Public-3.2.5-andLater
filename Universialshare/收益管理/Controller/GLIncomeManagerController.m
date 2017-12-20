//
//  GLIncomeManagerController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIncomeManagerController.h"
#import "GLIncomeManagerRecommendController.h"
#import "GLIncomeManagerRewardController.h"
#import "LBHomeIncomeSearchViewController.h"

@interface GLIncomeManagerController ()

@property (strong, nonatomic)GLIncomeManagerRecommendController *fiveVc;//推荐
@property (strong, nonatomic)GLIncomeManagerRewardController *sixVc;//奖励
@property (strong, nonatomic)UIViewController *currentVC;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *onlineBt;
@property (weak, nonatomic) IBOutlet UIButton *underLineBt;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic)UIView *lineView;

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)UIView *choseView;
@property (strong, nonatomic)UIButton *memberBt;//推荐
@property (strong, nonatomic)UIButton *achieveBt;//奖励
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger buttontype;//判断选中的第几个按钮，1表示线上 2表示线下 ，默认为1
@end

@implementation GLIncomeManagerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttontype =1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.buttonView addSubview:self.lineView];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.fiveVc = [[GLIncomeManagerRecommendController alloc] init];
    self.fiveVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
    
    
    self.sixVc = [[GLIncomeManagerRewardController alloc] init];
    self.sixVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
    
    [self addChildViewController:self.fiveVc];
    self.currentVC = self.fiveVc;
    [self.view addSubview:self.fiveVc.view];
    
    [_loadV removeloadview];
}
//搜索
- (IBAction)searchEvent:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBHomeIncomeSearchViewController *vc =[[LBHomeIncomeSearchViewController alloc]init];
    vc.typer = 1;
    [self.navigationController pushViewController:vc animated:NO];
    
}


//退出
- (IBAction)applyMoneny:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//推荐
- (IBAction)onlineevnt:(UIButton *)sender {
    self.buttontype =1;
    if (self.currentVC == self.fiveVc) {
        return;
    }
    self.onlineBt.selected = YES;
    self.underLineBt.selected = NO;
    [UIView animateWithDuration:.5 animations:^{
        self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1);
    }];
    [self replaceFromOldViewController:self.currentVC toNewViewController:self.fiveVc];
    
}
//奖励
- (IBAction)underlineEvent:(UIButton *)sender {
    self.buttontype =2;
    if (self.currentVC == self.sixVc) {
        return;
    }
    self.onlineBt.selected = NO;
    self.underLineBt.selected = YES;
    [UIView animateWithDuration:.5 animations:^{
        self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2 + SCREEN_WIDTH/2, 49, 100, 1);
    }];
    [self replaceFromOldViewController:self.currentVC toNewViewController:self.sixVc];
    
}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.searchView.layer.cornerRadius = 4;
    self.searchView.clipsToBounds = YES;
    
}
-(UIView*)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1)];
        _lineView.backgroundColor = YYSRGBColor(235, 136, 26, 1);
    }
    
    return _lineView;
    
}
@end
