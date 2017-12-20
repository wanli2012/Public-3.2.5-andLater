//
//  GLDonationController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRedPaketController.h"
#import "GLDonationRecordController.h"
#import "GLSet_MaskVeiw.h"
#import "GLNoticeView.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"
#import "QQPopMenuView.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "LBRedPaketRecorderViewController.h"

@interface LBRedPaketController ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
{
    GLSet_MaskVeiw *_maskView;
    LoadWaitView *_loadV;
    BOOL _isHaveDian;//是否有小数点
}
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextField *donationIDF;
@property (weak, nonatomic) IBOutlet UITextField *beanNumF;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdF;

@property (weak, nonatomic) IBOutlet UILabel *useableBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *userableBeanStyleLabel;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (assign, nonatomic)NSInteger userType; //转赠类型
@property (weak, nonatomic) IBOutlet UITextField *typeF;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UITextField *usertypeF;
@property (weak, nonatomic) IBOutlet UIView *userTypeV;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@end

@implementation LBRedPaketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";

    self.ensureBtn.layer.cornerRadius = 5.f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //可转赠善行豆 设置默认值
    self.useableBeanLabel.text = [NSString stringWithFormat:@"米子余额:%@",[UserModel defaultUser].ketiBean];
//    self.userableBeanStyleLabel.text = [NSString stringWithFormat:@"可转赠米券:%@",[UserModel defaultUser].mark];
    self.typeF.text = @"米子";

    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 600;
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
    
    //设置键盘return键
    self.donationIDF.returnKeyType = UIReturnKeyNext;
    self.beanNumF.returnKeyType = UIReturnKeyNext;
    self.secondPwdF.returnKeyType = UIReturnKeyDone;
    self.donationIDF.delegate = self;
    self.beanNumF.delegate = self;
    self.secondPwdF.delegate = self;
    self.noticeLabel.text = [NSString stringWithFormat:@"1.用户发送红包会从红包总额扣除20%%的手续费 \n2.用户发送红包，发送红包的用户会获得相等数量的米分 \n3.红包每日限额50000米子 "] ;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.donationIDF){
        [self.beanNumF becomeFirstResponder];
        
    }else if(textField == self.beanNumF){
        [self.secondPwdF becomeFirstResponder];
        
    }else if(textField == self.secondPwdF){
        [self.secondPwdF resignFirstResponder];
   
    }
    return YES;
}


- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

//扫码
- (IBAction)scanning:(id)sender {
    
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
        
        self.donationIDF.text = codeStr;
        
    };

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//选择转赠类型
- (IBAction)chooseType:(UITapGestureRecognizer *)sender {
    
    
}
//选择用户类型
- (IBAction)chooseUertype:(UITapGestureRecognizer *)sender {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.userTypeV convertRect:self.userTypeV.bounds toView:window];
    NSArray *dataA = @[@{@"title":@"会员",@"imageName":@""},
                                      @{@"title":@"商家",@"imageName":@""},
                                       @{@"title":@"创客",@"imageName":@""},
                                       @{@"title":@"城市创客",@"imageName":@""},
                                       @{@"title":@"大区创客",@"imageName":@""},
                                       @{@"title":@"省级服务中心",@"imageName":@""},
                                       @{@"title":@"市级服务中心",@"imageName":@""},
                                       @{@"title":@"区级服务中心",@"imageName":@""},
                                       @{@"title":@"省级行业服务中心",@"imageName":@""},
                                       @{@"title":@"市级行业服务中心",@"imageName":@""},
                       ];
    
    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:dataA
                              
                                                           width:140
                                                triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, rect.origin.y + 20)
                                                          action:^(NSInteger index) {
                                                              
                                                              weakself.usertypeF.text = dataA[index][@"title"];
                                                              
                                                              if (index ==0 ) {
                                                                  weakself.userType = [OrdinaryUser integerValue];
                                                              }else if (index == 1){
                                                                  weakself.userType = [Retailer integerValue];
                                                              }else if (index == 2){
                                                                  weakself.userType = [THREESALER integerValue];
                                                              }else if (index == 3){
                                                                  weakself.userType = [TWOSALER integerValue];
                                                              }else if (index == 4){
                                                                  weakself.userType = [ONESALER integerValue];
                                                              }else if (index == 5){
                                                                  weakself.userType = [PROVINCE integerValue];
                                                              }else if (index == 6){
                                                                  weakself.userType = [CITY integerValue];
                                                              }else if (index == 7){
                                                                  weakself.userType = [DISTRICT integerValue];
                                                              }else if (index == 8){
                                                                  weakself.userType = [PROVINCE_INDUSTRY integerValue];
                                                              }else if (index == 9){
                                                                  weakself.userType = [CITY_INDUSTRY integerValue];
                                                              }
                                                              
                                                              
                                                          }];
    
    popview.isHideImage = YES;
    
    [popview show];

    
}

