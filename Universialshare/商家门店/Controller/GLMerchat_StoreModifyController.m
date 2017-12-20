//
//  LBMineCenterModifyLoginSecretViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreModifyController.h"
#import "GLLoginController.h"
#import "BaseNavigationViewController.h"

@interface GLMerchat_StoreModifyController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@property (weak, nonatomic) IBOutlet UIView *baseview1;

@property (weak, nonatomic) IBOutlet UIView *baseview2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseviewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseview2W;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;//验证身份图片

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;//修改登录密码图片

//@property (weak, nonatomic) IBOutlet UILabel *base1phone;//验证身份里的电话号码
@property (weak, nonatomic) IBOutlet UITextField *base1phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *base1Bt;//验证身份里的验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *base1Tf;//验证身份里的验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *nextbt;//下一步按钮


@property (weak, nonatomic) IBOutlet UITextField *baseTwoSecret;

@property (weak, nonatomic) IBOutlet UITextField *RepeatSecret;

@property (weak, nonatomic) IBOutlet UIButton *submitbuton;

@property (weak, nonatomic) IBOutlet UIView *contentview;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLMerchat_StoreModifyController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"密码修改";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.base1phone.text = [NSString stringWithFormat:@"%@*****%@",[[UserModel defaultUser].phone substringToIndex:3],[[UserModel defaultUser].phone substringFromIndex:7]];
    
}

//获取验证身份里的验证码
- (IBAction)baseOneCode:(UIButton *)sender {
    
    if (self.base1phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"验证手机号为空"];
        return;
    }else{
        if (![predicateModel valiMobile:[UserModel defaultUser].phone]) {
            [MBProgressHUD showError:@"验证手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}
//下一步
- (IBAction)nextutton:(UIButton *)sender {
    
    if (self.base1Tf.text.length <= 0) {
        
        [MBProgressHUD showError:@"验证不能为空"];
        return;
    }
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/check_yzm" paramDic:@{@"token":@"",@"uid":self.uid,@"yzm":self.base1Tf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            CATransition *animation = [CATransition animation];
            animation.duration = 0.5;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"pageCurl";
            [self.contentview exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            [self.contentview.layer addAnimation:animation forKey:nil];
            
            self.imageOne.image = [UIImage imageNamed:@"1未选中"];
            self.imageTwo.image = [UIImage imageNamed:@"2选中"];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}
//提交
- (IBAction)submiteent:(UIButton *)sender {
    
    if (self.baseTwoSecret.text.length <= 0) {
        
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.RepeatSecret.text.length <= 0) {
        
        [MBProgressHUD showError:@"确认密码不能为空"];
        return;
    }
    
    if (self.baseTwoSecret.text.length < 6 || self.baseTwoSecret.text.length > 20) {
        
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.baseTwoSecret.text] != 3) {
        
        [MBProgressHUD showError:@"密码只能包含数字和字母"];
        return;
    }
    
    if (![self.baseTwoSecret.text isEqualToString:self.RepeatSecret.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
     NSString *encryptsecret = [RSAEncryptor encryptString:self.baseTwoSecret.text publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/setPass" paramDic:@{@"token":@"",@"uid":self.uid,@"psd":encryptsecret} finish:^(id responseObject) {
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.base1Tf && [string isEqualToString:@"\n"]) {
         [self.view endEditing:YES];
        return NO;
    }else if (textField == self.baseTwoSecret && [string isEqualToString:@"\n"]) {
        [self.RepeatSecret becomeFirstResponder];
        return NO;
    }else if (textField == self.RepeatSecret && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}


-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    
    self.contentVW.constant = SCREEN_WIDTH;
    self.contentVH.constant =SCREEN_HEIGHT - 224;
    
    self.baseviewW.constant = SCREEN_WIDTH - 40;
    self.baseview2W.constant = SCREEN_WIDTH - 40;
    
    self.base1Bt.layer.cornerRadius = 4;
    self.base1Bt.clipsToBounds = YES;
    self.nextbt.layer.cornerRadius = 4;
    self.nextbt.clipsToBounds = YES;
    self.submitbuton.layer.cornerRadius = 4;
    self.submitbuton.clipsToBounds = YES;
    
     self.base1Tf.layer.borderColor = YYSRGBColor(185, 185, 185, 1).CGColor;
     self.base1Tf.layer.borderWidth=1;
     self.baseTwoSecret.layer.borderColor = YYSRGBColor(185, 185, 185, 1).CGColor;
    self.baseTwoSecret.layer.borderWidth=1;
     self.RepeatSecret.layer.borderColor = YYSRGBColor(185, 185, 185, 1).CGColor;
    self.RepeatSecret.layer.borderWidth=1;
    
    
    self.baseview1.layer.borderColor = YYSRGBColor(185, 185, 185, 1).CGColor;
    self.baseview1.layer.borderWidth=1;
    self.baseview1.layer.cornerRadius = 4;
    self.baseview1.clipsToBounds = YES;
    
    self.baseview2.layer.borderColor = YYSRGBColor(185, 185, 185, 1).CGColor;
    self.baseview2.layer.borderWidth=1;
    self.baseview2.layer.cornerRadius = 4;
    self.baseview2.clipsToBounds = YES;


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
                [self.base1Bt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.base1Bt.userInteractionEnabled = YES;
                self.base1Bt.backgroundColor = YYSRGBColor(193, 50, 25, 1);
                self.base1Bt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.base1Bt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.base1Bt.userInteractionEnabled = NO;
                self.base1Bt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.base1Bt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


@end
