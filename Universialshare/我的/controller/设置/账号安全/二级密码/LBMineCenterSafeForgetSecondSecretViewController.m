//
//  LBMineCenterSafeForgetSecondSecretViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterSafeForgetSecondSecretViewController.h"

@interface LBMineCenterSafeForgetSecondSecretViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;

@property (weak, nonatomic) IBOutlet UIView *baseV1;
@property (weak, nonatomic) IBOutlet UIView *codeview;
@property (weak, nonatomic) IBOutlet UIView *buttonview;
@property (weak, nonatomic) IBOutlet UITextField *codetectf;
@property (weak, nonatomic) IBOutlet UIButton *nextbt;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBT;

@property (weak, nonatomic) IBOutlet UIView *baseV2;
@property (weak, nonatomic) IBOutlet UIView *secretView;
@property (weak, nonatomic) IBOutlet UITextField *secrectTF;
@property (weak, nonatomic) IBOutlet UIView *RepeatView;
@property (weak, nonatomic) IBOutlet UITextField *RepeatTf;
@property (weak, nonatomic) IBOutlet UIButton *doneBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *base1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *base2W;
@property (weak, nonatomic) IBOutlet UILabel *fourSubLb;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBMineCenterSafeForgetSecondSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *phonestr=[NSString stringWithFormat:@"%@",[UserModel defaultUser].phone];
    self.fourSubLb.text = [NSString stringWithFormat:@"输入手机尾号为%@的短信验证",[phonestr substringFromIndex:7]];
    
}


- (IBAction)nextbutton:(UIButton *)sender {
    
    if (self.codetectf.text.length <= 0) {
        
        [MBProgressHUD showError:@"验证不能为空"];
        return;
    }
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/check_yzm" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"yzm":self.codetectf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
             [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH - 60, 0) animated:YES];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}


- (IBAction)donebutton:(UIButton *)sender {
    
    if (self.secrectTF.text.length <= 0) {
        
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.RepeatTf.text.length <= 0) {
        
        [MBProgressHUD showError:@"确认密码不能为空"];
        return;
    }
    
    if (self.secrectTF.text.length != 6 ) {
        
        [MBProgressHUD showError:@"请输入6位密码"];
        return;
    }
    
    if (![self.secrectTF.text isEqualToString:self.RepeatTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.RepeatTf.text publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/setTwoPass" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"psd":encryptsecret} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.view endEditing:YES];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoveConsumptionVC" object:nil];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
    
}

- (IBAction)sendcode:(UIButton *)sender {
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];

    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.codetectf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    else if (textField == self.secrectTF && [string isEqualToString:@"\n"]) {
        [self.RepeatTf becomeFirstResponder];
        return NO;
    }else if (textField == self.RepeatTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.secrectTF || textField == self.RepeatTf) {
        //字符串删除时触发
        if ([string isEqualToString:@""] && range.length >0) {
            return YES;
            //字符串写入时触发
        }else {//限制6位
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength > 6) {
                return NO;
            }
        }
    }
    
    
    return YES;
    
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
                [self.sendCodeBT setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.sendCodeBT.userInteractionEnabled = YES;
                self.sendCodeBT.backgroundColor = YYSRGBColor(193, 50, 25, 1);
                self.sendCodeBT.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendCodeBT setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.sendCodeBT.userInteractionEnabled = NO;
                self.sendCodeBT.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.sendCodeBT.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}



-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.contentVW.constant = (SCREEN_WIDTH - 60)*2;

    self.base1W.constant = SCREEN_WIDTH - 60;
    self.base2W.constant = SCREEN_WIDTH - 60;

    self.codeview.layer.borderWidth = 1;
    self.codeview.layer.borderColor = YYSRGBColor(233, 233, 233, 1).CGColor;
    
    self.buttonview.layer.borderWidth = 1;
    self.buttonview.layer.borderColor = YYSRGBColor(233, 233, 233, 1).CGColor;
    
    self.nextbt.layer.cornerRadius = 4;
    self.nextbt.clipsToBounds = YES;
    
    self.doneBt.layer.cornerRadius = 4;
    self.doneBt.clipsToBounds = YES;
    
    self.baseV1.layer.cornerRadius = 6;
    self.baseV1.clipsToBounds = YES;
    
    self.secretView.layer.cornerRadius = 4;
    self.secretView.clipsToBounds = YES;
    
    self.RepeatView.layer.cornerRadius = 4;
    self.RepeatView.clipsToBounds = YES;
    
    self.secretView.layer.borderWidth = 1;
    self.secretView.layer.borderColor = YYSRGBColor(233, 233, 233, 1).CGColor;
    
    self.RepeatView.layer.borderWidth = 1;
    self.RepeatView.layer.borderColor = YYSRGBColor(233, 233, 233, 1).CGColor;

}
- (IBAction)closeKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
