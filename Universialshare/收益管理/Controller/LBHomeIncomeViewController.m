//
//  LBHomeIncomeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeIncomeViewController.h"
#import "LBHomeIncomeFristViewController.h"
#import "LBHomeIncomesecondViewController.h"
#import "LBApplicationLimitView.h"
#import "SelectUserTypeView.h"
#import "LBHomeIncomefourthViewController.h"
#import "LBHomeIncomethirdViewController.h"
#import "GLIncomeManagerRecommendController.h"
#import "GLIncomeManagerRewardController.h"
#import "LBHomeIncomeSearchViewController.h"

@interface LBHomeIncomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic)LBHomeIncomeFristViewController *fristVc;//线上收益
@property (strong, nonatomic)LBHomeIncomesecondViewController *secondVc;//线下收益
@property (strong, nonatomic)LBHomeIncomethirdViewController *thirdVc;//商户
@property (strong, nonatomic)LBHomeIncomefourthViewController *fourthVc;//团队
@property (strong, nonatomic)GLIncomeManagerRecommendController *fiveVc;//推荐
@property (strong, nonatomic)GLIncomeManagerRewardController *sixVc;//奖励

@property (strong, nonatomic)UIViewController *currentVC;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *onlineBt;
@property (weak, nonatomic) IBOutlet UIButton *underLineBt;
@property (strong, nonatomic)UIView *lineView;

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)UIView *choseView;
@property (strong, nonatomic)UIButton *memberBt;//会员
@property (strong, nonatomic)UIButton *achieveBt;//业绩

@property (assign, nonatomic)NSInteger type;//判断业绩还是会员类型。默认为1 业绩
@property (assign, nonatomic)NSInteger buttontype;//判断选中的第几个按钮，1表示线上 2表示线下 ，默认为1

@property(nonatomic , strong) UIButton *backbutton;//申请额度

@property (strong, nonatomic)UIView *maskapplyView;
@property (strong, nonatomic)LBApplicationLimitView *loginView;
@property (strong, nonatomic)SelectUserTypeView *selectUserTypeView;
@property (nonatomic, copy)NSString *limittype;//限额类型
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBHomeIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = 1;
    self.buttontype =1;
    self.limittype = @"1";
    
    [self.choseView addSubview:self.memberBt];
    [self.choseView addSubview:self.achieveBt];
    [self.maskView addSubview:self.choseView];
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        [self.view addSubview:self.backbutton];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.maskView.hidden = YES;

    self.navigationController.navigationBar.hidden = YES;
    [self.buttonView addSubview:self.lineView];
   _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.fiveVc = [[GLIncomeManagerRecommendController alloc] init];
    self.fiveVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
    
    self.sixVc = [[GLIncomeManagerRewardController alloc] init];
    self.sixVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {//商户
        //设置默认控制器为fristVc
        self.fristVc = [[LBHomeIncomeFristViewController alloc] init];
        self.fristVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
        [self addChildViewController:_fristVc];
        
        self.secondVc = [[LBHomeIncomesecondViewController alloc] init];
        self.secondVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
        
        self.currentVC = self.fristVc;
        [self.view addSubview:self.fristVc.view];
        
        [self.onlineBt setTitle:@"线上业绩" forState:UIControlStateNormal];
        [self.underLineBt setTitle:@"线下业绩" forState:UIControlStateNormal];
    }else {//创客或者服务中心
        //设置默认控制器为fristVc
        self.thirdVc = [[LBHomeIncomethirdViewController alloc] init];
        self.thirdVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
        [self addChildViewController:_thirdVc];
        
        self.fourthVc = [[LBHomeIncomefourthViewController alloc] init];
        self.fourthVc.view.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
        
        self.currentVC = self.thirdVc;
        [self.view addSubview:self.thirdVc.view];
        [self.onlineBt setTitle:@"商户" forState:UIControlStateNormal];
        [self.underLineBt setTitle:@"团队" forState:UIControlStateNormal];
        
    }

    [_loadV removeloadview];

}

//筛选
- (IBAction)filterEvent:(UIButton *)sender {
    
    self.maskView.hidden = NO;
    
}
//搜索
- (IBAction)searchevent:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBHomeIncomeSearchViewController *vc =[[LBHomeIncomeSearchViewController alloc]init];
     if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {//商户
         if (self.type == 1) {
             vc.typer = 2;
         }else{
             vc.typer = 1;
         }
     }else{
         if (self.type == 1) {
             vc.typer = 3;
         }else{
             vc.typer = 1;
         }
     }
    [self.navigationController pushViewController:vc animated:NO];
}


