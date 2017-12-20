//
//  GLBuyBackController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackController.h"
#import "GLBuyBackChooseCardController.h"
#import "GLSet_MaskVeiw.h"
#import "GLDirectDnationView.h"
#import "GLBuyBackRecordController.h"
#import "GLNoticeView.h"
#import "UIImageView+WebCache.h"

#import "GLBuyBackChooseController.h"
#import "GLBankCardModel.h"
#import "QQPopMenuView.h"
#import "LBMineSelectCustomerTypeView.h"
#import "LBMeterChangePointsRecordViewController.h"
#import "UIButton+SetEdgeInsets.h"

@interface GLBuyBackController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    GLDirectDnationView *_directV;
    GLSet_MaskVeiw * _maskV;
    LoadWaitView *_loadV;
    NSString *_cardNumStr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
//兑换数量
@property (weak, nonatomic) IBOutlet UITextField *buybackNumF;

//二级密码
@property (weak, nonatomic) IBOutlet UITextField *secondPwdF;

@property (weak, nonatomic) IBOutlet UILabel *remainBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainBeanStyleLabel;
//修改银行卡
@property (weak, nonatomic) IBOutlet UIImageView *bankStyleImageV;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageV;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageV;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UITextField *methodtf;
@property (assign, nonatomic)NSInteger typeIndex;

@property (nonatomic, assign)int type;

@property (strong, nonatomic)LBMineSelectCustomerTypeView *SelectCustomerTypeView;
@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *ordertype;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meterView;

@property (weak, nonatomic) IBOutlet UIButton *payOneBt;
@property (weak, nonatomic) IBOutlet UIButton *payTwoBt;
@property (weak, nonatomic) IBOutlet UIButton *payThreeBt;
@property (strong, nonatomic)UIButton *currentBt;

@end

@implementation GLBuyBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"兑换";
    self.view.backgroundColor = [UIColor whiteColor];
    self.headView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;

    self.ensureBtn.layer.cornerRadius = 5.f;
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];

    self.scrollView.delegate = self;
    self.ordertype = @"1";
    self.typeIndex = 1;
    self.type = 1;
    self.currentBt = self.payOneBt;
    
     self.noticeLabel.text = [NSString stringWithFormat:@" 1. 兑换建议优先选择平安银行\n 2. 单笔最多兑换50000颗米子\n 3.T+1:一天后到账,手续费为兑换数量的%.2lf%%\n    T+3:三天后到账,手续费为兑换数量的%.2lf%%\n    T+7:七天后到账,手续费为兑换数量的%.2lf%%\n ", [[UserModel defaultUser].t_one floatValue]*100, [[UserModel defaultUser].t_two floatValue] *100, [[UserModel defaultUser].t_three floatValue] * 100] ;

    self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];

    [self updateBankInfo];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(changeBankNum:) name:@"deleteBankCardNotification" object:nil];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 500;
    self.meterView.constant = 0;
    [self.payOneBt horizontalCenterTitleAndImage:10];
    [self.payTwoBt horizontalCenterTitleAndImage:10];
    [self.payThreeBt horizontalCenterTitleAndImage:10];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(offsetY < 0) {
        CGRect currentFrame = self.headView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = 100 - 1*offsetY;
        self.headView.frame = currentFrame;
       
    }
}
- (void)updateData {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/refresh" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue] == 1){
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]] rangeOfString:@"null"].location != NSNotFound) {
                [UserModel defaultUser].banknumber = @"";
            }else{
                [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            }
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"][@"bankname"]] rangeOfString:@"null"].location != NSNotFound) {
                [UserModel defaultUser].defaultBankname = @"";
            }else{
                
                [UserModel defaultUser].defaultBankname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bankname"]];
            }
            
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"taxes"]];
            [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            [UserModel defaultUser].defaultBankname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bankname"]];
            
            [usermodelachivar achive];

            self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
   
            
        }
        
