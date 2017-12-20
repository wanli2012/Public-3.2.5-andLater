//
//  LBmineCenterGameChargeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBmineCenterGameChargeViewController.h"
#import "FMLinkLabel.h"
#import "TYAlertView.h"
#import "TYAlertController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "LBPaysucessView.h"
#import "LBmineCenterGameChargeRecoderViewController.h"

@interface LBmineCenterGameChargeViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
     LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UIView *glodView;
@property (weak, nonatomic) IBOutlet UIView *notiview;
@property (strong , nonatomic)NSArray *glodArr;
@property (assign , nonatomic)NSInteger curentindex;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBt;

@property (weak, nonatomic) IBOutlet FMLinkLabel *linklb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrW;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (assign , nonatomic)NSInteger numMoney;
@property (assign , nonatomic)NSInteger payMethod;
@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, strong)LBPaysucessView *paysucessView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)UIButton *buttonedt;

@end

@implementation LBmineCenterGameChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"充值";
    _dataDic = [NSDictionary dictionary];
    self.numMoney = 5;
    _glodArr = @[@"¥5",@"¥10",@"¥20",@"¥50",@"¥100",@"¥200",@"¥500",@"其他金额"];
    
    self.linklb.text = @"1、微信/支付宝支付：只要您的微信钱包或支付宝余额有余额，就可以直接用余额为游戏充值，本平台暂不支持花呗支付。\n\n2、米子支付：只需大众团购账户中有米子，支付时输入支付密码即可完成充值。\n\n3、本游戏充值最低不能低于1元充值。如充值发现问题请联系在线充值客服。请您在充值时务必确认好您的充值金额准确无误后再进行充值，避免输错金额导致的失误，如因未仔细确认金额造成的充值问题，我们将一律不予处理此类退款申诉。\n\n4、充值状态，以订单显示为基准，如遇问题，请联系客服。\n\n5、由于手续费及平台服务费本次充值采取1:0.8比例数额充值；\n\n6、充值金额以线上订单形式呈现，所有消费";
    
