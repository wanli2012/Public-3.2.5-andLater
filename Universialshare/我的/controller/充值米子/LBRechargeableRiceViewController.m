//
//  LBRechargeableRiceViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRechargeableRiceViewController.h"
#import "TYAlertView.h"
#import "TYAlertController.h"
#import "LoadWaitView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "LBRechargeRecoderLIstViewController.h"
#import "UIButton+SetEdgeInsets.h"

@interface LBRechargeableRiceViewController ()
{
 LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstarait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrait;
@property (weak, nonatomic) IBOutlet UIButton *chargeBt;
@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, assign)NSInteger payType;
@property (nonatomic, assign)NSInteger modelType;
@property (weak, nonatomic) IBOutlet UITextField *moenyTf;
@property (strong, nonatomic)UIButton *buttonedt;
@property (weak, nonatomic) IBOutlet UILabel *troduceLB;
@property (weak, nonatomic) IBOutlet UIButton *wechatBt;
@property (weak, nonatomic) IBOutlet UIButton *alipayBt;

@end

@implementation LBRechargeableRiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"充值";
    self.modelType = 0;
    self.payType = 0;
    _dataDic = [NSDictionary dictionary];
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
    [_buttonedt addTarget:self action:@selector(chargeRecoredList) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
    self.troduceLB.text = [NSString stringWithFormat:@"1.用户在充值成功后会收取千分之六的手续费  \n2.用户一经充值成功，不予退还"];
    
}

-(void)isShowPayInterface{
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/getPayTypeIsCloseByConfig" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.dataDic = responseObject[@"data"];
            if ([self.dataDic[@"wechat"] integerValue] == 1) {
                self.payType = 1;
                self.wechatBt.selected = YES;

            }else if ([self.dataDic[@"wechat"] integerValue] != 1 && [self.dataDic[@"alipay"] integerValue] == 1){
                self.payType = 2;
                self.alipayBt.selected = YES;
            }
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}
// 选择支付方式
- (IBAction)choosePayMethod:(UIButton *)sender {
    
    if (sender == self.wechatBt) {
        if ([self.dataDic[@"wechat"] integerValue] != 1) {
            [MBProgressHUD showError:@"暂不支持微信支付"];
            return;
        }
        self.wechatBt.selected = YES;
        self.alipayBt.selected = NO;
        self.payType = 1;
        
    }else if (sender == self.alipayBt){
        if ([self.dataDic[@"alipay"] integerValue] != 1) {
            [MBProgressHUD showError:@"暂不支持支付宝支付"];
            return;
        }
        self.wechatBt.selected = NO;
        self.alipayBt.selected = YES;
        self.payType = 2;
        
    }
    
}

//充值
- (IBAction)chargeEvent:(UIButton *)sender {
    
    if (self.payType == 0) {
        [MBProgressHUD showError:@"未选择支付方式"];
        return;
    }
    
    if ([self.moenyTf.text length] <= 0) {
        [MBProgressHUD showError:@"输入金额不能为空"];
        return;
    }
    
    if ([self.moenyTf.text hasPrefix:@"."]||[self.moenyTf.text hasSuffix:@"."]) {
        [MBProgressHUD showError:@"输入格式错误"];
        return;
    }
    if ([self.moenyTf.text floatValue] <= 0) {
        [MBProgressHUD showError:@"输入金额不能为0"];
        return;
    }
    if (self.payType == 0) {
        [MBProgressHUD showError:@"请选择支付类型"];
        return;
    }

    if (self.payType == 2) {//支付宝
        [self ricePay:nil];
    }else if (self.payType == 1) {//微信支付
        [self WeChatPay:@"2"];
    }
    
    
}

-(void)chargeRecoredList{

    self.hidesBottomBarWhenPushed = YES;
    LBRechargeRecoderLIstViewController *vc = [[LBRechargeRecoderLIstViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ricePay:(NSNotification *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"recharge_type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 1 支付宝 2 微信 4:米子
    dict[@"recharge_money"] = self.moenyTf.text;//价格

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/recharge" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
                [ [AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                    
                    NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                    if (orderState==9000) {
                        self.moenyTf.text = @"";
                        [MBProgressHUD showSuccess:@"支付成功"];
                        
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
            [MBProgressHUD showSuccess:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
         [MBProgressHUD showError:@"接口调取失败"];
        
    }];
    
}

- (void)WeChatPay:(NSString *)payType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"recharge_money"] = self.moenyTf.text;//价格
    dict[@"recharge_type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 2 支付宝 1微信
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/recharge" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
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


-(void)wxpaysucess{
    
    self.moenyTf.text = @"";
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.widthConstarait.constant = SCREEN_WIDTH;
    self.heightConstrait.constant = SCREEN_HEIGHT - 64;
    self.chargeBt.layer.cornerRadius = 4;
    self.chargeBt.clipsToBounds = YES;
    
    [self.wechatBt horizontalCenterTitleAndImage:10];
    [self.alipayBt horizontalCenterTitleAndImage:10];
}
- (IBAction)closeKeybord:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
