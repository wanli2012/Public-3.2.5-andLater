//
//  LBMineViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineViewController.h"
#import "MineCollectionHeaderV.h"
#import "LBMineCenterCollectionViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBSetUpViewController.h"
#import "GLMine_InfoController.h"
#import "LBSaleManPersonInfoViewController.h"
#import "LBBaiduMapViewController.h"
#import "GLShoppingCartController.h"
#import "GLAdModel.h"//广告数据模型
#import "GLMine_AdController.h"
#import "LBImprovePersonalDataViewController.h"//完善资料  实名认证
#import "LBStoreMoreInfomationViewController.h"//逛逛 商家详情
#import "LBStoreProductDetailInfoViewController.h"//逛逛  逛逛商品详情
#import "GLHourseDetailController.h"//米劵商品
#import "LBMineSystemMessageViewController.h"
#import "LBUnreadMessagePromptView.h"
#import "LBMinCenterCollectionReusableView.h"
#import "LBPayTheBillViewController.h"
#import "GLMine_CompleteInfoView.h"
#import "LBMineCenterCheckMoreInfoViewController.h"
#import "LBmineCenterGameChargeViewController.h"

static CGFloat headViewH = 0;

@interface LBMineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UITextFieldDelegate,MineCollectionHeaderVDelegete>{
    UIImageView *_imageviewLeft;
}
@property(nonatomic,strong)UICollectionView *collectionV;
@property(nonatomic,strong) LBUnreadMessagePromptView *unreadMessagePromptView;
@property(nonatomic,strong)NSMutableArray *titlearr;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSArray *categoryArr;
@property(nonatomic,strong)NSMutableArray *imageurls;//广告图片
@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *ordertype;//订单类型 默认为线上类型 1 为线上 2线下

@property (strong, nonatomic)NSMutableArray *CarouselArr;//轮播图图片

@property (nonatomic, strong)UIView *maskV;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger unreadnum;// 未读消息

@property (nonatomic, strong)NSMutableArray *adModels;
@property (weak, nonatomic) IBOutlet UIView *navaView;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (nonatomic, strong)NSDictionary *msgDic;//未读消息 条数(7种消息)

@property (nonatomic, strong)NSMutableArray *userVcArr;//会员控制器数组

@property (nonatomic, strong)GLMine_CompleteInfoView *infoContentV;

@end

@implementation LBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    headViewH = 308 + 80 * autoSizeScaleX;
    
    // 注册表头
    [self.collectionV registerClass:[MineCollectionHeaderV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MineCollectionHeaderV"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"LBMinCenterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LBMinCenterCollectionReusableView"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"LBMineCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBMineCenterCollectionViewCell"];
    
    [self.view insertSubview:self.collectionV atIndex:0];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMineCollection) name:@"refreshMine" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refrehFriendMessage:) name:@"refrehFriendMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    _ordertype = @"1";
    
    [self.view addSubview:self.unreadMessagePromptView];
    self.unreadMessagePromptView.hidden = YES;
    
     [self refreshViewController];
    
}


-(void)refreshMineCollection{
    
    [self.collectionV reloadData];

}

-(void)refrehFriendMessage:(NSNotification*)noti{

   [self.collectionV reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:3], nil]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     self.navigationController.navigationBar.hidden = YES;
    [self refreshDataSource];
    
    if (self.adModels.count<=0) {
        [self getdatasorce];
    }
    
}

