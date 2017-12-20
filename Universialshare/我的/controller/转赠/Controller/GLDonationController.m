//
//  GLDonationController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationController.h"
#import "GLDonationRecordController.h"
#import "GLSet_MaskVeiw.h"
#import "GLNoticeView.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"
#import "QQPopMenuView.h"
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface GLDonationController ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
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

@property (assign, nonatomic)NSInteger stringtype; //转赠类型
@property (assign, nonatomic)NSInteger userType; //转赠类型
@property (weak, nonatomic) IBOutlet UITextField *typeF;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UITextField *usertypeF;
@property (weak, nonatomic) IBOutlet UIView *userTypeV;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property (strong, nonatomic)NSString *validate;
@property (weak, nonatomic) IBOutlet UIButton *scanBt;

@end

@implementation GLDonationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转赠";

    self.ensureBtn.layer.cornerRadius = 5.f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //可转赠善行豆 设置默认值
    self.useableBeanLabel.text = [NSString stringWithFormat:@"可转赠米子:%@",[UserModel defaultUser].ketiBean];
//    self.userableBeanStyleLabel.text = [NSString stringWithFormat:@"可转赠米券:%@",[UserModel defaultUser].mark];
    self.stringtype = 2;
    self.typeF.text = @"米子";

    self.noticeLabel.text = [NSString stringWithFormat:@"*米券可互转，可操作身份为会员、商家（分店商户只可转赠总店）、创客、城市创客、大区创客；\n*米子所有身份（分店商户只可转赠总店）均可对转。\n*限定大于等于100的整数倍才可交易,每次最高可转赠50000米子或50000米券"];

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
    
    if ([UserModel defaultUser].is_main != nil) {
        if ([[UserModel defaultUser].is_main integerValue] == 1) {
            self.scanBt.hidden = YES;
            self.usertypeF.text = @"商家";
            self.donationIDF.text = [UserModel defaultUser].main_id;
            self.donationIDF.userInteractionEnabled = NO;
            self.userType = [Retailer integerValue];
        }
    }
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
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.typeView convertRect:self.typeView.bounds toView:window];
    NSArray *dataA = @[@{@"title":@"米券",@"imageName":@""},
                       @{@"title":@"米子",@"imageName":@""},];
                       
    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:dataA
                              
                                                           width:80
                                                triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, rect.origin.y + 20)
                                                          action:^(NSInteger index) {
                                                              
                                                              weakself.stringtype = index + 1;
                                                              weakself.typeF.text = dataA[index][@"title"];
                                                              
                                                              if(index == 0) {
                                                                  self.useableBeanLabel.text = [NSString stringWithFormat:@"可转赠米券:%@",[UserModel defaultUser].mark];
                                                              }else{
                                                                  self.useableBeanLabel.text = [NSString stringWithFormat:@"可转赠米子:%@",[UserModel defaultUser].ketiBean];
                                                              }
                                                          }];
    
    popview.isHideImage = YES;
    
    [popview show];
    
    
}
//选择用户类型
- (IBAction)chooseUertype:(UITapGestureRecognizer *)sender {
    if ([UserModel defaultUser].is_main != nil) {
        if ([[UserModel defaultUser].is_main integerValue] == 1) {
            return;
        }
    }
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
    
    //输入判断
    [self.view endEditing:YES];
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
    }else if(([self.beanNumF.text integerValue] % 100) != 0){
        [MBProgressHUD showError:@"转赠数量需>=100的整数倍"];
        return;
    }else if(![self isPureNumandCharacters:self.beanNumF.text]){
        [MBProgressHUD showError:@"转赠数量只能是正整数"];
        return;
    }
    
    if (self.stringtype == 1) {
        
        if ([self.beanNumF.text integerValue] >[[UserModel defaultUser].mark integerValue]) {
            [MBProgressHUD showError:@"余额不足"];
            return;
        }
        
    }else if (self.stringtype == 2){
        
        if ([self.beanNumF.text integerValue] >[[UserModel defaultUser].ketiBean integerValue]) {
            [MBProgressHUD showError:@"余额不足"];
            return;
        }
    }
    
    if (self.secondPwdF.text == nil||self.secondPwdF.text.length == 0) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
    if ([self.beanNumF.text floatValue] > 50000) {
        [MBProgressHUD showError:@"单次转赠最多50000"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.donationIDF.text;
    dict[@"group_id"] = @(self.userType);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getTrueNameByPhone" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
    
        if ([responseObject[@"code"] integerValue] == 1) {
            
            CGFloat contentViewH = 200;
            CGFloat contentViewW = SCREEN_WIDTH - 40;
            _maskView = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            _maskView.bgView.alpha = 0.4;
            
            GLNoticeView *contentView = [[NSBundle mainBundle] loadNibNamed:@"GLNoticeView" owner:nil options:nil].lastObject;
            contentView.frame = CGRectMake(20, (SCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
            contentView.layer.cornerRadius = 4;
            contentView.layer.masksToBounds = YES;
            [contentView.cancelBtn addTarget:self action:@selector(cancelDonation) forControlEvents:UIControlEventTouchUpInside];
            [contentView.ensureBtn addTarget:self action:@selector(ensureDonation) forControlEvents:UIControlEventTouchUpInside];
            contentView.contentLabel.text = [NSString stringWithFormat:@"您是否要将转赠给  %@",responseObject[@"data"][@"count"]];
            [_maskView showViewWithContentView:contentView];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}
- (void)cancelDonation{
    [UIView animateWithDuration:0.2 animations:^{
        
        _maskView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
    }];
    
}

//确认捐赠
-(void)ensureDonation{
    [self cancelDonation];
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

-(void)sureSubmint{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"number"] = self.beanNumF.text;
    dict[@"groupID"] = @(self.userType);
    dict[@"userphone"] = self.donationIDF.text;
    dict[@"type"] =@(self.stringtype);
    dict[@"validate"] =self.validate;

    NSString *encryptsecret = [RSAEncryptor encryptString:self.secondPwdF.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/give_to_mark" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            
            [UIView animateWithDuration:0.2 animations:^{
                _maskView.alpha = 0;
            }completion:^(BOOL finished) {
                
                [_maskView removeFromSuperview];
            }];
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
            
            NSString *useableNum = @"";
            
            if (self.stringtype == 1) {
                useableNum = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].mark floatValue] - [self.beanNumF.text floatValue]];
                [UserModel defaultUser].mark = useableNum;
                self.useableBeanLabel.text = [NSString stringWithFormat:@"可转赠米券:%@",useableNum];
            }else{
                useableNum = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue] - [self.beanNumF.text floatValue]];
                [UserModel defaultUser].ketiBean = useableNum;
                self.useableBeanLabel.text = [NSString stringWithFormat:@"可转赠米子:%@",useableNum];
            }
            
            [usermodelachivar achive];
            
            self.secondPwdF.text = nil;
            self.donationIDF.text = nil;
            self.beanNumF.text = nil;
            self.typeF.text = nil;
            self.usertypeF.text = nil;
            
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
    GLDonationRecordController *recordVC = [[GLDonationRecordController alloc] init];
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
- (IBAction)closeKeybord:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
