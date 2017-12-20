
//  GLLoginController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/5.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLLoginController.h"
#import "GLRegisterController.h"
#import "BasetabbarViewController.h"
#import "LoginIdentityView.h"
#import "LBHomeLoginFortgetSecretViewController.h"
#import "LBViewProtocolViewController.h"
#import "GLAccountModel.h"
#import "NTESLogManager.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "UIView+Toast.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"

//获取ip 所需的头文件 和 宏

@interface GLLoginController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *scretTf;

@property (strong, nonatomic)LoginIdentityView *loginView;
@property (strong, nonatomic)UIImageView *currentloginViewimage;//当前选择身份的选中图

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *usertype;//用户类型 默认为善行者
@property (strong, nonatomic)LoadWaitView *loadV;


@property (nonatomic, strong)NSMutableArray *fmdbArr;
@property (nonatomic, strong)NSMutableArray *phoneArr;
@property (nonatomic, strong)NSMutableArray *groupIDArr;
@property (nonatomic,strong) GLAccountModel *projiectmodel;//综合项目本地保存

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (nonatomic, assign)BOOL isOpen;//是否展开下拉菜单

@property (nonatomic, strong)NSArray *identifyArr;//身份数组




@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bgView.layer.cornerRadius = 5;
//    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.bgView.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.bgView.layer.shadowRadius = 5;//阴影半径，默认3
    
    [self setPopUI];//设置弹出的选择身份view
    
    if ([UserModel defaultUser].phone != nil && [[UserModel defaultUser].phone length] > 0) {
        self.phone.text = [UserModel defaultUser].phone;
    }

    [self getFmdbDatasoruce];//获取数据库信息
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}
//设置弹出的身份view
- (void)setPopUI {
    
    self.identifyArr = @[@"会员",@"商家",@"创客",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心",@"省级行业服务中心",@"市级行业服务中心"];
    
    self.loginView.dataSoure = self.identifyArr;
    
    __weak typeof(self) weakSelf = self;
    
    self.loginView.block = ^(NSInteger index){
        switch (index) {
            case 0://会员
            {
                weakSelf.usertype = OrdinaryUser;
            }
                break;
            case 1://商家
            {
                weakSelf.usertype = Retailer;
            }
                break;
            case 2://创客
            {
                weakSelf.usertype = THREESALER;
            }
                break;
            case 3://城市创客
            {
                weakSelf.usertype = TWOSALER;
            }
                break;
            case 4://大区创客
            {
                weakSelf.usertype = ONESALER;
            }
                break;
            case 5://省级服务中心
            {
                weakSelf.usertype = PROVINCE;
            }
                break;
            case 6://市级服务中心
            {
                weakSelf.usertype = CITY;
            }
                break;
            case 7:////区级服务中心
            {
                weakSelf.usertype = DISTRICT;
            }
                break;
            case 8:////省级行业服务中心
            {
                weakSelf.usertype = PROVINCE_INDUSTRY;
            }
                break;
            case 9:////市级行业服务中心
            {
                weakSelf.usertype = CITY_INDUSTRY;
            }
                break;
                
            default:
                break;
        }
    };
    
    [self.loginView.cancelBt addTarget:self action:@selector(maskviewgesture) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.sureBt addTarget:self action:@selector(surebuttonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *maskvgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskviewgesture)];
    [self.maskView addGestureRecognizer:maskvgesture];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.usertype = OrdinaryUser;
    
    if (self.phoneArr.count == 0) {
        
        self.dropDownBtn.hidden = YES;
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}
//获取数据库的数据
-(void)getFmdbDatasoruce{
    
    self.fmdbArr = nil;

    self.phoneArr = nil;
    
    //获取本地搜索记录
    _projiectmodel = [GLAccountModel greateTableOfFMWithTableName:@"GLAccountModel"];
    
    if ([_projiectmodel isDataInTheTable]) {
        
        self.fmdbArr = [NSMutableArray arrayWithArray:[_projiectmodel queryAllDataOfFMDB]];
        for (int i = 0; i < [[_projiectmodel queryAllDataOfFMDB]count]; i++) {

            [self.phoneArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"phone"]];
            [self.groupIDArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"groupID"]];
       
        }
    }else{
 
        [self.phoneArr removeAllObjects];
        [self.groupIDArr removeAllObjects];

        self.fmdbArr = [NSMutableArray array];
    }
    
}

