//
//  LBMineCenterAddAdreassViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterAddAdreassViewController.h"
#import "LBMineCenterChooseAreaViewController.h"
#import "editorMaskPresentationController.h"

@interface LBMineCenterAddAdreassViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;

@property (weak, nonatomic) IBOutlet UITextField *nameTf;

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UITextField *provinceTf;

@property (weak, nonatomic) IBOutlet UITextField *adressTf;

@property (weak, nonatomic) IBOutlet UIButton *savebutoon;

@property (weak, nonatomic) IBOutlet UIImageView *isDefaultImage;

@property (weak, nonatomic) IBOutlet UIImageView *isdeualtImageOne;

@property (assign, nonatomic)NSInteger  isdeualt;//默认为0 不设为默认
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSString *adressID;
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation LBMineCenterAddAdreassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"新增收货地址";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isdeualt = 0;
    self.adressID = @"";
    self.provinceStrId = @"";
    self.cityStrId = @"";
    self.countryStrId = @"";
    
    [self initProvinceCityArea];
    [self getPickerData];
}
- (void)getPickerData {
    //行业列表
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/getCityList" paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.dataArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
}

-(void)initProvinceCityArea{

    if (self.isEdit == YES) {
        self.navigationItem.title = @"修改收货地址";
        self.nameTf.text = [NSString stringWithFormat:@"%@",self.dataDic[@"collect_name"]];
        self.phoneTf.text = [NSString stringWithFormat:@"%@",self.dataDic[@"s_phone"]];
        self.provinceTf.text = [NSString stringWithFormat:@"%@",self.dataDic[@"areas"]];
        self.adressTf.text = [NSString stringWithFormat:@"%@",self.dataDic[@"s_address"]];
        
        if ([self.dataDic[@"is_default"] integerValue]==1) {
            self.isDefaultImage.image = [UIImage imageNamed:@"支付未选中"];
            self.isdeualtImageOne.image = [UIImage imageNamed:@"支付选中"];
            self.isdeualt = 1;
        }else{
            self.isDefaultImage.image = [UIImage imageNamed:@"支付选中"];
            self.isdeualtImageOne.image = [UIImage imageNamed:@"支付未选中"];
            self.isdeualt = 0;
        
        }
    }

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.nameTf && [string isEqualToString:@"\n"]) {
        [self.phoneTf becomeFirstResponder];
        return NO;
    }else if (textField == self.phoneTf && [string isEqualToString:@"\n"]) {
        [self.adressTf becomeFirstResponder];
        return NO;
    }else if (textField == self.adressTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.nameTf && ![string isEqualToString:@""]) {
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
    
    if (textField == self.nameTf) {
        //字符串删除时触发
        if ([string isEqualToString:@""] && range.length >0) {
            return YES;
            //字符串写入时触发
        }else {//限制6位
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength > 15) {
                return NO;
            }
        }
    }
    
    return YES;
    
}
//设置为否
- (IBAction)setupEventNot:(UITapGestureRecognizer *)sender {
    
    self.isdeualt = 0;
    self.isDefaultImage.image = [UIImage imageNamed:@"支付选中"];
    self.isdeualtImageOne.image = [UIImage imageNamed:@"支付未选中"];
}
//设置为是
- (IBAction)setupEventYes:(UITapGestureRecognizer *)sender {
    
    self.isdeualt =1;
    self.isDefaultImage.image = [UIImage imageNamed:@"支付未选中"];
    self.isdeualtImageOne.image = [UIImage imageNamed:@"支付选中"];
    
}


- (IBAction)tapgestureChoose:(UITapGestureRecognizer *)sender {
    
    LBMineCenterChooseAreaViewController *vc=[[LBMineCenterChooseAreaViewController alloc]init];
    vc.dataArr = self.dataArr;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.adressID = strid;
        weakself.provinceTf.text = str;
        weakself.adressTf.text = str;
        weakself.provinceStrId = provinceid;
        weakself.cityStrId = cityd;
        weakself.countryStrId = areaid;
    };
   
    
}
//保存
- (IBAction)saveBtevent:(UIButton *)sender {
    
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入收货人姓名"];
        return;
    }
    if (self.nameTf.text.length < 2 || self.nameTf.text.length > 15) {
        [MBProgressHUD showError:@"请输入2-15位名字"];
        return;
    }
    
    if (self.phoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入电话号码"];
        return;
    }
    if (![predicateModel valiMobile:self.phoneTf.text]) {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    if (self.provinceTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入省市区"];
        return;
    }
    if (self.adressTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入详细地址"];
        return;
    }
    
    if (self.isEdit == YES) {//编辑
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/updateAddress" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"status" : [NSNumber numberWithInteger:self.isdeualt] , @"takegoodsname" : self.nameTf.text , @"takegoodsphone" : self.phoneTf.text , @"detail_address" : self.adressTf.text, @"s_province" : self.provinceStrId , @"s_city" : self.cityStrId , @"s_area" : self.countryStrId , @"address_id" : self.dataDic[@"address_id"]} finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue]==1) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshReceivingAddress" object:nil];
                [MBProgressHUD showError:responseObject[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([responseObject[@"code"] integerValue]==3){
                
                [MBProgressHUD showError:responseObject[@"message"]];
                
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
                
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];
    }else{//添加
        
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/addAddress" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"status" : [NSNumber numberWithInteger:self.isdeualt] , @"takegoodsname" : self.nameTf.text , @"takegoodsphone" : self.phoneTf.text , @"alladdress" : self.adressID , @"detail_address" : self.adressTf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshReceivingAddress" object:nil];
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];

        }else{
            [MBProgressHUD showError:responseObject[@"message"]];

        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    }
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
    

- (IBAction)closeKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


-(void)updateViewConstraints{

    [super updateViewConstraints];
    self.contentVH.constant = 310;
    self.contentVW.constant = SCREEN_WIDTH;
    
    self.savebutoon.layer.cornerRadius = 4;
    self.savebutoon.clipsToBounds=YES;

}

@end
