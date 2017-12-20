//
//  GLNearbyViewController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.

#import "GLNearbyViewController.h"
#import "LBRecomendShopModel.h"
#import "GLNearby_SearchController.h"
#import "MXNavigationBarManager.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "LBPayTheBillViewController.h"
#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_classifyCell.h"
#import "GLNearby_SectionHeaderView.h"
#import "LBStoreMoreInfomationViewController.h"
#import "GLNearby_MerchatListController.h"
#import "LBNearClassfityViewController.h"
#import "LBStoreProductDetailInfoViewController.h"
#import "GLMine_AdController.h"
#import "GLHourseDetailController.h"
#import "LBBurstingWithPopularityTableViewCell.h"
#import "LBBurstingWithPopularityOneTableViewCell.h"
#import "LBNearClassfityAdviseViewController.h"

@interface GLNearbyViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ClassifyHeaderViewdelegete,LBBurstingWithPopularitydelegete>

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextF;

@property (nonatomic, assign) CLLocationCoordinate2D coors2; // 纬度
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (strong , nonatomic)BMKReverseGeoCodeOption *option;//地址
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContrait;

@property (nonatomic, strong)UIView *placeHolderView;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)GLNearby_ClassifyHeaderView *classfyHeaderV;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSArray *tradeArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *nearArr;
@property (nonatomic, strong)NSMutableArray *recomendArr;
@property (nonatomic, strong)NSMutableArray *recomendArrone;
@property (nonatomic, strong)NSMutableArray *banner;
@property (weak, nonatomic) IBOutlet UIView *baseSearchV;

@end

static NSString *ID = @"GLNearby_classifyCell";
static NSString *ID2 = @"LBBurstingWithPopularityTableViewCell";
static NSString *ID3 = @"LBBurstingWithPopularityOneTableViewCell";

@implementation GLNearbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    adjustsScrollViewInsets_NO(self.tableview,self);
    self.tableview.tableHeaderView = self.classfyHeaderV;
    
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.tableview registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellReuseIdentifier:ID2];
    [self.tableview registerNib:[UINib nibWithNibName:ID3 bundle:nil] forCellReuseIdentifier:ID3];
    //请求数据
    [self postRequest];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        [self updateData:YES];
    }];
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableview.mj_header = header;
    
    [self.tableview.mj_header beginRefreshing];
    
    
}
//扫码
- (IBAction)ScanButton:(UIButton *)sender {
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgFullNet;
    
    [self openScanVCWithStyle:style];
    
}
- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    self.hidesBottomBarWhenPushed = YES;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    __weak typeof(self) weakself = self;
    vc.retureCode = ^(NSString *codeStr){
       //跳转
        [weakself getStoreInfo:codeStr];//返回信息
        
    };
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

-(void)getStoreInfo:(NSString*)str{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (str.length > 11) {
        NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
        NSString *dencryptorstr = [RSAEncryptor decryptString:str privateKeyWithContentsOfFile:private_key_path password:@"448128"];//私钥密码
        if (![dencryptorstr hasPrefix:@"SH"]) {

            [MBProgressHUD showError:@"请扫正确的商家二维码"];
            return;
        }
        
        dict[@"shop_name"] = dencryptorstr;
        
    }else{
        if (![str hasPrefix:@"SH"]) {
            [MBProgressHUD showError:@"请扫正确的商家二维码"];
            return;
        }
        
        dict[@"shop_name"] = str;
    }
    
    __weak typeof(self) weakself = self;
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Shop/getShopData" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
           weakself.hidesBottomBarWhenPushed = YES;
            LBPayTheBillViewController *vc=[[LBPayTheBillViewController alloc]init];
            vc.namestr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
            vc.pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_pic"]];
            vc.shop_uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_id"]];
            vc.surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
            [weakself.navigationController pushViewController:vc animated:YES];
            weakself.hidesBottomBarWhenPushed = NO;
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

//获取行业分类
- (void)postRequest {
    
     [self.locService startUserLocationService];//开始定位
    __weak typeof(self) weakself = self;
//    _loadV = [LoadWaitView addloadview:self.view.bounds tagert:self.view];
//    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Shop/getTradeIdNewVersion" paramDic:@{} finish:^(id responseObject) {
    
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1){
            weakself.tradeArr = responseObject[@"data"][@"trade"];
            [self.classfyHeaderV initdatasorece:weakself.tradeArr];
            self.placeHolderView.hidden = YES;
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
       [MBProgressHUD showError:@"数据加载失败"];
    }];
    
}

