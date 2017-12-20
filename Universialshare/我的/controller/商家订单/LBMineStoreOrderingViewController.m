//
//  LBMineStoreOrderingViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineStoreOrderingViewController.h"
#import "LBMineStoreTodayOrderingViewController.h"
#import "LBMineStoreHistoryOrderingViewController.h"
#import "LBMineStoreAllOrdersViewController.h"
#import "LBMineCenterFlyNoticeDetailViewController.h"

@interface LBMineStoreOrderingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *todatbutton;
@property (weak, nonatomic) IBOutlet UIButton *historybutton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@property (strong, nonatomic)LBMineStoreTodayOrderingViewController *todayVc;
@property (strong, nonatomic)LBMineStoreHistoryOrderingViewController *historyVc;
@property (strong, nonatomic)LBMineStoreAllOrdersViewController *AllOrdersVc;

@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation LBMineStoreOrderingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    //self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _todayVc=[[LBMineStoreTodayOrderingViewController alloc]init];
    _historyVc=[[LBMineStoreHistoryOrderingViewController alloc]init];
    _AllOrdersVc=[[LBMineStoreAllOrdersViewController alloc]init];
    
    if (self.hideNavB == NO) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 116, SCREEN_WIDTH, SCREEN_HEIGHT-116 - 49)];
    }else{
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 116, SCREEN_WIDTH, SCREEN_HEIGHT-116)];
    }
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_todayVc];
    [self addChildViewController:_historyVc];
    [self addChildViewController:_AllOrdersVc];
    
    self.currentViewController = _AllOrdersVc;
    [self fitFrameForChildViewController:_AllOrdersVc];
    [self.contentView addSubview:_AllOrdersVc.view];
    
    [self.buttonView addSubview:self.lineView];
    
    __weak typeof(self) weakself = self;
    _todayVc.returncheckbutton=^(NSInteger index){
    
        weakself.hidesBottomBarWhenPushed = YES;
        LBMineCenterFlyNoticeDetailViewController *vc=[[LBMineCenterFlyNoticeDetailViewController alloc]init];
        [weakself.navigationController pushViewController:vc animated:YES];
        weakself.hidesBottomBarWhenPushed = NO;
        
        
    };
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.hideNavB == NO) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
    }

}

- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
    
    
    
}

- (IBAction)todaybutton:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 2, 49, SCREEN_WIDTH / 2, 2);
         [self.todatbutton setTitleColor:YYSRGBColor(235, 136, 26, 1) forState:UIControlStateNormal];
        [self.historybutton setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.allButton setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];

    [self transitionFromVC:self.currentViewController toviewController:_todayVc];
    [self fitFrameForChildViewController:_todayVc];
    
}

//- (IBAction)historybutton:(UIButton *)sender {
//    
//    [UIView animateWithDuration:0.3 animations:^{
//          [self.historybutton setTitleColor:YYSRGBColor(37, 154, 37, 1) forState:UIControlStateNormal];
//         [self.todatbutton setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
//        [self.allButton setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
//         self.lineView.frame = CGRectMake(SCREEN_WIDTH / 3 * 2, 49, SCREEN_WIDTH / 3, 2);
//    } completion:^(BOOL finished) {
//        
//    }];
//    [self transitionFromVC:self.currentViewController toviewController:_historyVc];
//    [self fitFrameForChildViewController:_historyVc];
//
//}
//点击全部
- (IBAction)allbuttonEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.historybutton setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.todatbutton setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.allButton setTitleColor:YYSRGBColor(235, 136, 26, 1) forState:UIControlStateNormal];
        self.lineView.frame = CGRectMake(0, 49, SCREEN_WIDTH / 2, 2);
    } completion:^(BOOL finished) {
        
    }];
    [self transitionFromVC:self.currentViewController toviewController:_AllOrdersVc];
    [self fitFrameForChildViewController:_AllOrdersVc];
    
}


-(UIView*)lineView{

    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH / 2, 2)];
        _lineView.backgroundColor = YYSRGBColor(235, 136, 26, 1);
    }
    
    return _lineView;

}


@end