-(void)pushToInfoVC{
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        self.hidesBottomBarWhenPushed=YES;
        GLMine_InfoController *infoVC = [[GLMine_InfoController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
        self.hidesBottomBarWhenPushed=YES;
        LBSaleManPersonInfoViewController *infoVC = [[LBSaleManPersonInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.categoryArr.count + 1;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return [self.titlearr[section-1] count];
    }
    
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH,headViewH);
    }else {
        return CGSizeMake(SCREEN_WIDTH,40);
    }
    return CGSizeMake(0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBMineCenterCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.imagev.image = [UIImage imageNamed:self.imageArr[indexPath.section-1][indexPath.row]];
    cell.titile.text = self.titlearr[indexPath.section-1][indexPath.row];
    
    if ([self.titlearr[indexPath.section-1][indexPath.row] isEqualToString:@"好友"] ) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"num"] != nil && [[[NSUserDefaults standardUserDefaults]objectForKey:@"num"] integerValue] > 0) {
            cell.message.hidden = NO;
            cell.message.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"num"]];
        }else{
           cell.message.hidden = YES;
        }
    }else{
        cell.message.hidden = YES;
    }
    
    return cell;
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH)/4, 80);

}

//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSString *vcstr = self.userVcArr[indexPath.section - 1][indexPath.row];
    if ([vcstr isEqualToString:@"GLFriendController"]) {
        if ([[UserModel defaultUser].is_yx integerValue] != 1) {
            [MBProgressHUD showError:@"此功能维护中"];
            return;
        }
    }
    //游戏充值
    if ([vcstr isEqualToString:@"LBmineCenterGameChargeViewController"]) {
        if ([UserModel defaultUser].game_recharge_model == nil || [[UserModel defaultUser].game_recharge_model integerValue] != 1) {
            [MBProgressHUD showError:@"此功能暂未开放"];
            return;
        }
    }
    //米宝
    if ([vcstr isEqualToString:@"LBMineCenterMeeToViewController"]) {
        if ([UserModel defaultUser].meeple_model == nil || [[UserModel defaultUser].meeple_model integerValue] != 1) {
            [MBProgressHUD showError:@"此功能暂未开放"];
            return;
        }
    }
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
        if ([vcstr isEqualToString:@"GLBuyBackController"] || [vcstr isEqualToString:@"GLDonationController"] || [vcstr isEqualToString:@"LBRedPaketController"] || [vcstr isEqualToString:@"LBBelowTheLineViewController"] || [vcstr isEqualToString:@"LBRechargeableRiceViewController"]) {
            if ([[UserModel defaultUser].rzstatus isEqualToString:@"2"]) {
                
            }else if ([[UserModel defaultUser].rzstatus isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"审核中"];
                return;
            }else{
                [self.view addSubview:self.maskV];
                [self.maskV addSubview:self.infoContentV];
                self.infoContentV.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
                [UIView animateWithDuration:0.2 animations:^{
                    self.infoContentV.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
                }];
                
                return;
   
            }
            
        }
    }else{
        if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
            if ([vcstr isEqualToString:@"LBRecommendedSalesmanViewController"]) {
                [MBProgressHUD showError:@"权限不足"];
                return;
            }
        }
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            
            if ([vcstr isEqualToString:@"GLBuyBackController"] || [vcstr isEqualToString:@"LBRedPaketController"] || [vcstr isEqualToString:@"GLMerchat_StoreController"] ) {
                if ([UserModel defaultUser].is_main != nil ) {
                    if ([[UserModel defaultUser].is_main integerValue] == 1) {
                        [MBProgressHUD showError:@"权限不足"];
                        return;
                    }
                }
            }
        }
        if ([vcstr isEqualToString:@"GLBuyBackController"] || [vcstr isEqualToString:@"GLDonationController"] || [vcstr isEqualToString:@"LBRedPaketController"] || [vcstr isEqualToString:@"LBBelowTheLineViewController"] || [vcstr isEqualToString:@"LBProductManagementViewController"] || [vcstr isEqualToString:@"GLMerchat_StoreController"] || [vcstr isEqualToString:@"LBBillOfLadingViewController"] || [vcstr isEqualToString:@"LBMerchantSubmissionFourViewController"] || [vcstr isEqualToString:@"LBRecommendedSalesmanViewController"] || [vcstr isEqualToString:@"LBRechargeableRiceViewController"]) {
            if ([[UserModel defaultUser].rzstatus isEqualToString:@"2"]) {
                
            }else if ([[UserModel defaultUser].rzstatus isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"审核中"];
                return;
            }else{
                self.hidesBottomBarWhenPushed=YES;
                LBImprovePersonalDataViewController *vc=[[LBImprovePersonalDataViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                return;
            }
            
        }
    
    }

    self.hidesBottomBarWhenPushed=YES;
    Class classvc = NSClassFromString(vcstr);
    UIViewController *vc = [[classvc alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *collectionReusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            MineCollectionHeaderV  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:@"MineCollectionHeaderV"
                                                                                         forIndexPath:indexPath];
            [headview refreshDataInfo];
            headview.cycleScrollView.delegate = self;
            headview.delegete = self;
            if (self.imageurls.count > 0) {
                if (self.imageurls.count > 1) {
                    headview.cycleScrollView.autoScroll = YES;
                }
                headview.cycleScrollView.imageURLStringsGroup = self.imageurls;
            }
            collectionReusableView = headview;
        }else{
            
            LBMinCenterCollectionReusableView  *headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                              withReuseIdentifier:@"LBMinCenterCollectionReusableView"
                                                                                                     forIndexPath:indexPath];
            headview.titileLb.text = self.categoryArr[indexPath.section - 1];
            
            collectionReusableView = headview;
        }
    }
    return collectionReusableView;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
