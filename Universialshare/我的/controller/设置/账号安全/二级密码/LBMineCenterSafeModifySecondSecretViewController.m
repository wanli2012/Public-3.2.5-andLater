//
//  LBMineCenterSafeModifySecondSecretViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterSafeModifySecondSecretViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LBMineCenterSafeModifySecondSecretViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;
@property (weak, nonatomic) IBOutlet UIView *baseviewT;
@property (weak, nonatomic) IBOutlet UIView *baseviewO;

@property (weak, nonatomic) IBOutlet UITextField *bseTsecret;

@property (weak, nonatomic) IBOutlet UITextField *basTRepSecTf;

@property (weak, nonatomic) IBOutlet UIButton *donebt;
@property (weak, nonatomic) IBOutlet UIButton *netbutton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseTW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseOW;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UIView *secretView;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imagethree;
@property (weak, nonatomic) IBOutlet UIImageView *imageFour;
@property (weak, nonatomic) IBOutlet UIImageView *imagefive;
@property (weak, nonatomic) IBOutlet UIImageView *imagesix;

@property (weak, nonatomic) IBOutlet UITextField *soldecretTf;

@property (strong, nonatomic)NSString *sixSecret;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secretViewH;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBMineCenterSafeModifySecondSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.soldecretTf rac_textSignal] subscribeNext:^(id x) {
        
        
        if (_sixSecret.length > 6) {
            _sixSecret = [_sixSecret substringToIndex:6];
        }else{
            _sixSecret = [NSString stringWithFormat:@"%@",x];
        }
        
        if (_sixSecret.length == 0) {
           
            [self showimageone:@"" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 1){
            
            [self showimageone:@"加密密码" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
        
        }else if (_sixSecret.length == 2){
            
            [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 3){
            
            [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 4){
            
            [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"加密密码" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 5){
            
            [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"加密密码" imagefive:@"加密密码" imagesix:@""];
            
        }else if (_sixSecret.length == 6){
            
            [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"加密密码" imagefive:@"加密密码" imagesix:@"加密密码"];
            
        }
        
    }];
    
}

-(void)showimageone:(NSString*)imageone imagetwo:(NSString*)imagetwo imagethree:(NSString*)imagethree imagefour:(NSString*)imagefour imagefive:(NSString*)imagefive imagesix:(NSString*)imagesix{

    _imageOne.image = [UIImage imageNamed:imageone];
    _imageTwo.image = [UIImage imageNamed:imagetwo];
    _imagethree.image = [UIImage imageNamed:imagethree];
    _imageFour.image = [UIImage imageNamed:imagefour];
    _imagefive.image = [UIImage imageNamed:imagefive];
    _imagesix.image = [UIImage imageNamed:imagesix];


}


- (IBAction)clickNextBt:(UIButton *)sender {
    
    if ( _sixSecret.length != 6) {
        [MBProgressHUD showError:@"请输入六位密码"];
        return;
    }
    
     NSString *encryptsecret = [RSAEncryptor encryptString:_sixSecret publicKey:public_RSA];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/checkTwoPass" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"psd":encryptsecret} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"]integerValue]==1) {
            
            [self.view endEditing:YES];
            [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH - 60, 0) animated:YES];
        
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}

- (IBAction)ClickDonebt:(UIButton *)sender {
    
    if (self.bseTsecret.text.length <= 0) {
        
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.basTRepSecTf.text.length <= 0) {
        
        [MBProgressHUD showError:@"确认密码不能为空"];
        return;
    }
    
    if (self.bseTsecret.text.length != 6 ) {
        
        [MBProgressHUD showError:@"请输入6位密码"];
        return;
    }

    
   
    if (![self.bseTsecret.text isEqualToString:self.basTRepSecTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.basTRepSecTf.text publicKey:public_RSA];
    
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

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.donebt.layer.cornerRadius = 4;
    self.donebt.clipsToBounds = YES;
    
    self.netbutton.layer.cornerRadius = 4;
    self.netbutton.clipsToBounds = YES;
    
    self.bseTsecret.layer.cornerRadius = 4;
    self.bseTsecret.clipsToBounds = YES;
    
    self.basTRepSecTf.layer.cornerRadius = 4;
    self.basTRepSecTf.clipsToBounds = YES;
    
    self.bseTsecret.layer.borderWidth = 1;
    self.bseTsecret.layer.borderColor = YYSRGBColor(233, 233, 233, 1).CGColor;
    
    self.basTRepSecTf.layer.borderWidth = 1;
    self.basTRepSecTf.layer.borderColor = YYSRGBColor(233, 233, 233, 1).CGColor;
    
    self.contentViewW.constant = (SCREEN_WIDTH - 60)*2;
    
    self.baseOW.constant = SCREEN_WIDTH - 60;
    self.baseTW.constant = SCREEN_WIDTH - 60;
    
    self.secretView.layer.borderWidth = 1;
    self.secretView.layer.borderColor = YYSRGBColor(203, 203, 203, 1).CGColor;
    
    self.secretViewH.constant = (SCREEN_WIDTH - 105)/6;

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.soldecretTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    else if (textField == self.bseTsecret && [string isEqualToString:@"\n"]) {
        [self.basTRepSecTf becomeFirstResponder];
        return NO;
    }else if (textField == self.basTRepSecTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    if (_sixSecret.length >= 6 && ![string isEqualToString:@""] && textField == self.soldecretTf) {
        return NO;
    }
    
    if (textField == self.bseTsecret || textField == self.basTRepSecTf) {
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

- (IBAction)tapgestureShowKeyboard:(UITapGestureRecognizer *)sender {
    [self.soldecretTf becomeFirstResponder];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.soldecretTf becomeFirstResponder];

}
- (IBAction)closeKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