//加载数据
- (void)updateData:(BOOL)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"lng"] = [GLNearby_Model defaultUser].longitude;
    dict[@"lat"] = [GLNearby_Model defaultUser].latitude;
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/serachNearMain" paramDic:dict finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.nearArr removeAllObjects];
                [self.recomendArr removeAllObjects];
                 [self.recomendArrone removeAllObjects];
                [self endRefresh];
                
                [GLNearby_Model defaultUser].city_id = responseObject[@"city_id"];
                for (NSDictionary *dic  in responseObject[@"data"][@"near_shop"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.nearArr addObject:model];
                }
                for (NSDictionary *dic  in responseObject[@"data"][@"tj_shop"][@"one"]) {
                    LBRecomendShopModel *model = [LBRecomendShopModel mj_objectWithKeyValues:dic];
                    [self.recomendArr addObject:model];
                }
                for (NSDictionary *dic  in responseObject[@"data"][@"tj_shop"][@"two"]) {
                    LBRecomendShopModel *model = [LBRecomendShopModel mj_objectWithKeyValues:dic];
                    [self.recomendArrone addObject:model];
                }
                
                [self.banner removeAllObjects];
                [self.banner addObjectsFromArray:responseObject[@"data"][@"advert"]];
                NSMutableArray  *images = [NSMutableArray array];
                CGFloat heightIma = 0;
                CGFloat widthIma = 0;
                for (int i = 0; i < self.banner.count; i++) {
                    [images addObject:self.banner[i][@"thumb"]];
                    heightIma = [self.banner[i][@"height"] floatValue];
                    widthIma = [self.banner[i][@"width"] floatValue];
                }
                if (images.count > 0) {
                    [self.classfyHeaderV reloadScorlvoewimages:images];
                    if (heightIma != 0 && widthIma != 0) {
                        self.classfyHeaderV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *(heightIma/widthIma) + 200 + (90 * autoSizeScaleX - 90) * autoSizeScaleX);
                        self.classfyHeaderV.heightB.constant = SCREEN_WIDTH *(heightIma/widthIma);
                    }
                }
                
                self.placeHolderView.hidden = YES;
                [self.tableview reloadData];
                
            }
        }
     
    } enError:^(NSError *error) {
       [self endRefresh];
        
    }];
    
}
- (void)endRefresh {
    
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    
}

