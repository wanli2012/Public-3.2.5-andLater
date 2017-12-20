//
//  LBStoreMoreInfomationViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreMoreInfomationViewController.h"
#import "MXNavigationBarManager.h"
#import "SDCycleScrollView.h"
#import "LBStoreDetailHeaderView.h"
#import "LBStoreDetailNameTableViewCell.h"
#import "LBStoreDetailAdressTableViewCell.h"
#import "LBStoreDetailHotProductTableViewCell.h"
#import "LBStoreDetailreplaysTableViewCell.h"
#import "LBStoreDetailRecomendTableViewCell.h"
#import "LBStoreProductDetailInfoViewController.h"

#import <MapKit/MapKit.h>
#import "LBPayTheBillViewController.h"
#import "UMSocial.h"
#import <Social/Social.h>
#import "GLShareView.h"
#import "GLSet_MaskVeiw.h"
#import "LBCheckMoreHotProductViewController.h"
#import "JZAlbumViewController.h"

//地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "NTESSessionViewController.h"

static const CGFloat headerImageHeight = 180.0f;

@interface LBStoreMoreInfomationViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,LBStoreDetailAdressDelegete,LBStoreDetailNameDelegete,LBStoreDetailHeaderViewDelegete>
{
    GLShareView *_shareV;
    GLSet_MaskVeiw *_maskV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)UIButton *shareButton;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSDictionary *dataDic;
@property (strong, nonatomic)NSArray *lovedataArr;//数组
@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏
@property(assign , nonatomic)CGPoint offset;//记录偏移
@property (nonatomic, strong)UIView *maskView;
@property (nonatomic, assign)BOOL  isREfresh;//是否需要刷新数据
@property (strong, nonatomic)UIButton *buttonedt;

@end