//     self.linklb.text = @"1、微信/支付宝支付：只要您的微信钱包或支付宝余额有余额，就可以直接用余额为游戏充值，本平台暂不支持花呗支付。\n\n2、米子支付：只需大众团购账户中有米子，支付时输入支付密码即可完成充值...查看更多";
    
    [self.linklb addClickText:@"查看更多" attributeds:@{NSForegroundColorAttributeName : [UIColor orangeColor]} transmitBody:(id)@"查看更多 被点击了" clickItemBlock:^(id transmitBody) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", transmitBody] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
    }];
    
    [self.view addSubview:self.paysucessView];
    self.paysucessView.hidden = YES;
    
    [self addtxetfiled];
    [self isShowPayInterface];
    /**
     *支付宝支付成功
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"Alipaysucess" object:nil];
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"记录" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
}

-(void)wxpaysucess{
    
    _paysucessView.hidden = NO;
    self.scrollView.hidden = YES;
    _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %ld",self.numMoney];

}

-(void)isShowPayInterface{
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/getPayTypeIsCloseByConfig" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.dataDic = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

-(void)addtxetfiled{

    for (int i = 0; i < 8 ; i++) {
        
        NSInteger v = i / 4;
        NSInteger h = i % 4;
        
        CGFloat  W = (SCREEN_WIDTH - 35)/4.0;
        CGFloat  H = 40;
        
        
        if (i == 7) {
            UITextField *textf = [[UITextField alloc]initWithFrame:CGRectMake( (W + 5) * h,  (50) * v, W, H)];
            textf.delegate = self;
            textf.layer.borderWidth = 1;
            textf.layer.borderColor = TABBARTITLE_COLOR.CGColor;
            textf.layer.cornerRadius = 3;
            textf.clipsToBounds = YES;
            textf.tag = i + 10;
            textf.font = [UIFont boldSystemFontOfSize:14];
            textf.text = _glodArr[i];
            textf.textColor = TABBARTITLE_COLOR;
            textf.textAlignment = NSTextAlignmentCenter;
            textf.returnKeyType = UIReturnKeyNext;
            textf.keyboardType = UIKeyboardTypeNumberPad;
            [self.glodView addSubview:textf];
            
        }else{
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake( (W + 5) * h,  (50) * v, W, H)];
            button.layer.borderWidth = 1;
            button.layer.borderColor = TABBARTITLE_COLOR.CGColor;
            button.layer.cornerRadius = 3;
            button.clipsToBounds = YES;
            button.tag = i + 10;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitle:_glodArr[i] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button addTarget:self action:@selector(glodevent:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                button.backgroundColor = TABBARTITLE_COLOR;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.curentindex = button.tag;
            }else{
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
            }
            
            [self.glodView addSubview:button];
        
        }
        
    }
}

-(void)glodevent:(UIButton*)sender{
    [self.view endEditing:YES];
    if (sender.tag == self.curentindex) {
        return;
    }
    
    if (self.curentindex == 0) {

        sender.backgroundColor = TABBARTITLE_COLOR;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        UIButton *currentbt = [self.view viewWithTag:self.curentindex];
        
        sender.backgroundColor = TABBARTITLE_COLOR;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        currentbt.backgroundColor = [UIColor whiteColor];
        [currentbt setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
    }
    
    self.curentindex = sender.tag;
    
     UITextField  *numtf= [self.view viewWithTag:17];
    numtf.backgroundColor = [UIColor whiteColor];
    numtf.textColor = [UIColor orangeColor];

    NSString *moeny = [sender.titleLabel.text substringFromIndex:1];
    self.numMoney = [moeny integerValue];
    

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
    if (textField.tag == 17) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = @"其他金额";
            textField.textColor = TABBARTITLE_COLOR;
            textField.backgroundColor = [UIColor whiteColor];
        }else{
            textField.textColor = [UIColor whiteColor];
            textField.backgroundColor = TABBARTITLE_COLOR;
            self.numMoney = [textField.text integerValue];
        }
        self.curentindex = 0;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 17) {
        
           textField.text = @"";
        
        if (self.curentindex != 0) {
            UIButton *currentbt = [self.view viewWithTag:self.curentindex];
            currentbt.backgroundColor = [UIColor whiteColor];
            [currentbt setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
        }
        
        self.curentindex = 0;
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField  *numtf= [self.view viewWithTag:17];
    if (textField == self.accountTf && [string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [numtf becomeFirstResponder];
    }else if (textField == numtf && [string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        [self.phoneTf becomeFirstResponder];
        
    }else if (self.phoneTf == numtf && [string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        [self.pwdTf becomeFirstResponder];
        
    }else if (self.pwdTf == numtf && [string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        
    }
    
    if (textField == self.accountTf ) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    if (textField == self.pwdTf) {
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

- (IBAction)checkExchangeProtcol:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        self.exchangeBt.backgroundColor = TABBARTITLE_COLOR;
        self.exchangeBt.userInteractionEnabled = YES;
    }else{
        self.exchangeBt.backgroundColor = [UIColor lightGrayColor];
        self.exchangeBt.userInteractionEnabled = NO;
        
    }
    
}

- (IBAction)exchangeEvent:(UIButton *)sender {
    
    if (self.accountTf.text.length != 6) {
        [MBProgressHUD showError:@"请输入帐号"];
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
    
    if (self.pwdTf.text.length != 6) {
        [MBProgressHUD showError:@"请输入六位支付密码"];
        return;
    }
    
    
    
    if (self.dataDic.count <= 0) {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"暂无支付方式"];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    __weak typeof(self) weakself = self;
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择支付方式"];
    if ([self.dataDic[@"mz_pay"] integerValue] == 1) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"米子支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            weakself.payMethod = 3;
            [weakself payMethodMizi];
        }]];
    }
    if ([self.dataDic[@"alipay"] integerValue] == 1) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"支付宝支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            weakself.payMethod = 2;
            [weakself payMethodAlipay];
        }]];
    }
    
    if ([self.dataDic[@"wechat"] integerValue] == 1) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"微信支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            weakself.payMethod = 1;
            [weakself payMethodWechat];
        }]];
    }
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//米子支付
-(void)payMethodMizi{
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.pwdTf.text publicKey:public_RSA];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Vendor/games_recharge" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"phone" :self.phoneTf.text,@"userId" :self.accountTf.text,@"num" :@(self.numMoney*1000),@"pwd" :encryptsecret,@"recharge_type" :@(self.payMethod)} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            _paysucessView.hidden = NO;
            self.scrollView.hidden = YES;
            _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %ld",self.numMoney];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
//微信
-(void)payMethodWechat{
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.pwdTf.text publicKey:public_RSA];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Vendor/games_recharge" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"phone" :self.phoneTf.text,@"userId" :self.accountTf.text,@"num" :@(self.numMoney*1000),@"pwd" :encryptsecret,@"recharge_type" :@(self.payMethod)} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.openID=responseObject[@"data"][@"weixinpay"][@"appid"];
            req.partnerId = responseObject[@"data"][@"weixinpay"][@"partnerid"];
            req.prepayId = responseObject[@"data"][@"weixinpay"][@"prepayid"];
            req.nonceStr = responseObject[@"data"][@"weixinpay"][@"noncestr"];
            req.timeStamp = [responseObject[@"data"][@"weixinpay"][@"timestamp"] intValue];
            req.package = responseObject[@"data"][@"weixinpay"][@"package"];
            req.sign = responseObject[@"data"][@"weixinpay"][@"sign"];
            [WXApi sendReq:req];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
//支付宝支付
-(void)payMethodAlipay{
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.pwdTf.text publicKey:public_RSA];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Vendor/games_recharge" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"phone" :self.phoneTf.text,@"userId" :self.accountTf.text,@"num" :@(self.numMoney*1000),@"pwd" :encryptsecret,@"recharge_type" :@(self.payMethod)} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [ [AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
                    
                    _paysucessView.hidden = NO;
                    self.scrollView.hidden = YES;
                    _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %ld",self.numMoney];
                    
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr=@"订单正在处理中";
                            break;
                        case 4000:
                            returnStr=@"订单支付失败";
                            break;
                        case 6001:
                            returnStr=@"订单取消";
                            break;
                        case 6002:
                            returnStr=@"网络连接出错";
                            break;
                            
                        default:
                            break;
                    }
                    
                    [MBProgressHUD showSuccess:returnStr];
                    
                }
                
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(void)edtingInfo{
    
    self.hidesBottomBarWhenPushed = YES;
    LBmineCenterGameChargeRecoderViewController *vc =[[LBmineCenterGameChargeRecoderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)endtextfiledEent:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.notiview.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    self.notiview.layer.borderWidth = 1;
    self.scrW.constant = SCREEN_WIDTH;
    
}

-(LBPaysucessView*)paysucessView{
    
    if (!_paysucessView) {
        _paysucessView = [[LBPaysucessView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 ) isHiddeShareView:YES];
        _paysucessView.backgroundColor = [UIColor whiteColor];
        _paysucessView.pricelb.text = @"¥ 0";
        
    }
    
    return _paysucessView;
}

@end