//以往登录过的账号选择
- (IBAction)dropDown:(UIButton *)sender {
    
    self.isOpen = !self.isOpen;
    
    self.tableView.layer.cornerRadius = 5.f;
    
    if (self.isOpen) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (self.phoneArr.count * 30 < 200) {
                
                self.tableView.height = self.phoneArr.count * 30;
            }else{
                
                self.tableView.height = 200;
            }
        }];
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            
            self.tableView.height = 0;
            
        }];
    }

}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.phoneArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    NSString *shenfen;
    
    if ([self.groupIDArr[indexPath.row] isEqualToString:OrdinaryUser]) {
        shenfen = @"会员";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:Retailer]){
         shenfen = @"商家";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:ONESALER]){
        shenfen = @"大区创客";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:TWOSALER]){
        shenfen = @"城市创客";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:THREESALER]){
        shenfen = @"创客";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:PROVINCE]){
        shenfen = @"省级服务中心";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:CITY]){
        shenfen = @"市级服务中心";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:DISTRICT]){
         shenfen = @"区级服务中心";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:PROVINCE_INDUSTRY]){
        shenfen = @"省级行业服务中心";
    }else if ([self.groupIDArr[indexPath.row] isEqualToString:CITY_INDUSTRY]){
         shenfen = @"市级行业服务中心";
    }
    

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",self.phoneArr[indexPath.row],shenfen];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13 * autoSizeScaleX];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30 * autoSizeScaleX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.phone.text = self.phoneArr[indexPath.row];
    self.isOpen = NO;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.height = 0;
        
    }];
}
//注册
- (IBAction)registerClick:(id)sender {
    [self.view endEditing:YES];
    GLRegisterController *registerVC = [[GLRegisterController alloc] init];
//    registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:registerVC animated:YES completion:nil];
    registerVC.registerSucess = ^(NSString *name, NSString *secret) {
        self.phone.text = name;
        self.scretTf.text = secret;
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}

//登录
- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];
    if (self.phone.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码或ID"];
        return;
    }
    
    if (self.scretTf.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (self.scretTf.text.length < 6 || self.scretTf.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.loginView];
    
    self.loginView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loginView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
}
//隐藏或显示图片
- (IBAction)showOrHide:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.scretTf setSecureTextEntry:NO];
        [sender setImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateNormal];
        
    }else{
        [self.scretTf setSecureTextEntry:YES];
        [sender setImage:[UIImage imageNamed:@"显示"] forState:UIControlStateNormal];
    }
}
//退出
- (IBAction)exitLoginEvent:(UIButton *)sender {
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"pushToHome" object:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//忘记密码
- (IBAction)forgetButtonEvent:(UIButton *)sender {

    LBHomeLoginFortgetSecretViewController *vc=[[LBHomeLoginFortgetSecretViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

//使用说明
- (IBAction)useInfoamtion:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = COMMONPROBLE;
    vc.navTitle = @"常见问题";
    [self.navigationController pushViewController:vc animated:YES];
    
}

//确定按
-(void)surebuttonEvent{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
 
     NSString *encryptsecret = [RSAEncryptor encryptString:self.scretTf.text publicKey:public_RSA];

    [NetworkManager requestPOSTWithURLStr:@"User/login" paramDic:@{@"userphone":self.phone.text,@"password":encryptsecret,@"groupID":self.usertype} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==1) {
            [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:@"num"];//清空未读消息
            [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            [UserModel defaultUser].counta = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"count"]];
            [UserModel defaultUser].giveMeMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"giveMeMark"]];
            [UserModel defaultUser].groupId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupId"]];
            [UserModel defaultUser].headPic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"headPic"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ketiBean"]];
            [UserModel defaultUser].lastFanLiTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lastFanLiTime"]];
            [UserModel defaultUser].lastTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lastTime"]];
            [UserModel defaultUser].loveNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"loveNum"]];
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"name"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].recommendMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recommendMark"]];
            [UserModel defaultUser].regTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"regTime"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
            [UserModel defaultUser].version = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"version"]];
            [UserModel defaultUser].vsnAddress = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"vsnAddress"]];
            [UserModel defaultUser].vsnUpdateTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"vsnUpdateTime"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"djs_bean"]];
        
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].tjr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjr"]];
            [UserModel defaultUser].tjrname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjrname"]];
            [UserModel defaultUser].line_money = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"line_money"]];
            [UserModel defaultUser].rzstatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rzstatus"]];
            [UserModel defaultUser].loginstatus = YES;
            [UserModel defaultUser].usrtype = self.usertype;
            [UserModel defaultUser].AudiThrough = @"0";
            
            [UserModel defaultUser].t_one = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_one"]];
            [UserModel defaultUser].t_two = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_two"]];
            [UserModel defaultUser].t_three = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_three"]];
            [UserModel defaultUser].isSetTwoPwd = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isSetTwoPwd"]];
            [UserModel defaultUser].pre_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pre_phone"]];
            [UserModel defaultUser].congig_ads = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"congig_ads"]];
            [UserModel defaultUser].card_num = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_num"]];
            [UserModel defaultUser].open_bank = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"open_bank"]];
             [UserModel defaultUser].im_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"im_id"]];
             [UserModel defaultUser].im_token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"im_token"]];
             [UserModel defaultUser].is_yx = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_yx"]];
            
            [UserModel defaultUser].activation_mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"activation_mark"]];
            [UserModel defaultUser].frozen_mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"frozen_mark"]];
            [UserModel defaultUser].is_main = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_main"]];
            [UserModel defaultUser].main_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"main_id"]];
            
            if ([[UserModel defaultUser].banknumber rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].banknumber = @"";
            }
            if ([[UserModel defaultUser].counta rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].counta = @"";
            }
            if ([[UserModel defaultUser].giveMeMark rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].giveMeMark = @"";
            }
            if ([[UserModel defaultUser].tjr rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].tjr = @"";
            }
            if ([[UserModel defaultUser].tjrname rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].tjrname = @"";
            }
            
            if ([[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].truename = @"";
            }
            
            if ([[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].idcard = @"";
            }
            if ([[UserModel defaultUser].isSetTwoPwd rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].isSetTwoPwd = @"";
            }
            if ([[UserModel defaultUser].isSetTwoPwd rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].isSetTwoPwd = @"";
            }
            if ([[UserModel defaultUser].pre_phone rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].pre_phone = @"";
            }
            if ([[UserModel defaultUser].congig_ads rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].congig_ads = @"";
            }
            if ([[UserModel defaultUser].card_num rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].card_num = @"";
            }
            if ([[UserModel defaultUser].open_bank rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].open_bank = @"";
            }
          
            
            if ([self.usertype isEqualToString:Retailer]) {//零售商
                [UserModel defaultUser].shop_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
                [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
                [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
                
                [UserModel defaultUser].allLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allLimit"]];
                [UserModel defaultUser].isapplication = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isapplication"]];
                [UserModel defaultUser].surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
                [UserModel defaultUser].shop_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_phone"]];
                
                if ([[UserModel defaultUser].shop_name rangeOfString:@"null"].location != NSNotFound) {
                    
                    [UserModel defaultUser].shop_name = @"";
                }
                if ([[UserModel defaultUser].shop_address rangeOfString:@"null"].location != NSNotFound) {
                    
                    [UserModel defaultUser].shop_address = @"";
                }
                if ([[UserModel defaultUser].shop_type rangeOfString:@"null"].location != NSNotFound) {
                    
                    [UserModel defaultUser].shop_type = @"";
                }
                
            }else{//普通用户
                [UserModel defaultUser].shop_name = @"";
                [UserModel defaultUser].shop_address = @"";
                [UserModel defaultUser].shop_type = @"";
                [UserModel defaultUser].is_main = @"";

            }
            
            if ([UserModel defaultUser].headPic.length == 0) {
                
                [UserModel defaultUser].headPic = PlaceHolderImage;
                
            }
            
            [usermodelachivar achive];
            
            BOOL isSava = YES;//是否保存
            for (int i = 0; i < self.fmdbArr.count; i++) {
                
                if ([self.fmdbArr[i][@"name"] isEqualToString:[UserModel defaultUser].name] && [self.fmdbArr[i][@"password"] isEqualToString:self.scretTf.text]) {
                    
                    isSava = NO;
                    
                }else if([self.fmdbArr[i][@"name"] isEqualToString:[UserModel defaultUser].name] && ![self.fmdbArr[i][@"password"] isEqualToString:self.scretTf.text]){
                    
                    [_projiectmodel deleteAllDataOfFMDB:[UserModel defaultUser].name];
                    
                }
                
            }
            
            [self getFmdbDatasoruce];
            
            if (isSava == YES) {//保存记录
                [_projiectmodel deleteAllDataOfFMDB];
                _projiectmodel = [GLAccountModel greateTableOfFMWithTableName:@"GLAccountModel"];
                [self.fmdbArr insertObject:@{@"headPic":[UserModel defaultUser].headPic,@"name":[UserModel defaultUser].name,@"phone":self.phone.text,@"password":self.scretTf.text,@"groupID":self.usertype} atIndex:0];
                
                if (self.fmdbArr.count > 15) {
                    [self.fmdbArr  removeObjectsInRange:NSMakeRange(10, self.fmdbArr.count)];
                }
                [_projiectmodel insertOfFMWithDataArray:self.fmdbArr];
            }
            
            if ([[UserModel defaultUser].is_yx integerValue] == 1) {
                 [self loginChat];
            }else{
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }

        }else{
             [_loadV removeloadview];
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

-(void)loginChat{

    //NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
    //用户APP的帐号体系和 NIM SDK 并没有直接关系
    //DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
    //开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
    
    [self uploadImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserModel defaultUser].headPic]]]];
    
    [[[NIMSDK sharedSDK] loginManager] login:[UserModel defaultUser].im_id
                                       token:[UserModel defaultUser].im_token
                                  completion:^(NSError *error) {
                                       [_loadV removeloadview];
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = [UserModel defaultUser].im_id;
                                          sdkData.token     = [UserModel defaultUser].im_token;
                                          [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                          
                                          BasetabbarViewController * mainTab = [[BasetabbarViewController alloc] initWithNibName:nil bundle:nil];
                                          [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                          [UIApplication sharedApplication].keyWindow.rootViewController  = mainTab;
                                
                                      }
                                      else
                                      {
       
                                          NSString *toast = [NSString stringWithFormat:@"登录失败"];
                                          [[UIApplication sharedApplication].keyWindow makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                      }
                                  }];
}

#pragma mark - Private
- (void)uploadImage:(UIImage *)image{
    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 0.2);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    __weak typeof(self) wself = self;
    if (success) {
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error && wself) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    if (!error) {
                        [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                    }else{
//                        [wself.view makeToast:@"设置头像失败，请重试"
//                                     duration:2
//                                     position:CSToastPositionCenter];
                    }
                }];
            }else{
//                [wself.view makeToast:@"图片上传失败，请重试"
//                             duration:2
//                             position:CSToastPositionCenter];
            }
        }];
    }else{
//        [self.view makeToast:@"图片保存失败，请重试"
//                    duration:2
//                    position:CSToastPositionCenter];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phone && [string isEqualToString:@"\n"]) {
        [self.scretTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.scretTf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.phone ) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    
}