@implementation LBStoreMoreInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    adjustsScrollViewInsets_NO(self.tableview,self);
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailNameTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailAdressTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailHotProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailHotProductTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailreplaysTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailreplaysTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailRecomendTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailRecomendTableViewCell"];

    self.tableview.tableHeaderView = self.cycleScrollView;
   
    [self initdatasource];//请求数
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 30)];
    [_buttonedt setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
    [_buttonedt setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 3, -10)];
    [_buttonedt addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    

}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initdatasource{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/goToShop" paramDic:@{@"shop_id":self.storeId,@"lat":[NSNumber numberWithFloat:self.lat],@"lng":[NSNumber numberWithFloat:self.lng]} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.dataDic = responseObject[@"data"];
                self.lovedataArr = self.dataDic[@"love_data"];
                NSMutableArray *imagearr=[NSMutableArray array];
                
                if (![self.dataDic[@"shop_data"][@"pic1"] isEqual:[NSNull null]]) {
                    [imagearr addObject:self.dataDic[@"shop_data"][@"pic1"]];
                }
                if (![self.dataDic[@"shop_data"][@"pic2"] isEqual:[NSNull null]]) {
                    [imagearr addObject:self.dataDic[@"shop_data"][@"pic2"]];
                }
                if (![self.dataDic[@"shop_data"][@"pic3"] isEqual:[NSNull null]]) {
                    [imagearr addObject:self.dataDic[@"shop_data"][@"pic3"]];
                }
                
                self.cycleScrollView.imageURLStringsGroup = imagearr;
                self.cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
                self.cycleScrollView.clipsToBounds = YES;
                 self.navigationItem.title = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"shop_name"]];
                
                [self.tableview reloadData];
            }

        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
   
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataDic.count > 0) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return [self.dataDic[@"goods_data"]count];
    }else if (section == 2){
        return [self.dataDic[@"com_data"]count];
    }else if (section == 3){
        return self.lovedataArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 65;
        }else{
            self.tableview.estimatedRowHeight = 95;
            self.tableview.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }
        
    }else if (indexPath.section == 1){
        return 90;
        
    }else if (indexPath.section == 2){
        self.tableview.estimatedRowHeight = 80;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.section == 3){
        return 80;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            LBStoreDetailNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailNameTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.scoreLb.text = [NSString stringWithFormat:@"%@分",self.dataDic[@"shop_data"][@"pj_mark"]];
            cell.starView.progress = [self.dataDic[@"shop_data"][@"pj_mark"] integerValue];
            cell.storeNameLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"shop_name"]];
            cell.delegete=self;
            
            return cell;
        }else{
            LBStoreDetailAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailAdressTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.adressLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"address"]];
            cell.phone.text = [NSString stringWithFormat:@"tel:%@",self.dataDic[@"shop_data"][@"phone"]];
            cell.delegete = self;
            if ([[UserModel defaultUser].im_id isEqualToString:self.dataDic[@"shop_data"][@"im_id"]]) {
                cell.chatBt.hidden = YES;
            }else{
                cell.chatBt.hidden = NO;
                
            }
            if ([cell.phone.text rangeOfString:@"null"].location != NSNotFound) {
                cell.phone.text = @"tel:商家没有留下电话号码😢";
            }
             return cell;
        }
        
    }else if (indexPath.section == 1){
        LBStoreDetailHotProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailHotProductTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"planceholder"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][indexPath.row][@"goods_name"]];
        cell.moneyLb.text = [NSString stringWithFormat:@"¥%@",self.dataDic[@"goods_data"][indexPath.row][@"goods_price"]];
        cell.descrebLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][indexPath.row][@"goods_info"]];
        
         return cell;
    
    }else if (indexPath.section == 2){
        LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailreplaysTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.starView.progress = [self.dataDic[@"com_data"][indexPath.row][@"mark"] integerValue];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"user_name"]];
        
        NSString *showText = [self.dataDic[@"com_data"][indexPath.row][@"comment"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.contentLb.text = showText;
        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"addtime"]];
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"tx_icon"] options:SDWebImageAllowInvalidSSLCertificates];
        
        
        if ([self.dataDic[@"com_data"][indexPath.row][@"is_comment"] integerValue] == 2) {
            cell.replyLb.hidden = NO;
            cell.replyLb.text = [NSString stringWithFormat:@"商家回复:%@",[self.dataDic[@"com_data"][indexPath.row][@"reply"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            cell.constaritH.constant = 15;
            cell.constraitTop.constant = 0;
            
        }else{
            cell.replyLb.hidden = YES;
            cell.replyLb.text = @"";
            cell.constaritH.constant = 0;
            cell.constraitTop.constant = 6;
            
        }

         return cell;
        
    }else if (indexPath.section == 3){
        LBStoreDetailRecomendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailRecomendTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.lovedataArr[indexPath.row][@"store_pic"]]] placeholderImage:[UIImage imageNamed:@"planceholder"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.lovedataArr[indexPath.row][@"shop_name"]];
         cell.descrebLb.text = [NSString stringWithFormat:@"%@",self.lovedataArr[indexPath.row][@"shop_type"]];
        cell.styeLb.text = [NSString stringWithFormat:@"%@",self.lovedataArr[indexPath.row][@"shop_area"]];
        cell.surpluslimitLb.text = @"";
        
        if ([self.lovedataArr[indexPath.row][@"limit"] integerValue] >=0 && [self.lovedataArr[indexPath.row][@"limit"] integerValue] < 1000) {
            cell.distanceLb.text = [NSString stringWithFormat:@"%@m",self.lovedataArr[indexPath.row][@"limit"]];
        }else if ([self.lovedataArr[indexPath.row][@"limit"] integerValue] >= 1000){
           
            cell.distanceLb.text = [NSString stringWithFormat:@"%.1fkm",[self.lovedataArr[indexPath.row][@"limit"] floatValue]/1000];
        }
        
         return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    return 40;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBStoreDetailHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBStoreDetailHeaderView"];
    if (!headerview) {
        headerview = [[LBStoreDetailHeaderView alloc] initWithReuseIdentifier:@"LBStoreDetailHeaderView"];
        
    }
    headerview.delegete = self;
    headerview.index = section;
    if (section == 0){
        headerview.titleLb.hidden = YES;
        headerview.moreBt.hidden = YES;
    }else if (section == 1){
//        if (self.dataDic.count > 0 ) {
//            headerview.titleLb.text = [NSString stringWithFormat:@"热卖商品 (%u)",[self.dataDic[@"com_data"] count]];
//    
//        }else{
           headerview.titleLb.text = @"热卖商品";
//            
//        }
        headerview.moreBt.hidden = NO;
        [headerview.moreBt setTitle:@"查看全部" forState:UIControlStateNormal];
       headerview.titleLb.hidden = NO;
    }else if (section == 2){
        if (self.dataDic.count > 0 ) {
            headerview.titleLb.text = [NSString stringWithFormat:@"热门评论 (%zd)",[self.dataDic[@"com_data"] count]];
            if ([self.dataDic[@"pl_count"]integerValue] > 3) {
                headerview.moreBt.hidden = YES;
            }else{
                headerview.moreBt.hidden = YES;
            }
            
        }else{
            headerview.titleLb.text = @"热门评论 (0)";
            headerview.moreBt.hidden = YES;
        }
        
        [headerview.moreBt setTitle:@"查看更多" forState:UIControlStateNormal];
        headerview.titleLb.hidden = NO;
    }else if (section == 3){
        [headerview.moreBt setTitle:@"换一批" forState:UIControlStateNormal];
        headerview.titleLb.text = @"猜你喜欢";
        headerview.moreBt.hidden = NO;
        headerview.titleLb.hidden = NO;
    }
    
    return headerview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        self.HideNavagation = YES;
        self.hidesBottomBarWhenPushed = YES;
        LBStoreProductDetailInfoViewController *vc=[[LBStoreProductDetailInfoViewController alloc]init];
        vc.goodname = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][indexPath.row][@"goods_name"]];
        vc.storename = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"shop_name"]];
        vc.goodId = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][indexPath.row][@"goods_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        self.hidesBottomBarWhenPushed = YES;
        self.HideNavagation = YES;
        LBStoreMoreInfomationViewController *vc=[[LBStoreMoreInfomationViewController alloc]init];
        vc.storeId = self.dataDic[@"love_data"][indexPath.row][@"shop_id"];
        [self.navigationController pushViewController:vc animated:YES];
    
    }

}

