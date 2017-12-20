//
//  GLBuyBackChooseCardController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackChooseCardController.h"
#import "predicateModel.h"
#import "GLSet_MaskVeiw.h"
#import "GLBuyBackChooseBankView.h"

@interface GLBuyBackChooseCardController ()
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
    GLBuyBackChooseBankView *_contentV;
    
}
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardTextF;
@property (weak, nonatomic) IBOutlet UIButton *chooseBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressF;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;


@end

@implementation GLBuyBackChooseCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ensureBtn.layer.cornerRadius = 5.f;
    self.title = @"修改银行卡";
    self.nameLabel.text =[NSString stringWithFormat:@"%@",[UserModel defaultUser].truename];
    self.navigationController.navigationBar.hidden = NO;
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


- (IBAction)chooseBank:(id)sender {
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskV.bgView.alpha = 0.3;
    
    _contentV = [[NSBundle mainBundle] loadNibNamed:@"GLBuyBackChooseBankView" owner:nil options:nil].lastObject;
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.chooseBankBtn convertRect: self.chooseBankBtn.bounds toView:window];
    
    _contentV.frame = CGRectMake(20,CGRectGetMaxY(rect) + 10, SCREEN_WIDTH - 40, SCREEN_HEIGHT * 0.5);
    
    __weak __typeof(self)weakSelf = self;
    _contentV.block = ^(NSString *str){
        weakSelf.bankLabel.text = str;
        [weakSelf dismiss];
    };
    //    if([[UserModel defaultUser].userLogin integerValue] == 1){
    //        [_directV.taxBtn setTitle:@"待缴税志愿豆" forState:UIControlStateNormal];
    //
    //    }else{
    //
    //        [_directV.taxBtn setTitle:@"待提供发票志愿豆" forState:UIControlStateNormal];
    //    }
    _contentV.backgroundColor = [UIColor whiteColor];
    _contentV.layer.cornerRadius = 4;
    _contentV.layer.masksToBounds = YES;
    
    [_maskV showViewWithContentView:_contentV];
}
- (void)chooseValue:(UIButton *)sender{
   
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
    
    if (self.cardTextF.text == nil||self.cardTextF.text.length == 0) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }else if(![self isPureNumandCharacters:self.cardTextF.text]){
        [MBProgressHUD showError:@"银行卡号只能为数字"];
        return;
        
    }else if(![predicateModel IsBankCard:self.cardTextF.text]){
        [MBProgressHUD showError:@"输入的银行卡不合法"];
        return;
    }else if(self.addressF.text.length <= 0){
        [MBProgressHUD showError:@"请输入开户行地址"];
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"bankname"] = self.bankLabel.text;
    dict[@"address"] = self.addressF.text;
    dict[@"isDefault"] = @(self.switchBtn.isOn);
    dict[@"number"] = [NSString stringWithFormat:@"%@",self.cardTextF.text];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/add_bank_num" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];


        if ([responseObject[@"code"] integerValue] == 1) {
            
            if (self.returnBlock) {
                self.returnBlock(@"ninamhhj");
            }

  
            self.cardTextF.text = nil;
            
            [MBProgressHUD showSuccess:@"添加银行卡成功"];
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
    
    if (textField == self.cardTextF && [string isEqualToString:@"\n"]) {
        [self.addressF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.addressF && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
    
}


@end
