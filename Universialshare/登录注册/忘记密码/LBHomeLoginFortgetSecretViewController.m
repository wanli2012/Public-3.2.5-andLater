//
//  LBHomeLoginFortgetSecretViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeLoginFortgetSecretViewController.h"
#import "SelectUserTypeView.h"
#import "LoginIdentityView.h"

@interface LBHomeLoginFortgetSecretViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseview1;
@property (weak, nonatomic) IBOutlet UIButton *usertypeBt;
@property (weak, nonatomic) IBOutlet UITextField *usertypeTf;

@property (weak, nonatomic) IBOutlet UIView *baseview2;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UITextField *yabzTf;

@property (weak, nonatomic) IBOutlet UIView *baseview3;
@property (weak, nonatomic) IBOutlet UITextField *secretTf;

@property (weak, nonatomic) IBOutlet UIView *baseview4;
@property (weak, nonatomic) IBOutlet UITextField *sureSecretTf;

@property (weak, nonatomic) IBOutlet UIButton *surebutton;
@property (weak, nonatomic) IBOutlet UIButton *codeBt;

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)SelectUserTypeView *selectUserTypeView;

@property (strong, nonatomic)LoadWaitView *loadV;

@property (strong, nonatomic)NSString *usertype;


@end

@implementation LBHomeLoginFortgetSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"忘记密码";
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturechosetype)];
    [self.baseview1 addGestureRecognizer:tapgesture];
    
    UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
    [self.maskView addGestureRecognizer:incentiveModelMaskVgesture];

    self.usertype = OrdinaryUser;
    self.usertypeTf.text=@"会员";
}