-(void)checkmoreinfo:(NSInteger)index{

    switch (index) {
        case 1://查看商品
        {
            self.hidesBottomBarWhenPushed = YES;
            self.HideNavagation = YES;
            LBCheckMoreHotProductViewController *vc=[[LBCheckMoreHotProductViewController alloc]init];
            vc.storeId = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"shop_id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2://查看评论
            
            break;
        case 3://换一批
            [self BatchStore];
            break;
            
        default:
            break;
    }

}
//换一批商店
-(void)BatchStore{

    CGFloat lat = [[GLNearby_Model defaultUser].latitude floatValue];
    CGFloat lng = [[GLNearby_Model defaultUser].longitude floatValue];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/goToShop" paramDic:@{@"shop_id":self.storeId,@"lat":[NSNumber numberWithFloat:lat],@"lng":[NSNumber numberWithFloat:lng]} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                self.lovedataArr = responseObject[@"data"][@"love_data"];
                
                [self.tableview reloadData];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}
//分享页面消失
- (void)dismiss{
    CGFloat shareVH = SCREEN_HEIGHT /5;
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareVH);
        
    } completion:^(BOOL finished) {
        
        [_maskV removeFromSuperview];
    }];
}

#pragma mark --- LBStoreDetailAdressDelegete
//打电话
-(void)takePhne{

    NSString *phonestr = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"phone"]];
    if ([phonestr rangeOfString:@"null"].location != NSNotFound || phonestr.length <= 0) {
        [MBProgressHUD showError:@"商家没有留下他的联系方式"];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phonestr]]]; //拨号
}

