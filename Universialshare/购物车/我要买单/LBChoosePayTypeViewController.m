//
//  LBChoosePayTypeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/3.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBChoosePayTypeViewController.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "LBPayTheBillViewController.h"

@interface LBChoosePayTypeViewController ()<UITextFieldDelegate>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UIView *faceViw;
@property (weak, nonatomic) IBOutlet UIView *underLineView;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;

@end

@implementation LBChoosePayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"支付选择";
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//扫码
- (IBAction)tapgestureScan:(UITapGestureRecognizer *)sender {
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
    self.hidesBottomBarWhenPushed = YES;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    __weak typeof(self) weakself = self;
    vc.retureCode = ^(NSString *codeStr){
        //跳转
        [weakself getStoreInfo:codeStr];//返回信息
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;//线下支付
}
-(void)getStoreInfo:(NSString*)str{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (str.length > 11) {
        NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
        NSString *dencryptorstr = [RSAEncryptor decryptString:str privateKeyWithContentsOfFile:private_key_path password:@"448128"];//私钥密码
        if (![dencryptorstr hasPrefix:@"SH"]) {
            
            [MBProgressHUD showError:@"请扫正确的商家二维码"];
            return;
        }
        
        dict[@"shop_name"] = dencryptorstr;
        
    }else{
        if (![str hasPrefix:@"SH"]) {
            [MBProgressHUD showError:@"请扫正确的商家二维码"];
            return;
        }
        
        dict[@"shop_name"] = str;
        
    }
    
    __weak typeof(self) weakself = self;
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Shop/getShopData" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {

                weakself.hidesBottomBarWhenPushed = YES;
                LBPayTheBillViewController *vc=[[LBPayTheBillViewController alloc]init];
                vc.namestr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
                vc.pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_pic"]];
                vc.shop_uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_id"]];
                vc.surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
                [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//提交
- (IBAction)submitEvent:(UIButton *)sender {
    
    if (self.phonetf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入商家电话号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phonetf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"phone"] = self.phonetf.text;
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"User/getShopUserByPhone" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            if ([responseObject[@"is_have_shop"] integerValue]==1) {
                self.hidesBottomBarWhenPushed = YES;
                LBPayTheBillViewController *vc=[[LBPayTheBillViewController alloc]init];
                vc.namestr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
                vc.pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_pic"]];
                vc.shop_uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_id"]];
                vc.surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MBProgressHUD showError:@"找不到该商户"];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:@"请求失败，请检查网络"];
        
    }];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    self.faceViw.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.faceViw.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.faceViw.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.faceViw.layer.shadowRadius = 3;//阴影半径，默认3
    
    self.underLineView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.underLineView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.underLineView.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.underLineView.layer.shadowRadius = 3;//阴影半径，默认3
    
    
    
}

@end