#pragma mark ---- button
//设置
- (IBAction)setupevent:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBSetUpViewController *vc=[[LBSetUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
   
   
}

//消息
- (IBAction)messagebutton:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBMineSystemMessageViewController *vc=[[LBMineSystemMessageViewController alloc]init];
    vc.msgDic = self.msgDic;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

#pragma mark ------ MineCollectionHeaderVDelegete
//点击头像
-(void)tapgestureHeadimage{
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        self.hidesBottomBarWhenPushed=YES;
        GLMine_InfoController *infoVC = [[GLMine_InfoController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
        self.hidesBottomBarWhenPushed=YES;
        LBSaleManPersonInfoViewController *infoVC = [[LBSaleManPersonInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}
//查看更多
-(void)tapgesturecheckMoreinfo{
    self.hidesBottomBarWhenPushed=YES;
    LBMineCenterCheckMoreInfoViewController *VC = [[LBMineCenterCheckMoreInfoViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    

}
//刷新控制器
-(void)refreshViewController{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.titlearr[1]];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:self.imageArr[1]];
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:self.userVcArr[1]];
    
    //游戏充值
    if ([UserModel defaultUser].game_recharge_model != nil && [[UserModel defaultUser].game_recharge_model integerValue] == 1) {
        if (![arr containsObject:@"游戏充值"]) {
            [arr addObject:@"游戏充值"];
            [arr1 addObject:@"gamerecharge"];
            [arr2 addObject:@"LBmineCenterGameChargeViewController"];
            
            [self.titlearr replaceObjectAtIndex:1 withObject:arr];
            [self.imageArr replaceObjectAtIndex:1 withObject:arr1];
            [self.userVcArr replaceObjectAtIndex:1 withObject:arr2];
        }
    }else{
        if ([arr containsObject:@"游戏充值"]) {
            [arr removeObject:@"游戏充值"];
            [arr1 removeObject:@"gamerecharge"];
            [arr2 removeObject:@"LBmineCenterGameChargeViewController"];
        }
        [self.titlearr replaceObjectAtIndex:1 withObject:arr];
        [self.imageArr replaceObjectAtIndex:1 withObject:arr1];
        [self.userVcArr replaceObjectAtIndex:1 withObject:arr2];
        
    }
    
    //米宝
    if ([UserModel defaultUser].meeple_model != nil && [[UserModel defaultUser].meeple_model integerValue] == 1) {
        if (![arr containsObject:@"米宝"]) {
            [arr addObject:@"米宝"];
            [arr1 addObject:@"米宝图标"];
            [arr2 addObject:@"LBMineCenterMeeToViewController"];
            
            [self.titlearr replaceObjectAtIndex:1 withObject:arr];
            [self.imageArr replaceObjectAtIndex:1 withObject:arr1];
            [self.userVcArr replaceObjectAtIndex:1 withObject:arr2];
        }
    
    }else{
        if ([arr containsObject:@"米宝"]) {
            [arr removeObject:@"米宝"];
            [arr1 removeObject:@"米宝图标"];
            [arr2 removeObject:@"LBMineCenterMeeToViewController"];
        }
        [self.titlearr replaceObjectAtIndex:1 withObject:arr];
        [self.imageArr replaceObjectAtIndex:1 withObject:arr1];
        [self.userVcArr replaceObjectAtIndex:1 withObject:arr2];
        
    }
    
    [self.collectionV reloadData];
    
}

#pragma mark 懒加载

-(UICollectionView *)collectionV{

    if (!_collectionV) {
        
         UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
         //[flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 10, 0)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:0.0];
        [flowLayout setMinimumLineSpacing:0.0];
        
        _collectionV =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50)collectionViewLayout:flowLayout];
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.alwaysBounceVertical = YES;
        _collectionV.showsVerticalScrollIndicator = NO;
        //设置代理
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
    }
    return _collectionV;
}

//点击maskview
-(void)maskviewgesture{
    
   
}
#pragma mark - scrolleViewDelegete

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y <= 0) {

        self.navaView.backgroundColor = YYSRGBColor(255, 155, 33, 0);
        scrollView.contentOffset =  CGPointMake(0, 0);
        
    }else{

        self.navaView.backgroundColor = YYSRGBColor(255, 155, 33, (scrollView.contentOffset.y)/64);
    
    }
}