//去这里
-(void)gotheremap{
    
    CGFloat lat = [self.dataDic[@"shop_data"][@"lat"] floatValue];
    CGFloat lng = [self.dataDic[@"shop_data"][@"lng"] floatValue];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
    {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f | name:目的地&mode=driving&coord_type=bd0911",lat, lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }else{
        //使用自带地图导航
        CLLocationCoordinate2D destCoordinate;
        // 将数据传到反地址编码模型
        destCoordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(lat,lng), AMapCoordinateTypeBaidu);
        
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destCoordinate addressDictionary:nil]];
        toLocation.name = @"目的地";
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
      }

}
//联系商家
-(void)contactMerchant{
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    self.HideNavagation = YES;
    self.isREfresh = YES;
    NSString *im_id = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"im_id"]];
    if ([im_id isEqualToString:@""] || [im_id rangeOfString:@"null"].location != NSNotFound) {
        [MBProgressHUD showError:@"该商家还未开通聊天功能"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    NIMSession *session = [NIMSession session:im_id type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController showViewController:vc sender:nil];

}

#pragma mark -- LBStoreDetailNameDelegete
//我要买单
-(void)payTheBill{
    self.hidesBottomBarWhenPushed = YES;
    self.HideNavagation = YES;
    self.isREfresh = YES;
    LBPayTheBillViewController *vc=[[LBPayTheBillViewController alloc]init];
    vc.shop_uid = self.storeId;
     if (![self.dataDic[@"shop_data"][@"pic1"] isEqual:[NSNull null]]) {
        vc.pic = self.dataDic[@"shop_data"][@"pic1"];
    };
    vc.namestr = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"shop_name"]];
    vc.surplusLimit = [NSString stringWithFormat:@"%@",self.dataDic[@"shop_data"][@"surplusLimit"]];
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];

}

-(void)shareEvent{
    
    if (self.storeId == nil || self.storeId.length <= 0) {
        [MBProgressHUD showError:@"暂无商家信息"];
        return;
    }
    CGFloat shareVH = SCREEN_HEIGHT /5;
    
    if (_shareV == nil) {
        
        _shareV = [[NSBundle mainBundle] loadNibNamed:@"GLShareView" owner:nil options:nil].lastObject;
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
        [_shareV.weiboShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.weixinShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.friendShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.maskView addSubview:_shareV];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT - shareVH, SCREEN_WIDTH, shareVH);
    }];
    
    
}

- (void)shareClick:(UIButton *)sender {
    
    if (sender == _shareV.weiboShareBtn) {
        [self shareTo:@[UMShareToSina]];
    }else if (sender == _shareV.weixinShareBtn){
        [self shareTo:@[UMShareToWechatSession]];
    }else if (sender == _shareV.friendShareBtn){
        [self shareTo:@[UMShareToWechatTimeline]];
    }
    
}
- (void)shareTo:(NSArray *)type{
    [self.maskView removeFromSuperview];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?shop_id=%@&lat=%f&lng=%f",@"https://www.51dztg.com/index.php/Home/Share/shop",self.storeId,self.lat,self.lng];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?shop_id=%@&lat=%f&lng=%f",@"https://www.51dztg.com/index.php/Home/Share/shop",self.storeId,self.lat,self.lng];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@?shop_id=%@&lat=%f&lng=%f",@"https://www.51dztg.com/index.php/Home/Share/shop",self.storeId,self.lat,self.lng];
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"大众共享，让每一个有心参与公益事业的人都能参与进来(用safari浏览器打开)%@?shop_id=%@&lat=%f&lng=%f",@"https://www.51dztg.com/index.php/Home/Share/shop",self.storeId,self.lat,self.lng] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}

-(void)tapgestureMaskSgare{
    [self.maskView removeFromSuperview];
    
}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerImageHeight)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"轮播暂位图"]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"轮播暂位图"];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.tag = 101;
    }
    
    return _cycleScrollView;
    
}

-(UIButton*)shareButton{

    if (!_shareButton) {
        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_shareButton setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareStoreAdress) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.backgroundColor = [UIColor clearColor];
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(5, 14, 5, 0);
    }
 
    return _shareButton;

}

-(NSDictionary*)dataDic{

    if (!_dataDic) {
        _dataDic=[NSDictionary dictionary];
    }

    return _dataDic;
}

-(NSArray*)lovedataArr{
    if (!_lovedataArr) {
        _lovedataArr=[NSArray array];
    }
    return _lovedataArr;
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMaskSgare)];
        [_maskView addGestureRecognizer:tapgesture];
    }
    
    return _maskView;
    
}

@end
