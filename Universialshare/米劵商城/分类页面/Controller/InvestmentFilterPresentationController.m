//
//  InvestmentFilterPresentationController.m
//  AngelComing
//
//  Created by sm on 16/11/29.
//  Copyright © 2016年 ruichikeji. All rights reserved.
//

#import "InvestmentFilterPresentationController.h"


@interface InvestmentFilterPresentationController ()

@property (nonatomic,strong)UIView *maskView;

@end

@implementation InvestmentFilterPresentationController
-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self=[super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureevent)];
        [self.maskView addGestureRecognizer:tapgesture];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapgestureevent) name:@"dismissnvestmentFilter" object:nil];
       
    }
    return self;
}
//将要展示
-(void)presentationTransitionWillBegin{
    self.containerView.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.containerView addSubview:self.maskView];
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    } completion:nil];
}
//展示完成
- (void)presentationTransitionDidEnd:(BOOL)completed{
    if(!completed){
        [self.maskView removeFromSuperview];
    }
    
}
//将要退出
- (void)dismissalTransitionWillBegin{
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        _maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:nil];
    
}
//退出完成
- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if(completed){
        [self.maskView removeFromSuperview];
    }
    
}
//展示试图大小
- (CGRect)frameOfPresentedViewInContainerView
{
    return CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
}

-(UIView*)maskView{
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    return _maskView;
    
}
//点击maskview 退出
-(void)tapgestureevent{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}


@end
