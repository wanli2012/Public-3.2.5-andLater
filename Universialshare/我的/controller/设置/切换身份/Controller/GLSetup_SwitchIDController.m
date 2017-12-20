//
//  GLSetup_SwitchIDController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLSetup_SwitchIDController.h"
#import "GLSetup_SwitchIDCell.h"
#import "GLAccountModel.h"

#import "GLLoginController.h"
#import "BaseNavigationViewController.h"
#import "NTESLogManager.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "UIView+Toast.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"
#import "BasetabbarViewController.h"


@interface GLSetup_SwitchIDController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *fmdbArr;

@property (nonatomic, strong)NSMutableArray *headPicArr;

@property (nonatomic, strong)NSMutableArray *nameArr;

@property (nonatomic, strong)NSMutableArray *phoneArr;

@property (nonatomic, strong)NSMutableArray *pwdArr;

@property (nonatomic, strong)NSMutableArray *groupIDArr;

@property (nonatomic, strong)GLAccountModel *projiectmodel;

@property (strong, nonatomic)LoadWaitView *loadV;

@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation GLSetup_SwitchIDController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"帐号切换";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLSetup_SwitchIDCell" bundle:nil] forCellReuseIdentifier:@"GLSetup_SwitchIDCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    [self getFmdbDatasoruce];
    
}
-(void)getFmdbDatasoruce{
    
    self.fmdbArr = nil;
    self.headPicArr = nil;
    self.nameArr = nil;
    self.phoneArr = nil;
    
    //获取本地搜索记录
    _projiectmodel = [GLAccountModel greateTableOfFMWithTableName:@"GLAccountModel"];
    
    if ([_projiectmodel isDataInTheTable]) {
        
        self.fmdbArr = [NSMutableArray arrayWithArray:[_projiectmodel queryAllDataOfFMDB]];
        for (int i = 0; i < [[_projiectmodel queryAllDataOfFMDB]count]; i++) {
            [self.headPicArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"headPic"]];
            [self.nameArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"name"]];
            [self.phoneArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"phone"]];
            [self.pwdArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"password"]];
            [self.groupIDArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"groupID"]];
        }
        
    }else{
        
        [self.headPicArr removeAllObjects];
        [self.nameArr removeAllObjects];
        [self.phoneArr removeAllObjects];
        [self.pwdArr removeAllObjects];
        [self.groupIDArr removeAllObjects];
        
        self.fmdbArr = [NSMutableArray array];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.nameArr.count == 0) {
        
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.nameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

    GLSetup_SwitchIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLSetup_SwitchIDCell"];
    
    [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:self.headPicArr[indexPath.row]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",self.nameArr[indexPath.row],shenfen];
    
    cell.phoneLabel.text  = [NSString stringWithFormat:@"%@*****%@",[self.phoneArr[indexPath.row] substringToIndex:3],[self.phoneArr[indexPath.row] substringFromIndex:7]];
    
    if ([self.nameArr[indexPath.row] isEqualToString:[UserModel defaultUser].name]) {
        
        cell.pointOutImageV.hidden = NO;
        
    }else{
        
        cell.pointOutImageV.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.pwdArr[indexPath.row] publicKey:public_RSA];
    
    [NetworkManager requestPOSTWithURLStr:@"User/login" paramDic:@{@"userphone":self.phoneArr[indexPath.row],@"password":encryptsecret,@"groupID":self.groupIDArr[indexPath.row]} finish:^(id responseObject) {
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
            
            [UserModel defaultUser].rzstatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rzstatus"]];
            [UserModel defaultUser].loginstatus = YES;
            [UserModel defaultUser].usrtype = self.groupIDArr[indexPath.row];
            [UserModel defaultUser].AudiThrough = @"0";
            
            [UserModel defaultUser].t_one = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_one"]];
            [UserModel defaultUser].t_two = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_two"]];
            [UserModel defaultUser].t_three = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_three"]];
            [UserModel defaultUser].isSetTwoPwd = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isSetTwoPwd"]];
            [UserModel defaultUser].pre_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pre_phone"]];
            [UserModel defaultUser].congig_ads = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"congig_ads"]];
            [UserModel defaultUser].card_num = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_num"]];
            [UserModel defaultUser].open_bank = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"open_bank"]];
            [UserModel defaultUser].pre_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pre_phone"]];
            [UserModel defaultUser].single = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"single"]];
            
            [UserModel defaultUser].rzstatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rzstatus"]];
            [UserModel defaultUser].isapplication = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isapplication"]];
            [UserModel defaultUser].im_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"im_id"]];
            [UserModel defaultUser].im_token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"im_token"]];
            [UserModel defaultUser].is_yx = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_yx"]];
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
            
            if ([self.groupIDArr[indexPath.row] isEqualToString:Retailer]) {//零售商
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
            
            [usermodelachivar achive];
            
            if ([[UserModel defaultUser].is_yx integerValue]==1) {
                 [self loginChat];
            }else{
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
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
        [SVProgressHUD show];
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


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.nameArr[indexPath.row] isEqualToString:[UserModel defaultUser].name]) {
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        
        [_projiectmodel deleteAllDataOfFMDB:self.nameArr[indexPath.row]];
        
        [self getFmdbDatasoruce];
        [self.tableView reloadData];
        
    }
}
#pragma 懒加载
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    return _nodataV;
    
}

- (NSMutableArray *)phoneArr{
    if (!_phoneArr) {
        _phoneArr = [NSMutableArray array];
    }
    return _phoneArr;
}
- (NSMutableArray *)pwdArr{
    if (!_pwdArr) {
        _pwdArr = [NSMutableArray array];
    }
    return _pwdArr;
}

- (NSMutableArray *)headPicArr{
    if (!_headPicArr) {
        _headPicArr = [NSMutableArray array];
    }
    return _headPicArr;
}

- (NSMutableArray *)fmdbArr{
    if (!_fmdbArr) {
        _fmdbArr = [NSMutableArray array];
    }
    return _fmdbArr;
}

- (NSMutableArray *)nameArr{
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}
- (NSMutableArray *)groupIDArr{
    if (!_groupIDArr) {
        _groupIDArr = [NSMutableArray array];
    }
    return _groupIDArr;
}

@end