//点击maskview
-(void)maskviewgesture{
    
    [self.maskView removeFromSuperview];
    [self.loginView removeFromSuperview];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.clipsToBounds = YES;
    self.registerBtn.layer.cornerRadius = 4;
    self.registerBtn.clipsToBounds = YES;
    
    self.loginView.sureBt.layer.cornerRadius = 4;
    self.loginView.sureBt.clipsToBounds = YES;
    self.loginView.cancelBt.layer.cornerRadius = 4;
    self.loginView.cancelBt.clipsToBounds = YES;

}

-(LoginIdentityView*)loginView{
    
    if (!_loginView) {
        _loginView=[[NSBundle mainBundle]loadNibNamed:@"LoginIdentityView" owner:self options:nil].firstObject;
        _loginView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH-40, 300);
        _loginView.alpha=1;

    }
    
    return _loginView;
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
        
    }
    return _maskView;
    
}
- (NSMutableArray *)fmdbArr{
    if (!_fmdbArr) {
        _fmdbArr = [NSMutableArray array];
    }
    return _fmdbArr;
}
- (NSMutableArray *)phoneArr{
    if (!_phoneArr) {
        _phoneArr = [NSMutableArray array];
    }
    return _phoneArr;
}
- (NSMutableArray *)groupIDArr{
    if (!_groupIDArr) {
        _groupIDArr = [NSMutableArray array];
    }
    return _groupIDArr;
}

@end
