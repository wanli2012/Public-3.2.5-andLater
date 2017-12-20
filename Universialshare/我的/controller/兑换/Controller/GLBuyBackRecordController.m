//
//  GLBuyBackRecordController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackRecordController.h"
#import "GLBuyBackRecord_FinishController.h"
#import "GLBuyBackRecord_ApplyController.h"
#import "GLBuyBackRecord_FailController.h"
#import "GLBuyBackRecordModel.h"

@interface GLBuyBackRecordController ()

@property (nonatomic, strong)GLBuyBackRecord_FinishController *firstVC;
@property (nonatomic, strong)GLBuyBackRecord_ApplyController *secondVC;
@property (nonatomic, strong)GLBuyBackRecord_FailController *thirdVC;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (nonatomic, strong)UIButton *currentButton;




@end

@implementation GLBuyBackRecordController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.view.backgroundColor = [UIColor whiteColor];
    _firstVC = [[GLBuyBackRecord_FinishController alloc]init];
    _secondVC = [[GLBuyBackRecord_ApplyController alloc]init];
    _thirdVC = [[GLBuyBackRecord_FailController alloc]init];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_firstVC];
    [self addChildViewController:_secondVC];
    [self addChildViewController:_thirdVC];
    
    self.currentViewController = _firstVC;
    [self fitFrameForChildViewController:_firstVC];
    [self.contentView addSubview:_firstVC.view];
    [self buttonEvent:_firstBtn];
//
//    self.currentButton = self.firstBtn;
//    self.firstBtn.selected = YES;
//    self.secondBtn.selected = NO;
//    self.thirdBtn.selected = NO;
    
   
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

//百分之六激励
- (IBAction)buttonEvent:(UIButton *)sender {
    
//    sender.selected = !sender.selected;
//    if (sender.selected == NO) {
//        sender.selected = YES;
//        return;
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
// 
//        } completion:^(BOOL finished) {
//            self.currentButton = sender;
//            sender.selected = !sender.selected;
//
//            
//        }];
//    }
    [self.firstBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    if (sender == self.firstBtn) {
//        self.secondBtn.selected = NO;
//        self.thirdBtn.selected = NO;
        [self transitionFromVC:self.currentViewController toviewController:_firstVC];
        [self fitFrameForChildViewController:_firstVC];
    }else if (sender == self.secondBtn){
//        self.firstBtn.selected = NO;
//        self.thirdBtn.selected = NO;
        [self transitionFromVC:self.currentViewController toviewController:_secondVC];
        [self fitFrameForChildViewController:_secondVC];
    }else{
//        self.firstBtn.selected = NO;
//        self.secondBtn.selected = NO;
        [self transitionFromVC:self.currentViewController toviewController:_thirdVC];
        [self fitFrameForChildViewController:_thirdVC];
    }
    
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

@end
