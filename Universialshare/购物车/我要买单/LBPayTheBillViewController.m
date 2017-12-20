//
//  LBPayTheBillViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBPayTheBillViewController.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "GLSet_MaskVeiw.h"
#import "GLOrderPayView.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "LBPaysucessView.h"

#import "UMSocial.h"
#import <Social/Social.h>
#import "UIButton+SetEdgeInsets.h"
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface LBPayTheBillViewController ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
{
    NSArray *_dataArray;
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
    GLOrderPayView *_contentView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrolview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UIButton *surebt;

@property (weak, nonatomic) IBOutlet UITextField *moneytf;
@property (weak, nonatomic) IBOutlet UITextField *infoTf;

@property (nonatomic, assign)NSInteger payType;
@property (nonatomic, assign)NSInteger modelType;
@property (nonatomic, strong)NSString *modelstr;
@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, strong)LBPaysucessView *paysucessView;

@property (nonatomic, strong)NSString *timestr;//记录支付成功时间
@property (nonatomic, strong)NSString *shareStr;//记录分享链接

@property (weak, nonatomic) IBOutlet UIButton *riceBt;
@property (weak, nonatomic) IBOutlet UIButton *alipayBt;
@property (weak, nonatomic) IBOutlet UIButton *wechatBt;
@property (weak, nonatomic) IBOutlet UIButton *cashBt;
@property (weak, nonatomic) IBOutlet UIButton *threeBt;
@property (weak, nonatomic) IBOutlet UIButton *fiveBt;
@property (weak, nonatomic) IBOutlet UIButton *tenBt;
@property (weak, nonatomic) IBOutlet UIButton *twetyBt;

@property (nonatomic, strong)UIButton *currentPayBt;//记录支付按钮
@property (nonatomic, strong)UIButton *currentModelBt;//记录奖励按钮

@property (strong, nonatomic)NSString *validate;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@end

