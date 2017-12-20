//
//  GLMine_MyBeansController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyBeansController.h"
#import "GLEncourageBeansController.h"
#import "GLRecommendBeansController.h"
#import "GLReceiveBeansController.h"

@interface GLMine_MyBeansController ()
{
    CGFloat _firstBeanRemainNum;
    CGFloat _secondBeanRemainNum;
    CGFloat _thirdBeanRemainNum;
    
    NSString *_encourageBeanSum;
    NSString *_recommendBeanSum;
    NSString *_receiveBeanSum;
    
}

@property (nonatomic, strong)GLEncourageBeansController *encourageVC;
@property (nonatomic, strong)GLRecommendBeansController *recommendVC;
@property (nonatomic, strong)GLReceiveBeansController *receiveVC;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *encourageBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (nonatomic, strong)UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UILabel *beanRemainLabel;

@end

@implementation GLMine_MyBeansController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"我的米柜"];
    
    [self.encourageBtn setTitle:[NSString stringWithFormat:@"奖励%@",NormalMoney] forState:UIControlStateNormal];
    [self.recommendBtn setTitle:[NSString stringWithFormat:@"推荐%@",NormalMoney] forState:UIControlStateNormal];
    [self.receiveBtn setTitle:[NSString stringWithFormat:@"业绩%@",NormalMoney] forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.hidden = NO;
    _encourageVC = [[GLEncourageBeansController alloc]init];
    _recommendVC = [[GLRecommendBeansController alloc]init];
    _receiveVC = [[GLReceiveBeansController alloc]init];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 154, SCREEN_WIDTH, SCREEN_HEIGHT-154)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_encourageVC];
    [self addChildViewController:_recommendVC];
    [self addChildViewController:_receiveVC];
    
    self.currentViewController = _encourageVC;
    [self fitFrameForChildViewController:_encourageVC];
    [self.contentView addSubview:_encourageVC.view];

    [self buttonEvent:_encourageBtn];
    
    __block typeof(self) bself = self;
    _encourageVC.retureValue = ^(NSString *remainBeans){

        _firstBeanRemainNum = [remainBeans floatValue];
         [bself changeColor:bself.beanRemainLabel rangeNumber:[remainBeans floatValue]];
    };
    _recommendVC.retureValue = ^(NSString *remainBeans){
        _secondBeanRemainNum = [remainBeans floatValue];
         [bself changeColor:bself.beanRemainLabel rangeNumber:[remainBeans floatValue]];
    };
    _receiveVC.retureValue = ^(NSString *remainBeans){
        _thirdBeanRemainNum = [remainBeans floatValue];
        [bself changeColor:bself.beanRemainLabel rangeNumber:[remainBeans floatValue]];
    };
}

- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

//按钮点击事件
- (IBAction)buttonEvent:(UIButton *)sender {

    [self.encourageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.recommendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.receiveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if (sender == self.encourageBtn) {

        [self transitionFromVC:self.currentViewController toviewController:_encourageVC];
        [self fitFrameForChildViewController:_encourageVC];

        [self changeColor:self.beanRemainLabel rangeNumber:_firstBeanRemainNum];
        
    }else if (sender == self.recommendBtn){

        [self transitionFromVC:self.currentViewController toviewController:_recommendVC];
        [self fitFrameForChildViewController:_recommendVC];

        [self changeColor:self.beanRemainLabel rangeNumber:_secondBeanRemainNum];
    }else{

        [self transitionFromVC:self.currentViewController toviewController:_receiveVC];
        [self fitFrameForChildViewController:_receiveVC];
        
        [self changeColor:self.beanRemainLabel rangeNumber:_thirdBeanRemainNum];
        
    }
}

- (void)changeColor:(UILabel*)label rangeNumber:(float )rangeNum
{
    NSString *remainBeans = [NSString stringWithFormat:@"%.2f",rangeNum];
    NSString *totalStr = [NSString stringWithFormat:@"合计:%@颗",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [label setAttributedText:textColor];
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