#pragma mark --- 完善信息
- (void)maskViewTap {
    [self.view endEditing:YES];
}
-(void)cancelMaskEvent{
    [self.infoContentV removeFromSuperview];
    [self.maskV removeFromSuperview];
}
//会员不全信息
- (void)addQtIDandOilCardID{
    
    if (self.infoContentV.qtIDTextF.text.length == 0) {
        [MBProgressHUD showError:@"请输入身份证号"];
        return;
    }
    if (self.infoContentV.oilCardTextF.text.length == 0) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    
    if(![predicateModel validateIdentityCard:self.infoContentV.qtIDTextF.text]){
        [MBProgressHUD showError:@"输入的身份证不合法"];
        return;
    }
    
    if (self.infoContentV.paySecretTf.text.length == 0) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
    if (self.infoContentV.paySecretTf.text.length != 6) {
        [MBProgressHUD showError:@"请输入6位交易密码"];
        return;
    }
    
    if (self.infoContentV.ensureSecretTf.text.length == 0) {
        [MBProgressHUD showError:@"请确认交易密码"];
        return;
    }
    
    if (![self.infoContentV.ensureSecretTf.text isEqualToString:self.infoContentV.paySecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.infoContentV.ensureSecretTf.text publicKey:public_RSA];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"truename"] = self.infoContentV.oilCardTextF.text;
    dict[@"idcard"] = self.infoContentV.qtIDTextF.text;
    dict[@"twopwd"] = encryptsecret;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/bqUserInfo" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {

            [UserModel defaultUser].rzstatus = @"1";
            [usermodelachivar achive];
            
        }
        [self maskViewTap];
        [self.infoContentV removeFromSuperview];
        [self.maskV removeFromSuperview];
        
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        
    }
    return _maskView;
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//刷新数据
-(void)refreshDataSource{

    [NetworkManager requestPOSTWithURLStr:@"User/refresh" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1) {
            
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].loveNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"loveNum"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"taxes"]];
            [UserModel defaultUser].giveMeMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"give_me_bean"]];
            [UserModel defaultUser].lastFanLiTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lasttime"]];
            [UserModel defaultUser].recommendMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjtc"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
            [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].headPic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pic"]];
            [UserModel defaultUser].AudiThrough = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]];
            [UserModel defaultUser].t_one = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_one"]];
            [UserModel defaultUser].t_two = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_two"]];
            [UserModel defaultUser].t_three = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_three"]];
            [UserModel defaultUser].meeple = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"meeple"]];
            [UserModel defaultUser].allLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allLimit"]];
            [UserModel defaultUser].isapplication = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isapplication"]];
            [UserModel defaultUser].surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
            [UserModel defaultUser].shop_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_phone"]];
            
            [UserModel defaultUser].back = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"back"]];
            
            [UserModel defaultUser].bonus_log = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"bonus_log"]];
            [UserModel defaultUser].log = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"log"]];
            [UserModel defaultUser].order_line = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"order_line"]];
            [UserModel defaultUser].system_message = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"system_message"]];
            [UserModel defaultUser].give = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"give"]];
            [UserModel defaultUser].logtd = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"logtd"]];
            [UserModel defaultUser].pushLog = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"pushLog"]];
        
            [UserModel defaultUser].pre_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pre_phone"]];
            [UserModel defaultUser].single = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"single"]];
            
            [UserModel defaultUser].rzstatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rzstatus"]];
            
            [UserModel defaultUser].activation_mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"activation_mark"]];
            [UserModel defaultUser].frozen_mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"frozen_mark"]];
            [UserModel defaultUser].line_money = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"line_money"]];
            
            [UserModel defaultUser].meeple_model = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"meeple_model"]];
            [UserModel defaultUser].game_recharge_model = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"game_recharge_model"]];

            
            if ([[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].idcard = @"";
            }
            if ([[UserModel defaultUser].shop_type rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_type = @"";
            }
            if ([[UserModel defaultUser].shop_address rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_address = @"";
            }
            if ([[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].truename = @"";
            }
            if ([[UserModel defaultUser].single rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].single = @"0.00";
            }
            self.msgDic = responseObject[@"data"][@"msg_no"];
            [usermodelachivar achive];
            
            if ([[UserModel defaultUser].back integerValue] == 0 && [[UserModel defaultUser].bonus_log integerValue] == 0 && [[UserModel defaultUser].log integerValue] == 0 && [[UserModel defaultUser].order_line integerValue] == 0 && [[UserModel defaultUser].system_message integerValue] == 0 && [[UserModel defaultUser].give integerValue] == 0 && [[UserModel defaultUser].logtd integerValue] == 0 && [[UserModel defaultUser].pushLog integerValue] == 0) {
                self.signImageV.hidden = YES;
                
            }else{
                self.signImageV.hidden = NO;
                self.unreadMessagePromptView.hidden = NO;
                [UIView animateWithDuration:1 animations:^{
                    self.unreadMessagePromptView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
                } completion:^(BOOL finished) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:1 animations:^{
                            self.unreadMessagePromptView.frame = CGRectMake(0, -50, SCREEN_WIDTH, 50);
                        } completion:^(BOOL finished) {
                            self.unreadMessagePromptView.hidden = YES;
                        }];
                    });
                }];
            }
            
            [self refreshViewController];
        }
        
    } enError:^(NSError *error) {
      
    }];
}