//退出
- (IBAction)applyMoneny:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}
//线上
- (IBAction)onlineevnt:(UIButton *)sender {
     self.buttontype =1;
     if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {//商户
         if (self.type == 1) {
             if (self.currentVC == self.fristVc) {
                 return;
             }
             self.onlineBt.selected = YES;
             self.underLineBt.selected = NO;
             [UIView animateWithDuration:.5 animations:^{
                 self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1);
             }];
             [self replaceFromOldViewController:self.currentVC toNewViewController:self.fristVc];
         }else{
             if (self.currentVC == self.fiveVc) {
                 return;
             }
             self.onlineBt.selected = YES;
             self.underLineBt.selected = NO;
             [UIView animateWithDuration:.5 animations:^{
                 self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1);
             }];
             [self replaceFromOldViewController:self.currentVC toNewViewController:self.fiveVc];
         }
     }else{
     
         if (self.type == 1) {
             if (self.currentVC == self.thirdVc) {
                 return;
             }
             self.onlineBt.selected = YES;
             self.underLineBt.selected = NO;
             [UIView animateWithDuration:.5 animations:^{
                 self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1);
             }];
             [self replaceFromOldViewController:self.currentVC toNewViewController:self.thirdVc];
         }else{
             if (self.currentVC == self.fiveVc) {
                 return;
             }
             self.onlineBt.selected = YES;
             self.underLineBt.selected = NO;
             [UIView animateWithDuration:.5 animations:^{
                 self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1);
             }];
             [self replaceFromOldViewController:self.currentVC toNewViewController:self.fiveVc];
         }
     }

}
//线下
- (IBAction)underlineEvent:(UIButton *)sender {
     self.buttontype =2;
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {//商户
        if (self.type == 1) {
            if (self.currentVC == self.secondVc) {
                return;
            }
            self.onlineBt.selected = NO;
            self.underLineBt.selected = YES;
            [UIView animateWithDuration:.5 animations:^{
                self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2 + SCREEN_WIDTH/2, 49, 100, 1);
            }];
            [self replaceFromOldViewController:self.currentVC toNewViewController:self.secondVc];
        }else{
            if (self.currentVC == self.sixVc) {
                return;
            }
            self.onlineBt.selected = NO;
            self.underLineBt.selected = YES;
            [UIView animateWithDuration:.5 animations:^{
                self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2 + SCREEN_WIDTH/2, 49, 100, 1);
            }];
            [self replaceFromOldViewController:self.currentVC toNewViewController:self.sixVc];
        }
        
    }else{
        
        if (self.type == 1) {
            if (self.currentVC == self.fourthVc) {
                return;
            }
            self.onlineBt.selected = NO;
            self.underLineBt.selected = YES;
            [UIView animateWithDuration:.5 animations:^{
                self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2 + SCREEN_WIDTH/2, 49, 100, 1);
            }];
            [self replaceFromOldViewController:self.currentVC toNewViewController:self.fourthVc];
        }else{
            if (self.currentVC == self.sixVc) {
                return;
            }
            self.onlineBt.selected = NO;
            self.underLineBt.selected = YES;
            [UIView animateWithDuration:.5 animations:^{
                self.lineView.frame = CGRectMake((SCREEN_WIDTH/2 - 100)/2 + SCREEN_WIDTH/2, 49, 100, 1);
            }];
            [self replaceFromOldViewController:self.currentVC toNewViewController:self.sixVc];
        }
    
    }
    
}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
            if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
                [self.backbutton removeFromSuperview];
                [self.view addSubview:self.backbutton];
            }
        }else{
            self.currentVC = oldVc;
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([[UserModel defaultUser].isapplication isEqualToString:@"1"]) {
        [self.backbutton setTitle:[NSString stringWithFormat:@"等待\n审核"] forState:UIControlStateNormal];
        self.backbutton.userInteractionEnabled = NO;
    }else{
        [self.backbutton setTitle:[NSString stringWithFormat:@"申请\n额度"] forState:UIControlStateNormal];
        self.backbutton.userInteractionEnabled = YES;
    }
    
}
//点击遮罩
-(void)tapgestureMaskview{

      self.maskView.hidden = YES;
}
//点击业绩
-(void)clickachieveEvent{
   self.type = 1;
    
    if (self.buttontype == 1) {
        [self onlineevnt:nil];
    }else{
         [self underlineEvent:nil];
    
    }
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {//商户
        [self.onlineBt setTitle:@"线上业绩" forState:UIControlStateNormal];
        [self.underLineBt setTitle:@"线下业绩" forState:UIControlStateNormal];
    }else{
        [self.onlineBt setTitle:@"商户" forState:UIControlStateNormal];
        [self.underLineBt setTitle:@"团队" forState:UIControlStateNormal];
    }
    self.maskView.hidden = YES;

}
//点击会员
-(void)clickmemberEvent{
     self.type = 2;
    if (self.buttontype == 1) {
        [self onlineevnt:nil];
    }else{
        [self underlineEvent:nil];
        
    }
    [self.onlineBt setTitle:@"推荐" forState:UIControlStateNormal];
    [self.underLineBt setTitle:@"奖励" forState:UIControlStateNormal];
    self.maskView.hidden = YES;
}

