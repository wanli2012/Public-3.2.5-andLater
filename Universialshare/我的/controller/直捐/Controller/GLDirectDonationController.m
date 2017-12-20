//
//  GLDirectDonationController.m
//  PovertyAlleviation
//
//  Created by 龚磊 on 2017/3/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDirectDonationController.h"
#import "GLSet_MaskVeiw.h"
#import "GLDirectDnationView.h"
#import "GLDirectDnationRecordController.h"
#import "GLNoticeView.h"

@interface GLDirectDonationController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    GLDirectDnationView *_directV;
    GLSet_MaskVeiw * _maskV;
    LoadWaitView *_loadV;
    BOOL _isHaveDian;
}
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet UILabel *beanStyleLabel;

@property (weak, nonatomic) IBOutlet UITextField *donationNumT;

@property (weak, nonatomic) IBOutlet UITextField *secondPwdT;
@property (weak, nonatomic) IBOutlet UILabel *useableBeanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *userableBeanStyleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewW;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation GLDirectDonationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self updateData];
}
- (void)setupUI{
    self.title = @"我要直捐";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.ensureBtn.layer.cornerRadius = 5.f;
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
    self.scrollView.delegate = self;
    
    self.donationNumT.returnKeyType = UIReturnKeyNext;
    self.secondPwdT.returnKeyType = UIReturnKeyDone;
    self.donationNumT.delegate = self;
    self.secondPwdT.delegate = self;
    
    self.useableBeanNumLabel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].ketiBean];
    if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {
        
        self.userableBeanStyleLabel.text = @"可直捐米子:";
    }else{
        self.userableBeanStyleLabel.text = @"可直捐推荐米子:";
    }
    self.bgViewH.constant = SCREEN_HEIGHT - 64;
    self.bgViewW.constant = SCREEN_WIDTH;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
}
//移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)dismiss {
    

    [UIView animateWithDuration:0.3 animations:^{
        
        _maskV.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.donationNumT){
        [self.secondPwdT becomeFirstResponder];
        
    }else if(textField == self.secondPwdT){
        [self.secondPwdT becomeFirstResponder];
        
    }
    return YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)DirectDonationRecord:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLDirectDnationRecordController *recordVC = [[GLDirectDnationRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
- (void)pushToRecordVC{
    
}
- (IBAction)chooseStyle:(id)sender {

//    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _maskV.bgView.alpha = 0.1;
//    
//    _directV = [[NSBundle mainBundle] loadNibNamed:@"GLDirectDnationView" owner:nil options:nil].lastObject;
//    [_directV.normalBtn addTarget:self action:@selector(chooseValue:) forControlEvents:UIControlEventTouchUpInside];
//    [_directV.taxBtn addTarget:self action:@selector(chooseValue:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect rect=[self.chooseBtn convertRect: self.chooseBtn.bounds toView:window];
//    
//    _directV.frame = CGRectMake(0,CGRectGetMaxY(rect), SCREEN_WIDTH, 3 * self.chooseBtn.yy_height);
//    
//    _directV.backgroundColor = [UIColor whiteColor];
//    _directV.layer.cornerRadius = 4;
//    _directV.layer.masksToBounds = YES;
//    
//    [_maskV showViewWithContentView:_directV];
    
}

- (void)chooseValue:(UIButton *)sender {
    
    if (sender== _directV.normalBtn) {
        self.beanStyleLabel.text = NormalMoney;
        self.useableBeanNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[[UserModel defaultUser].ketiBean integerValue]];
        
        self.userableBeanStyleLabel.text = @"可直捐米子:";
        
    }else{
        
        self.beanStyleLabel.text = SpecialMoney;
        self.useableBeanNumLabel.text = [NSString stringWithFormat:@"%ld",[[UserModel defaultUser].djs_bean integerValue]];
        self.userableBeanStyleLabel.text = @"可直捐推荐米子:";
    }
    [self dismiss];
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

- (IBAction)ensureClick:(id)sender {
    
    //判断
    if (self.donationNumT.text == nil||self.donationNumT.text.length == 0) {
        [MBProgressHUD showError:@"请输入捐赠数量"];
        return;
    }
    if ([self.beanStyleLabel.text isEqualToString:NormalMoney]){
        
        if([self.donationNumT.text integerValue] > [[UserModel defaultUser].ketiBean integerValue]){
            [MBProgressHUD showError:@"余额不足,请充值!"];
            return;
        }
    }else{
        if([self.donationNumT.text integerValue] > [[UserModel defaultUser].djs_bean integerValue]){
            [MBProgressHUD showError:@"余额不足,请充值!"];
            return;
        }
    }
    
    if(![self isPureNumandCharacters:self.donationNumT.text]){
        [MBProgressHUD showError:@"捐赠数量只能为正整数"];
        return;
    }
    if (self.secondPwdT.text == nil || self.secondPwdT.text.length == 0) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
    
    CGFloat contentViewH = 200;
    CGFloat contentViewW = SCREEN_WIDTH - 40;
    
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskV.bgView.alpha = 0.4;
    
    GLNoticeView *contentView = [[NSBundle mainBundle] loadNibNamed:@"GLNoticeView" owner:nil options:nil].lastObject;
    contentView.frame = CGRectMake(20, (SCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    [contentView.cancelBtn addTarget:self action:@selector(cancelDonation) forControlEvents:UIControlEventTouchUpInside];
    [contentView.ensureBtn addTarget:self action:@selector(ensureDonation) forControlEvents:UIControlEventTouchUpInside];
    contentView.contentLabel.text = @"您是否选择捐赠?大众共享基金会将会感谢您的每一份善心!";
    [_maskV showViewWithContentView:contentView];
    
}
- (void)cancelDonation {
    [UIView animateWithDuration:0.2 animations:^{
        _maskV.alpha = 0;
    }completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
    }];
}
- (void)ensureDonation {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"num"] = @([self.donationNumT.text doubleValue]);
    NSString *encryptsecret = [RSAEncryptor encryptString:self.secondPwdT.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
    NSString *beanStyle = self.beanStyleLabel.text;
    //0 米劵   1 米子
    
    if ([beanStyle isEqualToString:NormalMoney]) {
        dict[@"donatetype"] = @"1";
    }else{
        dict[@"donatetype"] = @"0";
    }
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:@"User/donation" paramDic:dict finish:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            
            [self cancelDonation];
            self.donationNumT.text = nil;
            self.secondPwdT.text = nil;
            
            [self updateData];
            [MBProgressHUD showSuccess:@"直捐成功!"];
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
- (void)updateData {
    //刷新信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:@"User/refresh" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            
            //                    NSLog(@"%@",responseObject);
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"taxes"]];
            [usermodelachivar achive];
            //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataNotification" object:nil];
            
            if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {
                
                self.useableBeanNumLabel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].ketiBean];
                
                self.userableBeanStyleLabel.text = @"可直捐米子:";
                
            }else{
                self.useableBeanNumLabel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].djs_bean];
                 self.userableBeanStyleLabel.text = @"可直捐推荐米子:";
            }
//            [MBProgressHUD showSuccess:@"直捐成功!"];
        }else{
            
            [MBProgressHUD showError:@"数据提交异常,请重试!"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:@"数据提交异常,请重试!"];
    }];

}
//用 bounces 属性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.donationNumT || textField == self.secondPwdT) {
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

@end