#pragma mark --- tableview  delegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1 + self.recomendArrone.count;
    }else{
        return self.nearArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.recomendArr.count > 0 || self.recomendArrone.count > 0) {
             return 65 * autoSizeScaleX;
        }
    }else{
        if (self.nearArr.count > 0) {
             return 65 * autoSizeScaleX;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GLNearby_SectionHeaderView *headV = [[NSBundle mainBundle] loadNibNamed:@"GLNearby_SectionHeaderView" owner:nil options:nil].lastObject;
    
    if (section == 0) {
        headV.titileLb.text = [NSString stringWithFormat:@"人 气 爆 棚"];
        headV.subtitile.text = [NSString stringWithFormat:@"POPULAR NOW"];
        headV.moreBtn.tag = 10;
        if (self.recomendArr.count <= 0 && self.recomendArrone.count <= 0) {
            return nil;
        }
    }else{
        headV.titileLb.text = [NSString stringWithFormat:@"附 近 好 店"];
        headV.subtitile.text = [NSString stringWithFormat:@"GOOD SHOP NEARSY"];
        headV.moreBtn.tag = 11;
        if (self.nearArr.count <= 0) {
            return nil;
        }
    }
    [headV.moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            LBBurstingWithPopularityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2 forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.dataArr = self.recomendArr;
            cell.delegte = self;
            if (self.recomendArr.count > 0) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
        }else{
            LBBurstingWithPopularityOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID3 forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.model = self.recomendArrone[indexPath.row - 1];
            return cell;
        }
        
    }else{
        
        GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.model = self.nearArr[indexPath.row];
        return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.recomendArr.count > 0) {
                return (SCREEN_WIDTH - 30)/3.0 + 25;
            }else{
                return 0;
            }
            
        }else{
            return SCREEN_WIDTH * (262/690.0) + 3;
        }
    }else{
       return 110;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;

    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
              LBRecomendShopModel *model = self.recomendArrone[indexPath.row - 1];
            if ([model.type integerValue]==1) {//跳详情
                LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
                store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
                store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
                store.storeId = model.shop_id;
                [self.navigationController pushViewController:store animated:YES];
            }else if ([model.type integerValue]==2){//跳分类
                LBNearClassfityAdviseViewController *store = [[LBNearClassfityAdviseViewController alloc] init];
                store.trade_id = model.trade_id;
                store.two_trade_id = model.two_trade_id;
                [self.navigationController pushViewController:store animated:YES];
            }
        }
    }else{//跳详情
        LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
        store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
        store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
        GLNearby_NearShopModel *model = self.nearArr[indexPath.row];
        store.storeId = model.shop_id;
        [self.navigationController pushViewController:store animated:YES];
    }
    
    self.hidesBottomBarWhenPushed = NO;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //定位
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    _mapView.zoomLevel=20;//地图级别
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    
  
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (IBAction)search:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLNearby_SearchController *searchVC = [[GLNearby_SearchController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.coors2 = userLocation.location.coordinate;

    [GLNearby_Model defaultUser].latitude = [NSString stringWithFormat:@"%f",self.coors2.latitude];
    [GLNearby_Model defaultUser].longitude = [NSString stringWithFormat:@"%f",self.coors2.longitude];
    
    //加载数据
     [self updateData:YES];
    // 将数据传到反地址编码模型
    self.option.reverseGeoPoint = CLLocationCoordinate2DMake( userLocation.location.coordinate.latitude,  userLocation.location.coordinate.longitude);
    
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:self.option];
    [_locService stopUserLocationService];
    
}

- (void)more:(UIButton * )btn {
    
    self.hidesBottomBarWhenPushed = YES;
    GLNearby_MerchatListController *merchatVC = [[GLNearby_MerchatListController alloc] init];
    merchatVC.index = btn.tag;
    merchatVC.city_id = [GLNearby_Model defaultUser].city_id;
    [self.navigationController pushViewController:merchatVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark ----- LBBurstingWithPopularitydelegete
-(void)clickBurstingWithPopularity:(NSInteger)index{

    LBRecomendShopModel *model = self.recomendArr[index];
    self.hidesBottomBarWhenPushed = YES;
    if ([model.type integerValue] == 2) {
        LBNearClassfityAdviseViewController *store = [[LBNearClassfityAdviseViewController alloc] init];
        store.trade_id = model.trade_id;
        store.two_trade_id = model.two_trade_id;
        [self.navigationController pushViewController:store animated:YES];
    }else if ([model.type integerValue] == 1){
        LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
        store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
        store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
        LBRecomendShopModel *model = self.recomendArr[index];
        store.storeId = model.shop_id;
        [self.navigationController pushViewController:store animated:YES];
    
    }
    self.hidesBottomBarWhenPushed = NO;
    

}
#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {

        [self.cityBtn setTitle:result.addressDetail.city forState:UIControlStateNormal];
        [self.classfyHeaderV.adressLb setTitle:result.addressDetail.city forState:UIControlStateNormal];
        
        // 定位一次成功后就关闭定位
        [_locService stopUserLocationService];
        
    }
}

#pragma mark ----- ClassifyHeaderViewdelegete