@implementation LBPayTheBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"支付";
    self.modelType = 4;
    self.payType = 0;
    self.modelstr = @"3%";
    self.currentModelBt = self.threeBt;
    _dataDic = [NSDictionary dictionary];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:self.pic] placeholderImage:[UIImage imageNamed:@"商户暂位图"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];
    /**
     *支付宝支付成功
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"Alipaysucess" object:nil];
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    self.moneytf.placeholder = [NSString stringWithFormat:@"最多可消费¥%@",self.surplusLimit];
    
    [self isShowPayInterface];
    
    [self.view addSubview:self.paysucessView];
    self.paysucessView.hidden = YES;

    //分享
    [self shareMmerchantIInfo];
}
// 分享
-(void)shareMmerchantIInfo{
    __weak typeof(self) wself = self;
    _paysucessView.weixinshre = ^{
       
              [wself shareTo:@[UMShareToWechatSession]];
        
    };
    _paysucessView.weiboshre = ^{
       
             [wself shareTo:@[UMShareToSina]];

    };
    _paysucessView.friendshre = ^{

      [wself shareTo:@[UMShareToWechatTimeline]];
      
    };

}

- (void)shareTo:(NSArray *)type{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",self.shareStr];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众团购";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",self.shareStr];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众团购";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@",self.shareStr];
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"我在大众团购购买了商品，快来看看吧！(用safari浏览器打开)%@",[NSString stringWithFormat:@"%@",self.shareStr]] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}
//分享链接
-(void)GetShareLinks{

    
    NSString *sharurl = [NSString stringWithFormat:@"%@%@?shop_id=%@&money=%@&time=%@&rl_type=%@",URL_Base,@"Share/share",self.shop_uid,self.moneytf.text,self.timestr, self.modelstr];
    
    self.shareStr = [sharurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}
//获取当前时间的年月日
-(NSString*)getTimeStr{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

    return currentDateStr;
}

-(void)isShowPayInterface{
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/getPayTypeIsCloseByConfig" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.dataDic = responseObject[@"data"];
            
            if ([self.dataDic[@"mz_pay"] integerValue] == 1) {
                self.payType = 4;
                self.currentPayBt = self.riceBt;
                self.riceBt.selected = YES;
            }else if ([self.dataDic[@"mz_pay"] integerValue] != 1 && [self.dataDic[@"alipay"] integerValue] == 1){
                self.payType = 1;
                self.currentPayBt = self.alipayBt;
                self.riceBt.selected = YES;
            }else if ([self.dataDic[@"mz_pay"] integerValue] != 1 && [self.dataDic[@"alipay"] integerValue] != 1 && [self.dataDic[@"wechat"] integerValue] == 1){
                self.payType = 2;
                self.currentPayBt = self.wechatBt;
                self.riceBt.selected = YES;
            }else if ([self.dataDic[@"mz_pay"] integerValue] != 1 && [self.dataDic[@"alipay"] integerValue] != 1 && [self.dataDic[@"wechat"] integerValue] != 1 && [self.dataDic[@"rmb_pay"] integerValue] == 1){
                self.payType = 5;
                self.currentPayBt = self.cashBt;
                self.riceBt.selected = YES;
            }
            
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}


-(void)wxpaysucess{
    
    _paysucessView.hidden = NO;
    self.scrolview.hidden = YES;
    _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.moneytf.text];
    self.timestr = [self getTimeStr];
    [self GetShareLinks];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
//选择线上支付
- (IBAction)choseOnlinePay:(UIButton *)sender {
    
    if (self.currentPayBt == sender) {
        return;
    }
    
    sender.selected = YES;
    self.currentPayBt.selected = NO;
    self.currentPayBt = sender;
    
    if (sender == self.riceBt) {
        if ([self.dataDic[@"mz_pay"] integerValue] != 1) {
            [MBProgressHUD showError:@"暂不支持米子支付"];
            return;
        }
        self.payType = 4;//米子支付
    }else if (sender == self.alipayBt){
        if ([self.dataDic[@"alipay"] integerValue] != 1) {
            [MBProgressHUD showError:@"暂不支持支付宝支付"];
            return;
        }
        self.payType = 1;//支付宝支付
    }else if (sender == self.wechatBt){
        if ([self.dataDic[@"wechat"] integerValue] != 1) {
            [MBProgressHUD showError:@"暂不支持微信支付"];
            return;
        }
        self.payType = 2;//微信支付
    }else if (sender == self.cashBt){
        if ([self.dataDic[@"rmb_pay"] integerValue] != 1) {
            [MBProgressHUD showError:@"暂不支持现金支付"];
            return;
        }
        self.payType = 5;//现金支付
    }
    
}
//选择奖励模式
- (IBAction)chosepayModel:(UIButton *)sender {
    
    if (self.currentModelBt == sender) {
        return;
    }
    
    sender.selected = YES;
    self.currentModelBt.selected = NO;
    self.currentModelBt = sender;
    
    if (sender == self.threeBt) {
         self.modelType = [KThreePersent integerValue];
         self.modelstr = @"3%";
    }else if (sender == self.fiveBt){
        self.modelstr = @"5%";
        self.modelType =3;
    }else if (sender == self.tenBt){
        self.modelstr = @"10%";
        self.modelType =2;
    }else if (sender == self.twetyBt){
        self.modelstr = @"20%";
        self.modelType =1;
    }

}


- (IBAction)ensurePay:(id)sender {
    
    if (self.payType == 0) {
        [MBProgressHUD showError:@"未选择支付方式"];
        return;
    }
    
    if (self.moneytf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写支付金额"];
        return;
    }
    if (self.payType == 0) {
        [MBProgressHUD showError:@"请选择支付类型"];
        return;
    }
    if (self.modelType == 0) {
        [MBProgressHUD showError:@"请选择奖金模式"];
        return;
    }
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if (self.payType == 1) {//支付宝
        [self ricePay:nil];
    }else if (self.payType == 2) {//微信支付
        [self WeChatPay:@"2"];
    }else if (self.payType == 4) {//米子支付
        CGFloat contentViewH = 300;
        CGFloat contentViewW = SCREEN_WIDTH;
        _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        _maskV.bgView.alpha = 0.4;
        
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLOrderPayView" owner:nil options:nil].lastObject;
        [_contentView.backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
        _contentView.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.moneytf.text];
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, contentViewW, 0);
        [_maskV showViewWithContentView:_contentView];
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentViewH, contentViewW, contentViewH);
            [_contentView.passwordF becomeFirstResponder];
        }];
    }else if (self.payType == 5) {//现金支付
        [self cashPayvalidate];
    }
    
}

-(void)cashPayvalidate{

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


- (void)dismiss{
    
    [_contentView.passwordF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
    }];
}

//支付请求
- (void)postRepuest:(NSNotification *)sender {
    
        //米子支付
        [self ricePay:sender];
    
}

- (void)WeChatPay:(NSString *)payType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"shop_uid"] = self.shop_uid;
    dict[@"type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 1 支付宝 2 微信 4:米子
    dict[@"price"] = self.moneytf.text;//价格
    dict[@"remark"] = self.infoTf.text;//备注
    dict[@"rl_type"] = [NSString stringWithFormat:@"%zd",self.modelType];//让利模式 1:20%  2:10%  3:5%

   // dict[@"pwd"] =  [RSAEncryptor encryptString:@"" publicKey:public_RSA];

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/faceToFacePay" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        if ([responseObject[@"code"] integerValue] == 1){
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
        [MBProgressHUD showError:@"接口调取失败"];
        [_loadV removeloadview];
        
    }];
}

- (void)ricePay:(NSNotification *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"shop_uid"] = self.shop_uid;
    dict[@"type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 1 支付宝 2 微信 4:米子
    dict[@"price"] = self.moneytf.text;//价格
    dict[@"remark"] = self.infoTf.text;//备注
    dict[@"rl_type"] = [NSString stringWithFormat:@"%zd",self.modelType];//让利模式 1:20%  2:10%  3:5%

    dict[@"pwd"] =  [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/faceToFacePay" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
           
            if (self.payType == 1) {
                
                [ [AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                    
                    NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                    if (orderState==9000) {
                        
                        _paysucessView.hidden = NO;
                        self.scrolview.hidden = YES;
                        _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.moneytf.text];
                        self.timestr = [self getTimeStr];
                        [self GetShareLinks];

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
                
            }else if (self.payType == 2){
                
               
                
            }else if (self.payType == 4){
                
                [MBProgressHUD showSuccess:@"支付成功"];
                _paysucessView.hidden = NO;
                self.scrolview.hidden = YES;
                _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.moneytf.text];
                self.timestr = [self getTimeStr];
                [self GetShareLinks];
                
            }else{
                
                [MBProgressHUD showSuccess:@"支付成功"];
                _paysucessView.hidden = NO;
                self.scrolview.hidden = YES;
                _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.moneytf.text];
                self.timestr = [self getTimeStr];
                [self GetShareLinks];
            }
            
        }else{
          [MBProgressHUD showSuccess:responseObject[@"message"]];
        }
        
        [self dismiss];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self dismiss];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(void)sureSubmint{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"shop_uid"] = self.shop_uid;
    dict[@"type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 1 支付宝 2 微信 4:米子
    dict[@"price"] = self.moneytf.text;//价格
    dict[@"remark"] = self.infoTf.text;//备注
    dict[@"rl_type"] = [NSString stringWithFormat:@"%zd",self.modelType];//让利模式 1:20%  2:10%  3:5%
    dict[@"validate"] = self.validate;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/faceToFacePay" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showSuccess:@"支付成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showSuccess:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];


}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.infoTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;

}
- (IBAction)connectPhoneTf:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];

    self.contentH.constant = 610;
    self.contentW.constant = SCREEN_WIDTH;
    [self.riceBt horizontalCenterTitleAndImage:10];
    [self.alipayBt horizontalCenterTitleAndImage:10];
    [self.wechatBt horizontalCenterTitleAndImage:10];
    [self.cashBt horizontalCenterTitleAndImage:10];
    [self.threeBt horizontalCenterTitleAndImage:10];
    [self.fiveBt horizontalCenterTitleAndImage:10];
    [self.tenBt horizontalCenterTitleAndImage:10];
    [self.twetyBt horizontalCenterTitleAndImage:10];
    

}

-(LBPaysucessView*)paysucessView{

    if (!_paysucessView) {
        _paysucessView = [[LBPaysucessView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 ) isHiddeShareView:NO];
        _paysucessView.backgroundColor = [UIColor whiteColor];
        _paysucessView.pricelb.text = @"¥ 0";
    
    }

    return _paysucessView;
}
@end