//        [self updateBankInfo];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

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
    
    if (textField == self.buybackNumF || textField == self.secondPwdF) {
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
- (void)showBankInfo{
    self.bankStyleImageV.hidden = NO;
    self.cardNumLabel.hidden = NO;
    self.cardStyleLabel.hidden = NO;
    self.detailImageV.hidden = NO;
    
    self.addImageV.hidden = YES;
    self.addLabel.hidden = YES;
}
- (void)hideBankInfo {
    self.bankStyleImageV.hidden = YES;
    self.cardNumLabel.hidden = YES;
    self.cardStyleLabel.hidden = YES;
    self.detailImageV.hidden = YES;
    
    self.addImageV.hidden = NO;
    self.addLabel.hidden = NO;

}
- (void)updateBankInfo {
    
    if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].banknumber] rangeOfString:@"null"].location != NSNotFound){

        [self showBankInfo];
    }else{
        
        [self hideBankInfo];
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getbank" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 1){
            [self showBankInfo];
            NSArray *arr = responseObject[@"data"];
            if (arr.count != 0) {
                
                NSString *str = responseObject[@"data"][0][@"number"];

                self.cardNumLabel.text = [NSString stringWithFormat:@"%@*****%@",[str substringToIndex:4],[str substringFromIndex:str.length - 4]];
                _cardNumStr = str;
                self.cardStyleLabel.text = responseObject[@"data"][0][@"name"];
               
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    if([dic[@"status"] intValue] == 1){
                        
                        NSString *numStr = dic[@"number"];
                        self.cardNumLabel.text = [NSString stringWithFormat:@"%@*****%@",[numStr substringToIndex:4],[numStr substringFromIndex:numStr.length - 4]];
                        self.cardStyleLabel.text = dic[@"name"];
                        _cardNumStr = numStr;
                    }
                    
                }
                if ([self.cardStyleLabel.text isEqualToString:@"中国银行"]) {
                    self.bankStyleImageV.image = [UIImage imageNamed:@"BOC"];
                    
                }else if ([self.cardStyleLabel.text isEqualToString:@"中国工商银行"]){
                    self.bankStyleImageV.image = [UIImage imageNamed:@"ICBC"];
                    
                }else if ([self.cardStyleLabel.text isEqualToString:@"中国建设银行"]){
                    self.bankStyleImageV.image = [UIImage imageNamed:@"CCB"];
                    
                }else if ([self.cardStyleLabel.text isEqualToString:@"中国农业银行"]){
                    self.bankStyleImageV.image = [UIImage imageNamed:@"ABC"];
                    
                }else{
                    self.bankStyleImageV.image = [UIImage imageNamed:@"bank_nopicture"];
                }
            }else{
                [self hideBankInfo];
            }
            
        }else{
            [self hideBankInfo];

        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.buybackNumF){
        [self.secondPwdF becomeFirstResponder];
        
    }else if(textField == self.secondPwdF){
        [self.secondPwdF becomeFirstResponder];
        
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
//理财方式
- (IBAction)tapgestureMethod:(UITapGestureRecognizer *)sender {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[sender.view convertRect: sender.view.bounds toView:window];
    
    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:self.typeArr
                              
                                                           width:120
                                                triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, rect.origin.y+20)
                                                          action:^(NSInteger index) {
                                                              
                                                              self.methodtf.text = weakself.typeArr[index][@"title"];
                                                              self.typeIndex = index + 1;
                                                              
                                                              if (index == 0) {
                                                                  self.buybackNumF.text = @"";
                                                                  self.buybackNumF.placeholder = @"请输入100的整数倍";
                                                              }else{
                                                                  self.buybackNumF.text = @"";
                                                                  self.buybackNumF.placeholder = @"请输入500的整数倍至少1000";

                                                              }
                                                              
                                                          }];
    
    popview.isHideImage = YES;
    
    [popview show];
}
//支付方式
- (IBAction)payMethodevent:(UIButton *)sender {
    
    if (sender == self.currentBt) {
        return;
    }
    
    sender.selected = YES;
    self.currentBt.selected = NO;
    self.currentBt = sender;
    
    if (sender == self.payOneBt) {
        self.type = 1;
    }else if (sender == self.payTwoBt){
         self.type = 2;
    }else if (sender == self.payThreeBt){
        self.type = 3;
    }
    
    
}