#pragma mark 点击图片代理
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    if(self.adModels.count == 0){
        return;
    }
    
    GLAdModel *model = self.adModels[index];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([model.type integerValue] == 1) {//内部广告
        if([model.jumptype integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = model.jumpid;
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else{//跳转商品

            if ([model.goodstype integerValue] == 1) {//逛逛商品
                
                LBStoreProductDetailInfoViewController *storeVC = [[LBStoreProductDetailInfoViewController alloc] init];
                storeVC.goodId = model.jumpid;
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else{
                
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id = model.jumpid;
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
            
        }
        
    }else if([model.type integerValue] == 2){//外部广告
        
        GLMine_AdController *adVC = [[GLMine_AdController alloc] init];
        adVC.url = model.url;
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}

//获取广告数据
-(void)getdatasorce{
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/advert" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {

                [self.adModels removeAllObjects];
                
                self.CarouselArr = responseObject[@"data"];
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLAdModel *model = [GLAdModel mj_objectWithKeyValues:dic];
                    [self.adModels addObject:model];
                }
                CGFloat heightIma = 0;
                CGFloat widthIma = 0;
                for ( int i = 0; i < self.adModels.count; i ++) {
                    GLAdModel *model = self.adModels[i];
                    heightIma = [model.height floatValue];
                    widthIma = [model.width floatValue];
                    [self.imageurls addObject:model.thumb];
                }
                
                if (heightIma != 0 && widthIma != 0) {
                    headViewH = 318 + SCREEN_WIDTH *(heightIma/widthIma);
                }

                [self.collectionV reloadData];

            }
            
        }else{
            
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.infoContentV.qtIDTextF && [string isEqualToString:@"\n"]) {
        [self.infoContentV.oilCardTextF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.infoContentV.oilCardTextF && [string isEqualToString:@"\n"]){
        
        [self.infoContentV.paySecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.infoContentV.paySecretTf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
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


-(NSMutableArray*)CarouselArr{

    if (!_CarouselArr) {
        _CarouselArr=[NSMutableArray array];
    }

    return _CarouselArr;
}

- (NSMutableArray *)adModels{
    if (!_adModels) {
        _adModels = [NSMutableArray array];
    }
    return _adModels;
}

- (LBUnreadMessagePromptView *)unreadMessagePromptView{
    if (!_unreadMessagePromptView) {
        _unreadMessagePromptView = [[LBUnreadMessagePromptView alloc]initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 50)];
    }
    return _unreadMessagePromptView;
}
-(NSMutableArray*)titlearr{
    
    if (!_titlearr) {
        if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
            _titlearr=[NSMutableArray arrayWithObjects:@[@"线上订单",@"线下订单",@"支付"],@[@"我的米分",@"我的米柜",@"充值",@"兑换",@"转赠",@"冻结米分",@"红包"],@[@"收益管理"], @[@"好友",@"收藏",@"推荐",@"我要推店",@"公告"],nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
              _titlearr=[NSMutableArray arrayWithObjects:@[@"线上订单",@"线下订单",@"提单",@"支付"],@[@"我的米分",@"我的米柜",@"充值",@"兑换",@"转赠",@"冻结米分",@"红包"],@[@"收益管理",@"门店管理",@"商品管理",@"会员管理",@"商品订单"], @[@"好友",@"收藏",@"推荐",@"公告"],nil];
        }
        else{
              _titlearr=[NSMutableArray arrayWithObjects:@[@"线上订单",@"线下订单",@"支付"],@[@"我的米分",@"我的米柜",@"充值",@"兑换",@"转赠",@"冻结米分",@"红包"],@[@"收益管理",@"开通商家",@"开通创客",@"创客列表"], @[@"好友",@"收藏",@"推荐",@"公告"],nil];
        }
    }
    return _titlearr;
    
}

-(NSMutableArray*)imageArr{
    
    if (!_imageArr) {
        if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
            _imageArr=[NSMutableArray arrayWithObjects:@[@"线上订单",@"线下订单",@"个人中心-扫码"],@[@"我的米分",@"我的米柜",@"recharge",@"兑换",@"互赠",@"冻结米分",@"red-packet"],@[@"收益管理"], @[@"myfriend",@"收藏",@"推荐",@"我要推店",@"gonggao"],nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            _imageArr=[NSMutableArray arrayWithObjects:@[@"线上订单",@"线下订单",@"uploading",@"个人中心-扫码"],@[@"我的米分",@"我的米柜",@"recharge",@"兑换",@"互赠",@"冻结米分",@"red-packet"],@[@"收益管理",@"门店管理",@"商品管理",@"会员管理",@"商品列表"], @[@"myfriend",@"收藏",@"推荐",@"gonggao"],nil];
        }
        else{
            _imageArr=[NSMutableArray arrayWithObjects:@[@"线上订单",@"线下订单",@"个人中心-扫码"],@[@"我的米分",@"我的米柜",@"recharge",@"兑换",@"互赠",@"冻结米分",@"red-packet"],@[@"收益管理",@"开通商家",@"开通创客",@"创客列表"], @[@"myfriend",@"收藏",@"推荐",@"gonggao"],nil];
        }
    }
    return _imageArr;
    
}

-(NSMutableArray*)userVcArr{

    if (!_userVcArr) {
        if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
            _userVcArr=[NSMutableArray arrayWithObjects:@[@"LBMineCenterMyOrderViewController",@"LBMineCenterUsualUnderOrderViewController",@"LBChoosePayTypeViewController"],@[@"GLMyHeartController",@"GLMine_MyBeansController",@"LBRechargeableRiceViewController",@"GLBuyBackController",@"GLDonationController",@"LBFrozenRiceViewController",@"LBRedPaketController"],@[@"GLIncomeManagerController"], @[@"GLFriendController",@"GLMyCollectionController",@"GLRecommendController",@"GLRecommendStoreController",@"LBAnnouncementViewController"],nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            _userVcArr=[NSMutableArray arrayWithObjects:@[@"LBMineCenterMyOrderViewController",@"LBMineCenterUsualUnderOrderViewController",@"LBBillOfLadingViewController",@"LBChoosePayTypeViewController"],@[@"GLMyHeartController",@"GLMine_MyBeansController",@"LBRechargeableRiceViewController",@"GLBuyBackController",@"GLDonationController",@"LBFrozenRiceViewController",@"LBRedPaketController"],@[@"LBHomeIncomeViewController",@"GLMerchat_StoreController",@"LBProductManagementViewController",@"GLMemberManagerController",@"LBStoreSendGoodsListViewController"], @[@"GLFriendController",@"GLMyCollectionController",@"GLRecommendController",@"LBAnnouncementViewController"],nil];
        }
        else{
            _userVcArr=[NSMutableArray arrayWithObjects:@[@"LBMineCenterMyOrderViewController",@"LBMineCenterUsualUnderOrderViewController",@"LBChoosePayTypeViewController"],@[@"GLMyHeartController",@"GLMine_MyBeansController",@"LBRechargeableRiceViewController",@"GLBuyBackController",@"GLDonationController",@"LBFrozenRiceViewController",@"LBRedPaketController"],@[@"LBHomeIncomeViewController",@"LBMerchantSubmissionFourViewController",@"LBRecommendedSalesmanViewController",@"LBShowSaleManAndBusinessViewController"], @[@"GLFriendController",@"GLMyCollectionController",@"GLRecommendController",@"LBAnnouncementViewController"],nil];
        }
    }

    return _userVcArr;
}

-(NSArray*)categoryArr{

    if (!_categoryArr) {
        _categoryArr = [NSArray arrayWithObjects:@"我的订单",@"我的钱包",@"我的管理",@"其他", nil];
    }
    return _categoryArr;

}
-(NSMutableArray*)imageurls{
    
    if (!_imageurls) {
        _imageurls = [NSMutableArray array];
    }
    return _imageurls;
    
}
- (GLMine_CompleteInfoView *)infoContentV{
    if (!_infoContentV) {
        _infoContentV = [[NSBundle mainBundle] loadNibNamed:@"GLMine_CompleteInfoView" owner:nil options:nil].lastObject;
        
        _infoContentV.layer.cornerRadius = 5.f;
        
        _infoContentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 250)/2, SCREEN_WIDTH - 40, 250);
        
        [_infoContentV.cancelBtn addTarget:self action:@selector(cancelMaskEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [_infoContentV.okBtn addTarget:self action:@selector(addQtIDandOilCardID) forControlEvents:UIControlEventTouchUpInside];
        
        _infoContentV.oilCardTextF.delegate = self;
        _infoContentV.qtIDTextF.delegate = self;
        _infoContentV.paySecretTf.delegate = self;
        _infoContentV.ensureSecretTf.delegate = self;
        
    }
    return _infoContentV;
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskV.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *maskViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [_maskV addGestureRecognizer:maskViewTap];
    }
    return _maskV;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
