//
//  GLRegisterController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRegisterController.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "LBViewProtocolViewController.h"
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface GLRegisterController ()<UIAlertViewDelegate,NTESVerifyCodeManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *recomendId;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *secretTf;
@property (weak, nonatomic) IBOutlet UITextField *sureSecretTf;
@property (weak, nonatomic) IBOutlet UITextField *verificationTf;
@property (weak, nonatomic) IBOutlet UIButton *getcodeBt;
@property (weak, nonatomic) IBOutlet UIButton *registerBt;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIButton *xieyiBt;
@property (strong, nonatomic)NSString *validate;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@end

@implementation GLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//注册协议
- (IBAction)tapgestureRegisterInfo:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = REGISTER_URL;
    vc.navTitle = @"注册协议";
    [self.navigationController pushViewController:vc animated:YES];
    
}

//查看注册协议
- (IBAction)checkRegisterInfo:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.registerBt.enabled = YES;
        self.registerBt.backgroundColor = TABBARTITLE_COLOR;
    }else{
        self.registerBt.enabled = NO;
        self.registerBt.backgroundColor = [UIColor lightGrayColor];
    }
    
}

//获取验证码
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
    
    [NetworkManager requestPOSTWithURLStr:@"User/check_register" paramDic:@{@"phone":self.phoneTf.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            [self startTime];//获取倒计时
        }else{
            [MBProgressHUD showMessage:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        
    }];
    
}
//注册
- (IBAction)regsiterEventBt:(UIButton *)sender {
    
    if (self.recomendId.text.length <= 0) {
        [MBProgressHUD showError:@"推荐人ID不能为空"];
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
    
    if (self.verificationTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }

     _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/get_give_id" paramDic:@{@"uid":self.recomendId.text} finish:^(id responseObject) {
           [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:[NSString stringWithFormat:@"您的推荐人为%@",responseObject[@"data"][@"count"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即注册", nil];
            
            [alertView show];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        self.manager = [NTESVerifyCodeManager sharedInstance];
        if (self.manager) {
            
            // 如果需要了解组件的执行情况,则实现回调
            self.manager.delegate = self;
            
            // captchaid的值是每个产品从后台生成的,比如 @"a05f036b70ab447b87cc788af9a60974"
            NSString *captchaid = CAPTCHAID;
            [self.manager configureVerifyCode:captchaid timeout:10.0];
            
            // 设置透明度
            self.manager.alpha = 0.7;
            
            // 设置frame
            self.manager.frame = CGRectNull;
            
            // 显示验证码
            [self.manager openVerifyCodeView:nil];
        }

    }

}

-(void)sureSubmint{
    
         NSString *encryptsecret = [RSAEncryptor encryptString:self.secretTf.text publicKey:public_RSA];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/register" paramDic:@{@"userphone":self.phoneTf.text , @"password":encryptsecret , @"uid":self.recomendId.text , @"yzm":self.verificationTf.text,@"reg_port":@3,@"validate":self.validate} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            if (self.registerSucess) {
                self.registerSucess(self.phoneTf.text, self.secretTf.text);
            }
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
    
    if (textField == self.recomendId && [string isEqualToString:@"\n"]) {
        [self.phoneTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.phoneTf && [string isEqualToString:@"\n"]){
        
         [self.secretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.secretTf && [string isEqualToString:@"\n"]){
        
        [self.sureSecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.sureSecretTf && [string isEqualToString:@"\n"]){
        
        [self.verificationTf becomeFirstResponder];
        return NO;
    }else if (textField == self.verificationTf && [string isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.recomendId || textField == self.phoneTf ||self.sureSecretTf || self.secretTf||self.verificationTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
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
                [self.getcodeBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getcodeBt.userInteractionEnabled = YES;
                self.getcodeBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                 self.getcodeBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getcodeBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getcodeBt.userInteractionEnabled = NO;
                self.getcodeBt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.getcodeBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
#pragma mark --- 扫码
- (IBAction)scanEvent:(UIButton *)sender {
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    
    [self openScanVCWithStyle:style];
    
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    vc.retureCode = ^(NSString *codeStr){
        
        self.recomendId.text = codeStr;
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.registerBt.layer.cornerRadius = 4;
    self.registerBt.clipsToBounds = YES;

}
#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    [MBProgressHUD showError:message];
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    
    if (result == YES) {
        self.validate = validate;
        [self sureSubmint];
    }
    
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    [MBProgressHUD showError:error.localizedDescription];
}

@end