- (IBAction)ensureClick:(id)sender {

    if ([[NSString stringWithFormat:@"%d",[self.cardNumLabel.text integerValue]] isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }
    if ([[NSString stringWithFormat:@"%d",[self.buybackNumF.text integerValue]] isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"请输入兑换数量"];
        return;
    }else if(![self isPureNumandCharacters:self.buybackNumF.text]){
        [MBProgressHUD showError:@"兑换数量只能为正整数"];
        return;
    }else if([self.buybackNumF.text integerValue] > [self.remainBeanLabel.text integerValue]){
        [MBProgressHUD showError:@"余额不足!"];
        return;
    }
    
    if (self.typeIndex == 1) {
        if ([self.buybackNumF.text integerValue] %100 != 0){
            [MBProgressHUD showError:@"数量必须是100的整数倍!"];
            return;
        }
    }else{
    
        if ([self.buybackNumF.text floatValue] <1000) {
            [MBProgressHUD showError:@"至少兑换1000"];
            return;
        }
        
        if ([self.buybackNumF.text floatValue] > [self.remainBeanLabel.text floatValue]) {
            [MBProgressHUD showError:@"兑换米子超过可兑换米子"];
            return;
        }
        
        if ([self.buybackNumF.text integerValue] % 500  != 0) {
            [MBProgressHUD showError:@"兑换米子需是500的整数倍"];
            return;
        }

    }


    if ( [self.buybackNumF.text integerValue] > 50000){
        [MBProgressHUD showError:[NSString stringWithFormat:@"单笔最多兑换50000颗%@",NormalMoney]];
        return;
    }
    if (self.secondPwdF.text == nil||self.secondPwdF.text.length == 0) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }

    [self ensureBuyback];

}