-(void)tapgesture:(NSInteger)tag{

    if ((tag - 10) == self.tradeArr.count) {
        self.hidesBottomBarWhenPushed = YES;
        LBNearClassfityViewController *merchatVC = [[LBNearClassfityViewController alloc] init];
        merchatVC.index = 10;
        [self.navigationController pushViewController:merchatVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        self.hidesBottomBarWhenPushed = YES;
        LBNearClassfityViewController *merchatVC = [[LBNearClassfityViewController alloc] init];
        merchatVC.typeArr = self.tradeArr[tag - 10][@"son"];
        merchatVC.trade_id = self.tradeArr[tag - 10][@"trade_id"];
         merchatVC.city_id = [GLNearby_Model defaultUser].city_id;
        [self.navigationController pushViewController:merchatVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}
//点击图片
-(void)tapgestureImage:(NSInteger)index{

    if(self.self.banner.count == 0){
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([self.banner[index][@"type"] integerValue] == 1) {//内部广告
        if([self.banner[index][@"jumptype"] integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = self.banner[index][@"jumpid"];
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else{//跳转商品
            
            if ([self.banner[index][@"goodstype"] integerValue] == 1) {//逛逛商品
                
                LBStoreProductDetailInfoViewController *storeVC = [[LBStoreProductDetailInfoViewController alloc] init];
                storeVC.goodId = self.banner[index][@"jumpid"];
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else{
                
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id = self.banner[index][@"jumpid"];
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
            
        }
        
    }else if([self.banner[index][@"type"] integerValue] == 2){//外部广告
        
        GLMine_AdController *adVC = [[GLMine_AdController alloc] init];
        adVC.url = self.banner[index][@"url"];
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    self.hidesBottomBarWhenPushed = NO;
    
}

-(void)clickSerachevent{
 
    [self search:nil];
}

-(void)clickSacnEvent{

    [self ScanButton:nil];

}

#pragma mark --- scrollvireDelegere

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y <= 0) {
        self.baseSearchV.hidden = YES;
        self.classfyHeaderV.searchView.hidden = NO;
        self.baseSearchV.backgroundColor = YYSRGBColor(255, 155, 33, 0);
    }else{
        self.baseSearchV.backgroundColor = YYSRGBColor(255, 155, 33, (scrollView.contentOffset.y)/200 * autoSizeScaleX);
        self.baseSearchV.hidden = NO;
        self.classfyHeaderV.searchView.hidden = YES;
    }
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.searchView.layer.cornerRadius = 4;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.topContrait.constant = 0;
    
}

#pragma mark geoCode的Get方法，实现延时加载
- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode)
    {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (BMKReverseGeoCodeOption *)option
{
    if (!_option)
    {
        _option = [[BMKReverseGeoCodeOption alloc] init];
    }
    return _option;
}
- (BMKLocationService *)locService
{
    if (!_locService)
    {
        _locService = [[BMKLocationService alloc] init];
        _locService.desiredAccuracy = 10.f;
    }
    return _locService;
}

- (UIView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49-64)];
        CGFloat height = 105;
        CGFloat width = 170;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(_placeHolderView.center.x - width/2, (_placeHolderView.yy_height - height) / 2 , width, height);
        imageV.image = [UIImage imageNamed:@"pic_nodata"];
        imageV.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 30, _placeHolderView.yy_width, 20)];
        label.text = @"点击重新加载";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        
        [_placeHolderView addSubview:imageV];
        [_placeHolderView addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postRequest)];
        [_placeHolderView addGestureRecognizer:tap];
        
    }
    return _placeHolderView;
}

-(GLNearby_ClassifyHeaderView*)classfyHeaderV{

    if (!_classfyHeaderV) {
        _classfyHeaderV = [[GLNearby_ClassifyHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350 + (90 * autoSizeScaleX - 90) * autoSizeScaleX) withDataArr:self.tradeArr];
        _classfyHeaderV.autoresizingMask = UIViewAutoresizingNone;
        _classfyHeaderV.delegete = self;
    }
    return _classfyHeaderV;
}

-(NSArray*)tradeArr{

    if (!_tradeArr) {
        _tradeArr = [NSArray array];
    }
    return _tradeArr;
}

- (NSMutableArray *)nearArr{
    if (!_nearArr) {
        _nearArr = [NSMutableArray array];
    }
    return _nearArr;
}

- (NSMutableArray *)banner{
    if (!_banner) {
        _banner = [NSMutableArray array];
    }
    return _banner;
}

- (NSMutableArray *)recomendArr{
    if (!_recomendArr) {
        _recomendArr = [NSMutableArray array];
    }
    return _recomendArr;
}
- (NSMutableArray *)recomendArrone{
    if (!_recomendArrone) {
        _recomendArrone = [NSMutableArray array];
    }
    return _recomendArrone;
}

@end
