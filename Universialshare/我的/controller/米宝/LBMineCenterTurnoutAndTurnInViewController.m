//
//  LBMineCenterTurnoutAndTurnInViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterTurnoutAndTurnInViewController.h"
#import "LBTurnoutAndTurnInRecoderViewController.h"
#import "LBCustomAttribuText.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LBMineCenterTurnoutAndTurnInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *navatitile;
@property (weak, nonatomic) IBOutlet UILabel *lebelO;
@property (weak, nonatomic) IBOutlet UILabel *lebelt;
@property (weak, nonatomic) IBOutlet UITextField *numtf;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *viewo;
@property (weak, nonatomic) IBOutlet UIButton *surebt;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet UILabel *meboPrice;


@end

@implementation LBMineCenterTurnoutAndTurnInViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        self.navatitile.text = @"转出";
        self.lebelO.text = @"转出到米子";
        self.lebelt.text = @"转出金额";
        [self.button setTitle:@"全部转出" forState:UIControlStateNormal];
        [self.surebt setTitle:@"确认转出" forState:UIControlStateNormal];
        self.numtf.placeholder =[NSString stringWithFormat:@"可转出米宝%@",[UserModel defaultUser].meeple];
        self.numtf.keyboardType = UIKeyboardTypeDecimalPad;
        self.contentLb.text=@"米宝转出：\n 1.您将米宝转出成米子，系统将收取转出总金额的3%作为手续费\n 2.米宝转成米子，米子将在转出后七天内到账\n 3.米宝转成米子，为方便结算，转出金额必须大于1";
        
    }else if (_type == 2){
        self.navatitile.text = @"转入";
        self.lebelO.text = @"转入到米宝";
        self.lebelt.text = @"转入金额";
        [self.button setTitle:@"全部转入" forState:UIControlStateNormal];
        [self.surebt setTitle:@"确认转入" forState:UIControlStateNormal];
         self.numtf.placeholder =[NSString stringWithFormat:@"可转入米子%@",[UserModel defaultUser].ketiBean];
        self.numtf.keyboardType = UIKeyboardTypeDecimalPad;
        self.contentLb.text=@"米宝转入：\n 1.您将米子转入米宝后，即可获得等量的米宝\n 2.米宝每天会根据米子结算收益自动增长\n 3.米子转入米宝，为方便结算，转入金额必须大于1";
    }
  
        NSString *singalstr = [NSString stringWithFormat:@"%.2f",self.singalPrice];
        self.meboPrice.attributedText = [LBCustomAttribuText originstr: [NSString stringWithFormat:@"注：今日米宝单价%@",singalstr] specilstrarr:@[singalstr] attribus:@{NSForegroundColorAttributeName:TABBARTITLE_COLOR}];
    
    
    [[self.numtf rac_textSignal] subscribeNext:^(NSString *x) {
        
        if (x.length <= 0) {
            NSString *singalstr = [NSString stringWithFormat:@"%.2f",self.singalPrice];
            self.meboPrice.attributedText = [LBCustomAttribuText originstr: [NSString stringWithFormat:@"注：今日米宝单价%@",singalstr] specilstrarr:@[singalstr] attribus:@{NSForegroundColorAttributeName:TABBARTITLE_COLOR}];
        }else{
            
            if (_type == 1) {
                
                if ([x floatValue] > [[UserModel defaultUser].meeple floatValue]) {
                    [MBProgressHUD showError:@"米宝不足"];
                    return ;
                }
                
                CGFloat  outPrice = [x floatValue] * self.singalPrice;
                NSString *outPriceStr = [NSString stringWithFormat:@"%.2f",outPrice];
                NSString *singalstr = [NSString stringWithFormat:@"%.2f",self.singalPrice];
                
                self.meboPrice.attributedText = [LBCustomAttribuText originstr: [NSString stringWithFormat:@"注：今日米宝单价%@，可兑出%@元",singalstr,outPriceStr] specilstrarr:@[outPriceStr,singalstr] attribus:@{NSForegroundColorAttributeName:TABBARTITLE_COLOR}];
                
            }else if (_type == 2){
                if ([x floatValue] > [[UserModel defaultUser].ketiBean floatValue]) {
                    [MBProgressHUD showError:@"米子不足"];
                    return ;
                }
                CGFloat  outPrice = [x floatValue] / self.singalPrice;
                NSString *outPriceStr = [NSString stringWithFormat:@"%.2f",outPrice];
                NSString *singalstr = [NSString stringWithFormat:@"%.2f",self.singalPrice];
                
                self.meboPrice.attributedText = [LBCustomAttribuText originstr: [NSString stringWithFormat:@"注：今日米宝单价%@，可兑出%@米宝",singalstr,outPriceStr] specilstrarr:@[outPriceStr,singalstr] attribus:@{NSForegroundColorAttributeName:TABBARTITLE_COLOR}];
            }
        }
        
    }];
    
}

