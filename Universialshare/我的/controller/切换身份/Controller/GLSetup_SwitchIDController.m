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
#import <SDWebImage/UIImageView+WebCache.h>

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

@end

@implementation GLSetup_SwitchIDController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"帐号切换";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLSetup_SwitchIDCell" bundle:nil] forCellReuseIdentifier:@"GLSetup_SwitchIDCell"];
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
    return self.nameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLSetup_SwitchIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLSetup_SwitchIDCell"];
    
    [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:self.headPicArr[indexPath.row]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    cell.nameLabel.text = self.nameArr[indexPath.row];
    cell.phoneLabel.text = self.phoneArr[indexPath.row];
 
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

    NSLog(@"重新登录了");
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.pwdArr[indexPath.row] publicKey:public_RSA];
    NSLog(@"%@",@{@"userphone":self.nameArr[indexPath.row],@"password":encryptsecret,@"groupID":self.groupIDArr[indexPath.row]});
    
    [NetworkManager requestPOSTWithURLStr:@"user/login" paramDic:@{@"userphone":self.phoneArr[indexPath.row],@"password":encryptsecret,@"groupID":self.groupIDArr[indexPath.row]} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
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
            
            if ([self.groupIDArr[indexPath.row] isEqualToString:Retailer]) {//零售商
                [UserModel defaultUser].shop_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
                [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
                [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
                [UserModel defaultUser].is_main = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_main"]];
                
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
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

    
}

#pragma 懒加载

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