- (void)ensureBuyback{
    
    self.ensureBtn.userInteractionEnabled = NO;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    NSString *num = [NSString stringWithFormat:@"%d",[self.buybackNumF.text intValue]];
    dict[@"num"] = num;
    dict[@"IDcar"] = _cardNumStr;
    //开户行地址  ???
    dict[@"address"] = self.cardStyleLabel.text;
    
    dict[@"type"] = [NSString stringWithFormat:@"%d",self.type];
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.secondPwdF.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
    dict[@"donatetype"] = @"1";
    dict[@"typer"] = @(self.typeIndex);

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/back" paramDic:dict finish:^(id responseObject) {
        self.ensureBtn.userInteractionEnabled = YES;
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            self.secondPwdF.text = @"";
            self.buybackNumF.text = @"";
            self.methodtf.text = @"";
            
            //刷新信息
            [self updateData];
             [MBProgressHUD showSuccess:@"兑换申请成功"];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        self.ensureBtn.userInteractionEnabled = YES;
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转兑换记录
- (IBAction)buyBackRecord:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLBuyBackRecordController *recordVC = [[GLBuyBackRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];

}

- (IBAction)chooseBank:(id)sender {
    [self.buybackNumF resignFirstResponder];
    [self.secondPwdF resignFirstResponder];
    if (self.addImageV.hidden) {
        self.hidesBottomBarWhenPushed = YES;
        
        GLBuyBackChooseController *chooseVC = [[GLBuyBackChooseController alloc] init];
        
        [chooseVC returnModel:^(GLBankCardModel *model) {
            self.cardNumLabel.text = [NSString stringWithFormat:@"%@*****%@",[model.number substringToIndex:4],[model.number substringFromIndex:model.number.length - 4]];
            self.cardStyleLabel.text = model.name;
            self.bankStyleImageV.image = [UIImage imageNamed:model.iconName];
            _cardNumStr = model.number;
        }];
        [self.navigationController pushViewController:chooseVC animated:YES];
        
    }else{
        
        self.hidesBottomBarWhenPushed = YES;
        GLBuyBackChooseCardController *chooseVC = [[GLBuyBackChooseCardController alloc] init];

        __weak typeof(self) weakself = self;
        chooseVC.returnBlock = ^(NSString *str){
            [weakself updateBankInfo];
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    
}
- (void)changeBankNum:(NSNotification *)notification {
    if ([_cardNumStr isEqualToString:notification.userInfo[@"banknumber"]]) {
        [self updateBankInfo];
    }
}

- (IBAction)chooseStyle:(id)sender {

    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self updateData];

   
}

//线上订单
-(void)selectonlineorder{
    
    self.ordertype = @"1";
    self.SelectCustomerTypeView.imagev1.image = [UIImage imageNamed:@"location_on"];
    self.SelectCustomerTypeView.imagev2.image = [UIImage imageNamed:@"location_off"];
    
}
//线下订单
-(void)selectunderlineorder{
    
    self.ordertype = @"2";
    self.SelectCustomerTypeView.imagev1.image = [UIImage imageNamed:@"location_off"];
    self.SelectCustomerTypeView.imagev2.image = [UIImage imageNamed:@"location_on"];
    
}
#pragma mark ---- 选择线上线下订单类型
-(void)selectCustomerTypeViewCancelBt{
    
    [self.maskView removeFromSuperview];
    [self.SelectCustomerTypeView removeFromSuperview];
}

-(void)selectCustomerTypeViewsureBt{
    
    if ([self.ordertype isEqualToString:@"1"]) {//线上
        self.hidesBottomBarWhenPushed = YES;
        GLBuyBackRecordController *recordVC = [[GLBuyBackRecordController alloc] init];
        [self.navigationController pushViewController:recordVC animated:YES];
        [self.maskView removeFromSuperview];
        [self.SelectCustomerTypeView removeFromSuperview];
    }else  if ([self.ordertype isEqualToString:@"2"]) {//线下
        
        self.hidesBottomBarWhenPushed = YES;
        LBMeterChangePointsRecordViewController *recordVC = [[LBMeterChangePointsRecordViewController alloc] init];
        [self.navigationController pushViewController:recordVC animated:YES];
        [self.maskView removeFromSuperview];
        [self.SelectCustomerTypeView removeFromSuperview];
    }
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        
    }
    return _maskView;
    
}

-(LBMineSelectCustomerTypeView*)SelectCustomerTypeView{
    
    if (!_SelectCustomerTypeView) {
        _SelectCustomerTypeView=[[NSBundle mainBundle]loadNibNamed:@"LBMineSelectCustomerTypeView" owner:self options:nil].firstObject;
        _SelectCustomerTypeView.frame=CGRectMake(20, (SCREEN_HEIGHT - 210)/2, SCREEN_WIDTH-40, 201);
        _SelectCustomerTypeView.alpha=1;
        UITapGestureRecognizer *shanVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectonlineorder)];
        
        [_SelectCustomerTypeView.baseView1 addGestureRecognizer:shanVgesture];
        UITapGestureRecognizer *lingVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectunderlineorder)];
        [_SelectCustomerTypeView.baseView2 addGestureRecognizer:lingVgesture];
        [_SelectCustomerTypeView.cancelBt addTarget:self action:@selector(selectCustomerTypeViewCancelBt) forControlEvents:UIControlEventTouchUpInside];
        [_SelectCustomerTypeView.sureBt addTarget:self action:@selector(selectCustomerTypeViewsureBt) forControlEvents:UIControlEventTouchUpInside];
        _SelectCustomerTypeView.layer.cornerRadius = 4;
        _SelectCustomerTypeView.clipsToBounds = YES;
        
    }
    
    return _SelectCustomerTypeView;
    
}

- (IBAction)closeKeybord:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