//全部转出
- (IBAction)allTrunout:(UIButton *)sender {
    if (_type == 1) {
       self.numtf.text = [UserModel defaultUser].meeple;
        CGFloat  outPrice = [[UserModel defaultUser].meeple floatValue] * self.singalPrice;
        NSString *outPriceStr = [NSString stringWithFormat:@"%.2f",outPrice];
        NSString *singalstr = [NSString stringWithFormat:@"%.2f",self.singalPrice];
        
        self.meboPrice.attributedText = [LBCustomAttribuText originstr: [NSString stringWithFormat:@"注：今日米宝单价%@，可兑出%@元",singalstr,outPriceStr] specilstrarr:@[outPriceStr,singalstr] attribus:@{NSForegroundColorAttributeName:TABBARTITLE_COLOR}];
        
    }else if (_type == 2){
       self.numtf.text = [UserModel defaultUser].ketiBean;
        CGFloat  outPrice = [[UserModel defaultUser].ketiBean floatValue] / self.singalPrice;
        NSString *outPriceStr = [NSString stringWithFormat:@"%.2f",outPrice];
        NSString *singalstr = [NSString stringWithFormat:@"%.2f",self.singalPrice];
        
        self.meboPrice.attributedText = [LBCustomAttribuText originstr: [NSString stringWithFormat:@"注：今日米宝单价%@，可兑出%@米宝",singalstr,outPriceStr] specilstrarr:@[outPriceStr,singalstr] attribus:@{NSForegroundColorAttributeName:TABBARTITLE_COLOR}];
    }
}
// 确认
- (IBAction)surebuttonEvent:(UIButton *)sender {
    
    if ([self.numtf.text floatValue] <= 0) {
        [MBProgressHUD showError:@"不能小于等于零"];
        return;
    }
    
    if ([self.numtf.text floatValue] <= 1) {
        [MBProgressHUD showError:@"必须大于1"];
        return;
    }
    
    if (_type == 1) {
        [self sureTurnOut];
    }else{
        
        [self sureTurnIn];
    }
}
//转出
-(void)sureTurnOut{
    if ([self.numtf.text doubleValue] > [[UserModel defaultUser].meeple doubleValue]) {
        [MBProgressHUD showError:@"米宝不足"];
        return;
    }
    
    if ([self.numtf.text hasPrefix:@"."] || [self.numtf.text hasSuffix:@"."]) {
        [MBProgressHUD showError:@"输入不合法"];
        return;
    }
    
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"num"] = self.numtf.text;
    dic[@"type"] = @"2";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Meeple/meeple_operation" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
           
            [UserModel defaultUser].meeple = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"meeple"]];
             [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"keti_bean"]];
            [usermodelachivar achive];
            self.numtf.text = @"";
            self.numtf.placeholder =[NSString stringWithFormat:@"可转出米宝%@",[UserModel defaultUser].meeple];
             [MBProgressHUD showError:@"转出成功"];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}
//转入
-(void)sureTurnIn{
    if ([self.numtf.text doubleValue] > [[UserModel defaultUser].ketiBean doubleValue]) {
        [MBProgressHUD showError:@"米子不足"];
        return;
    }
    
    if ([self.numtf.text hasPrefix:@"."] || [self.numtf.text hasSuffix:@"."]) {
        [MBProgressHUD showError:@"输入不合法"];
        return;
    }
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"num"] = self.numtf.text;
    dic[@"type"] = @"1";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Meeple/meeple_operation" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            [UserModel defaultUser].meeple = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"meeple"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"keti_bean"]];
            [usermodelachivar achive];
            self.numtf.text = @"";
            self.numtf.placeholder =[NSString stringWithFormat:@"可转入米子%@",[UserModel defaultUser].ketiBean];
             [MBProgressHUD showError:@"转入成功"];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}

//记录
- (IBAction)recoderEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBTurnoutAndTurnInRecoderViewController *vc =[[LBTurnoutAndTurnInRecoderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewo.layer.borderWidth = 1;
    self.viewo.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;

    self.surebt.layer.cornerRadius = 3;
    self.surebt.clipsToBounds = YES;
    self.contentW.constant = SCREEN_WIDTH - 20;

}
- (IBAction)tapgestureCloseKeyBoard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


@end