//申请额度
-(void)backHomeBtbtton{
    [self.view addSubview:self.maskapplyView];
    [self.view addSubview:self.loginView];
    
}
- (void)getcode:(UIButton *)sender {
    
    if (![predicateModel valiMobile:[UserModel defaultUser].phone]) {
        [MBProgressHUD showError:@"手机号格式不对"];
        return;
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}
//点击maskview
-(void)maskviewgesture{
    
    [self.selectUserTypeView removeFromSuperview];
    [self.maskapplyView removeFromSuperview];
    [self.loginView removeFromSuperview];
    
}
//确认申请
-(void)sureapplication{
    
    if (self.loginView.phoneTf.text .length <= 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    if (self.loginView.yzmTf.text .length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (self.loginView.moneyTF.text .length <= 0) {
        [MBProgressHUD showError:@"请输入申请额度"];
        return;
    }
    
    if ([self.loginView.moneyTF.text  floatValue] <=  0) {
        [MBProgressHUD showError:@"输入金额大于0"];
        return;
    }
    
    if ([self.limittype isEqualToString:@"1"]) {//每日限额
        if ([self.loginView.moneyTF.text  floatValue] < [[UserModel defaultUser].allLimit floatValue]) {
            [MBProgressHUD showError:@"输入大于当前额度"];
            return;
        }
    }else if ([self.limittype isEqualToString:@"2"]){//每单限额
        if ([self.loginView.moneyTF.text  floatValue] < [[UserModel defaultUser].single floatValue]) {
            [MBProgressHUD showError:@"输入大于当前额度"];
            return;
        }
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:@"User/applyMoreSaleMoney"
                                 paramDic:@{@"yzm":self.loginView.yzmTf.text,
                                            @"uid":[UserModel defaultUser].uid,
                                            @"token":[UserModel defaultUser].token,
                                            @"userphone":[UserModel defaultUser].phone,
                                            @"money":self.loginView.moneyTF.text,
                                            @"type":self.limittype}
                                   finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         
         if ([responseObject[@"code"] integerValue]==1) {
             [self maskviewgesture];
             [self.backbutton setTitle:[NSString stringWithFormat:@"等待\n审核"] forState:UIControlStateNormal];
             self.backbutton.userInteractionEnabled = NO;
             [UserModel defaultUser].isapplication = @"1";
             [usermodelachivar achive];
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
         }
         
     } enError:^(NSError *error) {
         [_loadV removeloadview];
         [MBProgressHUD showError:error.localizedDescription];
         
     }];
    
}

//弹出限额类型选择View
- (void)popTypeView {
    
    [self.loginView addSubview:self.selectUserTypeView];
    
    if (self.selectUserTypeView.height == 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.selectUserTypeView.height = 80;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.selectUserTypeView.height = 0;
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    self.selectUserTypeView.block = ^(NSInteger index){
        
        if(index == 0){
            weakSelf.limittype = @"1";
            weakSelf.loginView.typeLabel.text = @"每日限额";
        }else{
            weakSelf.limittype = @"2";
            weakSelf.loginView.typeLabel.text = @"每单限额";
        }
        
    };
    
}


//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.loginView.yzmbt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.loginView.yzmbt.userInteractionEnabled = YES;
                self.loginView.yzmbt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.loginView.yzmbt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.yzmbt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.loginView.yzmbt.userInteractionEnabled = NO;
                self.loginView.yzmbt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.loginView.yzmbt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.searchView.layer.cornerRadius = 4;
    self.searchView.clipsToBounds = YES;
    
}

-(UIView*)lineView{

    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 100)/2, 49, 100, 1)];
        _lineView.backgroundColor = YYSRGBColor(235, 136, 26, 1);
    }
    
    return _lineView;

}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMaskview)];
        [_maskView addGestureRecognizer:tapgesture];
    }
    
    return _maskView;
    
}