- (IBAction)sureBt:(UIButton *)sender {
    
    if (self.usertype == 0) {
        [MBProgressHUD showError:@"选择用户类型"];
        return;
    }
    if (self.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    if (self.yabzTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if (self.secretTf.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.secretTf.text.length < 6 || self.secretTf.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.secretTf.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    if (self.sureSecretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (![self.secretTf.text isEqualToString:self.sureSecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }

    NSString *encryptsecret = [RSAEncryptor encryptString:self.secretTf.text publicKey:public_RSA];

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/forget_pwd" paramDic:@{@"userphone":self.phoneTf.text , @"password":encryptsecret , @"groupID":self.usertype , @"yzm":self.yabzTf.text} finish:^(id responseObject) {
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

- (IBAction)chooseUsertype:(UIButton *)sender {

}
- (IBAction)getcode:(UIButton *)sender {
    
    if (self.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":self.phoneTf.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTf && [string isEqualToString:@"\n"]) {
        [self.yabzTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.yabzTf && [string isEqualToString:@"\n"]){
        
        [self.secretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.secretTf && [string isEqualToString:@"\n"]){
        
        [self.sureSecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.sureSecretTf && [string isEqualToString:@"\n"]){
        
         [self.view endEditing:YES];
        return NO;
    }
    //判断是不是中文
    if (textField == self.phoneTf || textField == self.yabzTf ||self.sureSecretTf || self.secretTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
}
#pragma mark - 选择用户类型
//选择身份
-(void)tapgesturechosetype{
    
    __weak typeof(self) weakSelf = self;
    
    self.selectUserTypeView.block = ^(NSInteger index){
        
        switch (index) {
            case 0://会员
            {
                weakSelf.usertype = OrdinaryUser;
                weakSelf.usertypeTf.text=@"会员";
            }
                break;
            case 1://商家
            {
                weakSelf.usertype = Retailer;
                weakSelf.usertypeTf.text=@"商家";
            }
                break;
            case 2://创客
            {
                weakSelf.usertype = THREESALER;
                weakSelf.usertypeTf.text=@"创客";
            }
                break;
            case 3://城市创客
            {
                weakSelf.usertype = TWOSALER;
                weakSelf.usertypeTf.text=@"城市创客";
            }
                break;
            case 4://大区创客
            {
                weakSelf.usertype = ONESALER;
                weakSelf.usertypeTf.text=@"大区创客";
            }
                break;
            case 5://省级服务中心
            {
                weakSelf.usertype = PROVINCE;
                weakSelf.usertypeTf.text=@"省级服务中心";
            }
                break;
            case 6://市级服务中心
            {
                weakSelf.usertype = CITY;
                weakSelf.usertypeTf.text=@"市级服务中心";
            }
                break;
            case 7://区级服务中心
            {
                weakSelf.usertype = DISTRICT;
                weakSelf.usertypeTf.text=@"区级服务中心";
            }
                break;
            case 8://省级行业服务中心
            {
                weakSelf.usertype = PROVINCE_INDUSTRY;
                weakSelf.usertypeTf.text=@"省级行业服务中心";
            }
                break;
            case 9://市级行业服务中心
            {
                weakSelf.usertype = CITY_INDUSTRY;
                weakSelf.usertypeTf.text=@"市级行业服务中心";
            }
                break;
                
            default:
                break;
        }
        
        [weakSelf incentiveModelMaskVtapgestureLb];
        
    };
    
    self.selectUserTypeView.transform = CGAffineTransformMakeScale(1.0, 0);
    self.selectUserTypeView.layer.anchorPoint=CGPointMake(0.5, 0);
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.selectUserTypeView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.selectUserTypeView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];

}
//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.selectUserTypeView.transform = CGAffineTransformMakeScale(1.0, 0.00001);
        
    } completion:^(BOOL finished) {
        
        [self.selectUserTypeView removeFromSuperview];
        [self.maskView removeFromSuperview];
        
    }];
    
}

-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.baseview1.layer.cornerRadius = 4;
    self.baseview1.clipsToBounds = YES;
    self.baseview1.layer.borderWidth = 0.8;
    self.baseview1.layer.borderColor = YYSRGBColor(223, 223, 223, 1).CGColor;
    
    self.baseview2.layer.cornerRadius = 4;
    self.baseview2.clipsToBounds = YES;
    self.baseview2.layer.borderWidth = 0.8;
    self.baseview2.layer.borderColor = YYSRGBColor(223, 223, 223, 1).CGColor;
    
    self.baseview3.layer.cornerRadius = 4;
    self.baseview3.clipsToBounds = YES;
    self.baseview3.layer.borderWidth = 0.8;
    self.baseview3.layer.borderColor = YYSRGBColor(223, 223, 223, 1).CGColor;
    
    self.baseview4.layer.cornerRadius = 4;
    self.baseview4.clipsToBounds = YES;
    self.baseview4.layer.borderWidth = 0.8;
    self.baseview4.layer.borderColor = YYSRGBColor(223, 223, 223, 1).CGColor;
    
    self.yabzTf.layer.cornerRadius = 4;
    self.yabzTf.clipsToBounds = YES;
    self.yabzTf.layer.borderWidth = 0.8;
    self.yabzTf.layer.borderColor = YYSRGBColor(223, 223, 223, 1).CGColor;
    
    
    self.surebutton.layer.cornerRadius = 4;
    self.surebutton.clipsToBounds = YES;
    
    self.codeBt.layer.cornerRadius = 4;
    self.codeBt.clipsToBounds = YES;


}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor=[UIColor clearColor];
    }
    
    return _maskView;
    
}

-(SelectUserTypeView*)selectUserTypeView{
    
    if (!_selectUserTypeView) {
        _selectUserTypeView=[[NSBundle mainBundle]loadNibNamed:@"SelectUserTypeView" owner:self options:nil].firstObject;
        
        _selectUserTypeView.layer.cornerRadius = 10.f;
        _selectUserTypeView.clipsToBounds = YES;
        _selectUserTypeView.frame = CGRectMake(10, 25, SCREEN_WIDTH - 20, 180);
        
        _selectUserTypeView.dataSoure  = @[@"会员",@"商家",@"创客",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心",@"省级行业服务中心",@"市级行业服务中心"];
        
    }
    
    return _selectUserTypeView;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.codeBt.userInteractionEnabled = YES;
                self.codeBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.codeBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.codeBt.userInteractionEnabled = NO;
                self.codeBt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.codeBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


@end