//确定按钮事件
- (IBAction)ensureBtnClick:(id)sender {

    if (self.typeF.text == nil||self.typeF.text.length == 0) {
        [MBProgressHUD showError:@"请选择支付类型"];
        return;
    }
    if (self.usertypeF.text == nil||self.usertypeF.text.length == 0) {
        [MBProgressHUD showError:@"请选择用户类型"];
        return;
    }
    if (self.donationIDF.text == nil||self.donationIDF.text.length == 0) {
        [MBProgressHUD showError:@"请输入获赠人ID"];
        return;
    }
    if (self.beanNumF.text == nil||self.beanNumF.text.length == 0) {
        [MBProgressHUD showError:@"请输入转赠数量"];
        return;
    }else if(([self.beanNumF.text integerValue] < 1)){
        [MBProgressHUD showError:@"米子最少为1"];
        return;
    }else if(![self isPureNumandCharacters:self.beanNumF.text]){
        [MBProgressHUD showError:@"转赠数量只能是正整数"];
        return;
    }
    
        
    if ([self.beanNumF.text integerValue] >[[UserModel defaultUser].ketiBean integerValue]) {
        [MBProgressHUD showError:@"余额不足"];
        return;
    }
    
    if (self.secondPwdF.text == nil||self.secondPwdF.text.length == 0) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
  
    [self getUserTureName];

}
- (void)cancelDonation{
    [UIView animateWithDuration:0.2 animations:^{
        
        _maskView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
    }];
    
}
//获取用户信息
-(void)getUserTureName{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/getTrueName" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"username" :self.donationIDF.text,@"group_id" :@(self.userType)} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                NSString *str=[NSString stringWithFormat:@"确定向%@发送红包吗?",responseObject[@"data"][@"truename"]];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
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
        [self sureSubmint];
    }
    
}


-(void)sureSubmint{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"number"] = self.beanNumF.text;
    dict[@"groupID"] = @(self.userType);
    dict[@"userphone"] = self.donationIDF.text;
    NSString *encryptsecret = [RSAEncryptor encryptString:self.secondPwdF.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/redEnvelope" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            
            NSString *useableNum = @"";
            
            useableNum = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue] - [self.beanNumF.text floatValue]];
            [UserModel defaultUser].ketiBean = useableNum;
            self.useableBeanLabel.text = [NSString stringWithFormat:@"可转赠米子:%@",useableNum];
            
            [usermodelachivar achive];
            
            self.secondPwdF.text = nil;
            self.donationIDF.text = nil;
            self.beanNumF.text = nil;
            self.usertypeF.text = nil;
            
            [MBProgressHUD showSuccess:@"发送成功"];
            
        }else{
            [_loadV removeloadview];
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//转赠记录
- (IBAction)donationRecord:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBRedPaketRecorderViewController *recordVC = [[LBRedPaketRecorderViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.secondPwdF) {
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
    
    if (textField == self.beanNumF || textField == self.secondPwdF) {
        return [self validateNumber:string];
    }
    
    return YES;
}
//只能输入整数
- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

- (IBAction)closeKeybord:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
