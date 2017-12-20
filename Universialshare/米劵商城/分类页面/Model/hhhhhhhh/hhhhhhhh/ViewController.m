//
//  ViewController.m
//  hhhhhhhh
//
//  Created by 龚磊 on 2017/8/22.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "SelectUserTypeView.h"

@interface ViewController ()

@property (nonatomic, strong)SelectUserTypeView *selectUserTypeView;
@property (strong, nonatomic)UIView *incentiveModelMaskV;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    

}
- (IBAction)click:(id)sender {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.button convertRect:self.button.bounds toView:window];
    
    [self.view addSubview:self.incentiveModelMaskV];
    
    [self.view addSubview:self.selectUserTypeView];
    
    self.selectUserTypeView.frame = CGRectMake(0, rect.origin.y + 45, rect.size.width, 180);
    self.selectUserTypeView.layer.anchorPoint = CGPointMake(0.5, 0);
    self.selectUserTypeView.transform = CGAffineTransformMakeScale(1.0f, 0.001f);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.selectUserTypeView.transform = CGAffineTransformIdentity;
        
        //        _selectUserTypeView.frame = CGRectMake(90, rect.origin.y + 45, rect.size.width, 180);
        
        NSLog(@"selectUserTypeView.frame = %@,,,selectUserTypeView.frame = %@",NSStringFromCGRect(self.selectUserTypeView.frame),NSStringFromCGRect(rect));
        
    } completion:^(BOOL finished) {
        
    }];
}

//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
                self.selectUserTypeView.transform=CGAffineTransformMakeScale(1.0f, 0.00001f);
        //        self.selectUserTypeView.height = 0;
        
//        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//        CGRect rect=[self.button convertRect:self.button.bounds toView:window];
//        
//        _selectUserTypeView.frame = CGRectMake(90, rect.origin.y + 50, rect.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        [self.selectUserTypeView removeFromSuperview];
        [self.incentiveModelMaskV removeFromSuperview];
    }];


    
}

-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
        [_incentiveModelMaskV addGestureRecognizer:incentiveModelMaskVgesture];
    }
    
    return _incentiveModelMaskV;
    
}
-(SelectUserTypeView*)selectUserTypeView{
    
    if (!_selectUserTypeView) {
        _selectUserTypeView=[[NSBundle mainBundle]loadNibNamed:@"SelectUserTypeView" owner:self options:nil].firstObject;
        
        _selectUserTypeView.layer.cornerRadius = 10.f;
        _selectUserTypeView.clipsToBounds = YES;
        
        //        _selectUserTypeView.frame = CGRectMake(90, 170, SCREEN_WIDTH - 120, 180);
        _selectUserTypeView.dataSoure  = @[@"会员",@"商家",@"创客",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心",@"省级行业服务中心",@"市级行业服务中心"];
        
        
        
    }
    
    return _selectUserTypeView;
    
}
@end
