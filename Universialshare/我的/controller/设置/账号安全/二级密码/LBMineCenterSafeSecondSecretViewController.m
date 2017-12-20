//
//  LBMineCenterSafeSecondSecretViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterSafeSecondSecretViewController.h"
#import "LBMineCenterSafeModifySecondSecretViewController.h"
#import "editorMaskPresentationController.h"
#import "LBMineCenterSafeForgetSecondSecretViewController.h"

@interface LBMineCenterSafeSecondSecretViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (strong, nonatomic)NSString *vcstr;//判断点击的那一个药弹出的控制器

@end

@implementation LBMineCenterSafeSecondSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"交易密码";
}


- (IBAction)resetSecondSecret:(UITapGestureRecognizer *)sender {
    
    _vcstr = @"LBMineCenterSafeModifySecondSecretViewController";
    LBMineCenterSafeModifySecondSecretViewController *vc=[[LBMineCenterSafeModifySecondSecretViewController alloc]init];
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)forgetSecondSecret:(UITapGestureRecognizer *)sender {
    
    _vcstr = @"LBMineCenterSafeForgetSecondSecretViewController";
    LBMineCenterSafeForgetSecondSecretViewController *vc=[[LBMineCenterSafeForgetSecondSecretViewController alloc]init];
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
   
}
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}

-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if ([_vcstr isEqualToString:@"LBMineCenterSafeModifySecondSecretViewController"]) {
        
        if (_ishidecotr==YES) {
            UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 60, 300);
            toView.layer.cornerRadius = 6;
            toView.clipsToBounds = YES;
            [transitionContext.containerView addSubview:toView];
            [UIView animateWithDuration:0.3 animations:^{
                
                toView.frame=CGRectMake(30, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 60, 300);
                
            } completion:^(BOOL finished) {
                
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
                
            }];
        }else{
            
            UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                toView.frame=CGRectMake(30 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 60, 300);
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [toView removeFromSuperview];
                    [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
                }
                
            }];
            
        }
        
    }else if ([_vcstr isEqualToString:@"LBMineCenterSafeForgetSecondSecretViewController"]){
    
        if (_ishidecotr==YES) {
            UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 330)/2, SCREEN_WIDTH - 60, 330);
            toView.layer.cornerRadius = 6;
            toView.clipsToBounds = YES;
            toView.backgroundColor=[UIColor clearColor];
            [transitionContext.containerView addSubview:toView];
            [UIView animateWithDuration:0.3 animations:^{
                
                toView.frame=CGRectMake(30, (SCREEN_HEIGHT - 330)/2, SCREEN_WIDTH - 60, 330);
                
            } completion:^(BOOL finished) {
                
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
                
            }];
        }else{
            
            UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                toView.frame=CGRectMake(30 + SCREEN_WIDTH, (SCREEN_HEIGHT - 330)/2, SCREEN_WIDTH - 60, 330);
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [toView removeFromSuperview];
                    [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
                }
                
            }];
            
        }
    }
    
}


@end
