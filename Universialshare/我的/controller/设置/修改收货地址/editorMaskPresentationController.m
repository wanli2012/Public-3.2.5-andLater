//
//  editorMaskPresentationController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "editorMaskPresentationController.h"

@interface editorMaskPresentationController ()

@property (nonatomic,strong)UIView *maskView;
@end

@implementation editorMaskPresentationController

-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self=[super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureevent)];
        [self.maskView addGestureRecognizer:tapgesture];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapgestureevent) name:@"LoveConsumptionVC" object:nil];
    }
    return self;
}
//将要展示
-(void)presentationTransitionWillBegin{
    [self.containerView addSubview:self.maskView];
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
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
    return CGRectMake(0, self.containerView.bounds.size.height-250, self.containerView.bounds.size.width, 250);
}

-(UIView*)maskView{
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _maskView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _maskView;
    
}
//点击maskview 退出
-(void)tapgestureevent{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
