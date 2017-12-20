//
//  LBMineCenterSafeChangePhoneViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterSafeChangePhoneViewController.h"


@interface LBMineCenterSafeChangePhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phonelb;

@property (weak, nonatomic) IBOutlet UIView *baseview1;
@property (weak, nonatomic) IBOutlet UIView *baseview2;

@property (weak, nonatomic) IBOutlet UIView *baseview3;


@property (weak, nonatomic) IBOutlet UITextField *oldcode;

@property (weak, nonatomic) IBOutlet UIButton *oldbutton;

@property (weak, nonatomic) IBOutlet UITextField *newphone;

@property (weak, nonatomic) IBOutlet UITextField *newcode;


@property (weak, nonatomic) IBOutlet UIButton *newbutton;
@property (weak, nonatomic) IBOutlet UIButton *sendebutton;

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBMineCenterSafeChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phonelb.text = [NSString stringWithFormat:@"%@*****%@",[[UserModel defaultUser].phone substringToIndex:3],[[UserModel defaultUser].phone substringFromIndex:7]];
    
}


- (IBAction)getOldcode:(UIButton *)sender {
    
    
    
    [self startTime:self.oldbutton];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
    
}

- (IBAction)getnewcode:(UIButton *)sender {
    
    if (self.newphone.text.length <=0 ) {
        [MBProgressHUD showError:@"验证手机号为空"];
        return;
    }else{
        if (![predicateModel valiMobile:[UserModel defaultUser].phone]) {
            [MBProgressHUD showError:@"验证手机号格式不对"];
            return;
        }
    }
    
    [self startTime:self.newbutton];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":self.newphone.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}

- (IBAction)submitEvent:(UIButton *)sender {
    
    //先验证验证码是否正确
    __weak typeof(self) waekself = self;
    [NetworkManager requestPOSTWithURLStr:@"User/check_yzm" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"yzm":self.oldcode.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            [waekself submitBindPhone];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}
//提交绑定手机号
-(void)submitBindPhone{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/setBeforePhone" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"yzm":self.newcode.text,@"phone":self.newphone.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoveConsumptionVC" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LBMineCenterSafeBindPhoneVc" object:nil];
            [MBProgressHUD showError:@"重新登录"];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.oldcode && [string isEqualToString:@"\n"]) {
        [self.newphone becomeFirstResponder];
        return NO;
    }else if (textField == self.newphone && [string isEqualToString:@"\n"]) {
        [self.newcode becomeFirstResponder];
        return NO;
    }else if (textField == self.newcode && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
    
}

//获取倒计时
-(void)startTime:(UIButton*)button{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"重发验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                button.backgroundColor = YYSRGBColor(193, 50, 25, 1);
                button.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                button.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                button.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}



-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.baseview1.layer.cornerRadius = 4;
    self.baseview1.clipsToBounds = YES;
    self.baseview2.layer.cornerRadius = 4;
    self.baseview2.clipsToBounds = YES;
    self.baseview3.layer.cornerRadius = 4;
    self.baseview3.clipsToBounds = YES;
    
    self.oldbutton.layer.cornerRadius = 4;
    self.oldbutton.clipsToBounds = YES;
    
    self.newbutton.layer.cornerRadius = 4;
    self.newbutton.clipsToBounds = YES;
    
    self.sendebutton.layer.cornerRadius = 4;
    self.sendebutton.clipsToBounds = YES;

}
- (IBAction)closeKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