-(UIView*)choseView{
    
    if (!_choseView) {
        _choseView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 30, 70, 80)];
        _choseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
       
    }
    
    return _choseView;
    
}

-(UIButton*)memberBt{

    if (!_memberBt) {
        _memberBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.choseView.width, self.choseView.height/2.0)];
        [_memberBt setTitle:@"会员" forState:UIControlStateNormal];
        [_memberBt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _memberBt.titleLabel.font = [UIFont systemFontOfSize:15];
        _memberBt.backgroundColor = [UIColor whiteColor];
        [_memberBt addTarget:self action:@selector(clickmemberEvent) forControlEvents:UIControlEventTouchUpInside];
    }

    return _memberBt;
}

-(UIButton*)achieveBt{
    
    if (!_achieveBt) {
        _achieveBt = [[UIButton alloc]initWithFrame:CGRectMake(0, self.choseView.height/2.0 + 1, self.choseView.width, self.choseView.height/2.0 -1)];
        [_achieveBt setTitle:@"业绩" forState:UIControlStateNormal];
        [_achieveBt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _achieveBt.titleLabel.font = [UIFont systemFontOfSize:15];
        _achieveBt.backgroundColor = [UIColor whiteColor];
        [_achieveBt addTarget:self action:@selector(clickachieveEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _achieveBt;
}

-(UIButton*)backbutton{
    
    if (!_backbutton) {
        _backbutton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - 80, 60, 60)];
        _backbutton.backgroundColor=YYSRGBColor(120,161,255, 0.8);
        _backbutton.titleLabel.font=[UIFont systemFontOfSize:13];
        [_backbutton addTarget:self action:@selector(backHomeBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_backbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backbutton.layer.cornerRadius =30;
        _backbutton.clipsToBounds =YES;
        _backbutton.titleLabel.numberOfLines = 0;
    }
    
    return _backbutton;
    
}
-(UIView*)maskapplyView{
    
    if (!_maskapplyView) {
        _maskapplyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskapplyView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
        
    }
    return _maskapplyView;
    
}
-(LBApplicationLimitView*)loginView{
    
    if (!_loginView) {
        _loginView=[[NSBundle mainBundle]loadNibNamed:@"LBApplicationLimitView" owner:self options:nil].firstObject;
        _loginView.frame=CGRectMake(20, (SCREEN_HEIGHT - 64 - 280)/2, SCREEN_WIDTH-40, 280);
        _loginView.alpha=1;
        _loginView.layer.cornerRadius = 4;
        _loginView.clipsToBounds = YES;
        [_loginView.yzmbt addTarget:self action:@selector(getcode:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.cancelBt addTarget:self action:@selector(maskviewgesture) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.sureBt addTarget:self action:@selector(sureapplication) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTypeView)];
        [_loginView.typeView addGestureRecognizer:tap];
        _loginView.typeLabel.text = @"每日限额";
        _loginView.phoneTf.text = [NSString stringWithFormat:@"%@*****%@",[[UserModel defaultUser].phone substringToIndex:3],[[UserModel defaultUser].phone substringFromIndex:7]];
        
    }
    return _loginView;
    
}
//限额选择View
-(SelectUserTypeView*)selectUserTypeView{
    
    if (!_selectUserTypeView) {
        
        _selectUserTypeView=[[NSBundle mainBundle]loadNibNamed:@"SelectUserTypeView" owner:self options:nil].firstObject;
        
        _selectUserTypeView.layer.cornerRadius = 10.f;
        _selectUserTypeView.clipsToBounds = YES;
        _selectUserTypeView.frame=CGRectMake(100, 150, SCREEN_WIDTH - 40 - 100, 0);
        
        _selectUserTypeView.dataSoure  = @[@"每日限额",@"每单限额"];
        
    }
    
    return _selectUserTypeView;
    
}
@end
