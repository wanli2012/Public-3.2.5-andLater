//
//  LBMineCenterWantToSignUpViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterWantToSignUpViewController.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "LBSelectRegionalAgentView.h"

@interface LBMineCenterWantToSignUpViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
   BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UITextField *nameft;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UIButton *submitBt;

@property (weak, nonatomic) IBOutlet UILabel *provinceLb;
@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (weak, nonatomic) IBOutlet UILabel *areaLb;
@property (strong, nonatomic)LBSelectRegionalAgentView *selectRegionalAgentView;

@property (nonatomic, strong)NSMutableArray *provinceArr;
@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSMutableArray *countryArr;
@property (nonatomic, assign)NSInteger ischosePro;//记录选择省的第几行
@property (nonatomic, assign)NSInteger ischoseCity;//记录选择市的第几行
@property (nonatomic, assign)NSInteger ischoseArea;//记录选择区的第几行

@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (nonatomic, assign)NSInteger selecteAgence;//选择行业代理
@property (nonatomic, strong)UIView *maskView;//遮罩
@property (weak, nonatomic) IBOutlet UILabel *agenceLb;

@end

@implementation LBMineCenterWantToSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我要报名";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _selecteAgence = 1;
    
    [self getPickerData];
}

#pragma mark - get data
- (void)getPickerData {
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/getCityList" paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.provinceArr = responseObject[@"data"];
            }
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
- (IBAction)tapgestureProvince:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr;
    vc.titlestr = @"请选择省份";
    vc.returnreslut = ^(NSInteger index){
        _ischosePro = index;
        _provinceLb.text = _provinceArr[index][@"province_name"];
        _cityLb.text = @"";
        _areaLb.text = @"";
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)tapgestureCity:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    if (self.provinceLb.text.length <= 0 || [self.provinceLb.text isEqualToString:@"不限"]) {
        [MBProgressHUD showError:@"请选择省份"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"];
    vc.titlestr = @"请选择城市";
    vc.returnreslut = ^(NSInteger index){
        _ischoseCity = index;
        _cityLb.text = _provinceArr[_ischosePro][@"city"][index][@"city_name"];
        _areaLb.text = @"";
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)tapgestureArea:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    if (self.cityLb.text.length <= 0 || [self.cityLb.text isEqualToString:@"不限"]) {
        [MBProgressHUD showError:@"请选择城市"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"];
    vc.titlestr = @"请选择区域";
    vc.returnreslut = ^(NSInteger index){
        _ischoseArea = index;
        _areaLb.text = _provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][index][@"country_name"];
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)tapgestureAgenceLevel:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.levelView convertRect: self.levelView.bounds toView:window];
    
    self.selectRegionalAgentView.frame=CGRectMake(SCREEN_WIDTH-120, rect.origin.y+20, 110, 200);
    
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.selectRegionalAgentView];
}

- (IBAction)submitEvent:(UIButton *)sender {
    
    if (self.provinceLb.text.length <= 0) {
        [MBProgressHUD showError:@"选择省份"];
        return;
    }
    if (self.cityLb.text.length <= 0) {
        [MBProgressHUD showError:@"选择城市"];
        return;
    }
    if (self.areaLb.text.length <= 0) {
        self.areaLb.text = @"";
    }
    
    if (self.nameft.text.length <= 0) {
        [MBProgressHUD showError:@"填写名字"];
        return;
    }
    
    if (self.phonetf.text.length <= 0) {
        [MBProgressHUD showError:@"填写电话"];
        return;
    }
    
    if (![predicateModel valiMobile:self.phonetf.text]) {
        [MBProgressHUD showError:@"电话号格式不对"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/enrollDl" paramDic:@{@"provinceID":_provinceArr[_ischosePro][@"province_code"],@"cityID":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"city_code"],@"areaID":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][_ischoseArea][@"country_code"],@"truename":_nameft.text , @"phone":_phonetf.text , @"uid":[UserModel defaultUser].uid , @"type":[NSNumber numberWithInteger:_selecteAgence] , @"token":[UserModel defaultUser].token} finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
}

-(void)incentiveModelMaskVtapgestureLb{

    [self.maskView removeFromSuperview];
    [self.selectRegionalAgentView removeFromSuperview];

}

-(void)selectRegionalAgentViewEvent:(UIButton*)sender{

    switch (sender.tag) {
        case 10:
            _selecteAgence = 1;
            _agenceLb.text=@"省级代理";
            
            break;
        case 11:
            _selecteAgence = 2;
            _agenceLb.text=@"市级代理";
            break;
        case 12:
            _selecteAgence = 3;
            _agenceLb.text=@"区域代理";
            break;
        case 13:
            _selecteAgence = 4;
            _agenceLb.text=@"省级行业代理";
            break;
        case 14:
            _selecteAgence = 5;
            _agenceLb.text=@"市级行业代理";
            break;
            
        default:
            break;
    }
    
    [self.maskView removeFromSuperview];
    [self.selectRegionalAgentView removeFromSuperview];

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
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
            
        }];
        
    }
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.nameft && [string isEqualToString:@"\n"]) {
        [self.phonetf becomeFirstResponder];
        return NO;
    }
    
    if (textField == self.nameft && ![string isEqualToString:@""]) {
        //只能输入英文或中文
        NSCharacterSet * charact;
        charact = [[NSCharacterSet characterSetWithCharactersInString:NMUBERS]invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:charact]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if(canChange) {
            [MBProgressHUD showError:@"只能输入英文或中文"];
            return NO;
        }
    }
    return YES;

}

-(void)updateViewConstraints{

    [super updateViewConstraints];
    self.submitBt.layer.cornerRadius = 4;
    self.submitBt.clipsToBounds =YES;

}

-(LBSelectRegionalAgentView*)selectRegionalAgentView{
    
    if (!_selectRegionalAgentView) {
        _selectRegionalAgentView=[[NSBundle mainBundle]loadNibNamed:@"LBSelectRegionalAgentView" owner:self options:nil].firstObject;
        [_selectRegionalAgentView.provinceBt addTarget:self action:@selector(selectRegionalAgentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_selectRegionalAgentView.cityBt addTarget:self action:@selector(selectRegionalAgentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_selectRegionalAgentView.areaBt addTarget:self action:@selector(selectRegionalAgentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_selectRegionalAgentView.provinceAgenceBt addTarget:self action:@selector(selectRegionalAgentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_selectRegionalAgentView.cityAgenceBt addTarget:self action:@selector(selectRegionalAgentViewEvent:) forControlEvents:UIControlEventTouchUpInside];
       
        
    }
    
    return _selectRegionalAgentView;
    
}
-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
        [_maskView addGestureRecognizer:incentiveModelMaskVgesture];
    }
    
    return _maskView;
    
}

@end
