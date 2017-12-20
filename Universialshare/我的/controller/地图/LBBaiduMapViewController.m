//
//  LBBaiduMapViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/3/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBaiduMapViewController.h"
#import "SearchViewController.h"

@interface LBBaiduMapViewController ()<UISearchBarDelegate>
{
    BOOL _isGetLocation;//是否拿到了位置信息
}

@property (strong , nonatomic)BMKPointAnnotation *pointAnnotation;
@property (strong , nonatomic)NSString *locationStr;//地址
@property (strong , nonatomic)NSString *provinceid;//省
@property (strong , nonatomic)NSString *cityid;//市
@property (strong , nonatomic)NSString *coutry;//区
@property (nonatomic, assign) CGFloat longitude;  // 经度
@property (nonatomic, assign) CGFloat latitude; // 纬度

@property (nonatomic, assign) CLLocationCoordinate2D coors2; // 纬度
@property (nonatomic, assign) CLLocationCoordinate2D pt; // 纬度
@property (strong , nonatomic)BMKReverseGeoCodeOption *option;//地址

@property (assign , nonatomic)BOOL  isLocation;//是否定位到当前位置

@end

@implementation LBBaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.navigationController.navigationBar.translucent = NO;
//    }
    _locService = [[BMKLocationService alloc]init];
    _poisearch = [[BMKPoiSearch alloc]init];
    
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]init];
    barItem.target = self;
    barItem.action = @selector(customLocationAccuracyCircle);
    barItem.title = @"确定";
    self.title=@"地图";
    self.navigationItem.rightBarButtonItem = barItem;
    
    _isGetLocation = NO;
    [self.view addSubview:self.mapView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 110, 35)];
    [titleView setBackgroundColor:[UIColor clearColor]];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor clearColor];
    searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH - 110, 35);
    searchBar.layer.cornerRadius = 17;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.layer.masksToBounds = YES;
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) weakself =self;
    SearchViewController *vc =[[SearchViewController alloc]init];

    vc.block = ^(NSString *address, CLLocationCoordinate2D pt) {
        weakself.isLocation = YES;
        weakself.pointAnnotation.title=@"位置";
        weakself.pointAnnotation.subtitle=address;
        weakself.pointAnnotation.coordinate = pt;
         weakself.mapView.centerCoordinate = pt;
        weakself.pt = pt;
        [weakself.mapView addAnnotation:weakself.pointAnnotation];

    };
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
     self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.mapView.buildingsEnabled =YES;
    self.mapView.zoomLevel=17;//地图级别
//    if (self.isLocation == NO) {
//            [self.locService startUserLocationService];
//    }
    
       [self.locService startUserLocationService];
   
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
    self.mapView.isSelectedAnnotationViewFront = YES;
    self.navigationController.navigationBar.hidden = NO;
}

//添加标注
-(void)addPointAnnotation
{
    
    self.pointAnnotation.coordinate = self.coors2;
    self.pointAnnotation.title = @"地址";
    self.pointAnnotation.subtitle=self.locationStr;
    [_mapView addAnnotation:self.pointAnnotation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *mapview 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //[_mapView updateLocationData:userLocation];

    // 调用反地址编码方法，让其在代理方法中输出
    [_locService stopUserLocationService];
    if (self.isLocation == NO) {
        self.coors2 = userLocation.location.coordinate;
        // 将数据传到反地址编码模型
        self.option.reverseGeoPoint = CLLocationCoordinate2DMake( userLocation.location.coordinate.latitude,  userLocation.location.coordinate.longitude);
         _mapView.centerCoordinate = userLocation.location.coordinate;
        [self addPointAnnotation];
    }else{
        self.coors2 = self.pt;
        // 将数据传到反地址编码模型
        self.option.reverseGeoPoint = CLLocationCoordinate2DMake( self.pt.latitude,  self.pt.longitude);
         _mapView.centerCoordinate = self.pt;
    }
    
     [self.geoCode reverseGeoCode:self.option];
    
}

/**
 *在地图View停止定位后，会调用此函数
 *mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [MBProgressHUD showError:@"定位失败"];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation

{

    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKAnnotationView *newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
        
        if (newAnnotationView == nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            ((BMKPinAnnotationView*)newAnnotationView).pinColor = BMKPinAnnotationColorRed;
            // 设置重天上掉下的效果(annotation)
            ((BMKPinAnnotationView*)newAnnotationView).animatesDrop = NO;
        }
        
        newAnnotationView.annotation=annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"mark_option"];   //把大头针换成别的图片
        
        // 设置可拖拽
        ((BMKPinAnnotationView*)newAnnotationView).draggable = YES;
        
        // [newAnnotationView setSelected:YES animated:YES];
        
        return newAnnotationView;
        
    }
    
    return nil;   
    
}
-(void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState{

    switch (newState) {
        case BMKAnnotationViewDragStateEnding:{
            
            CLLocationCoordinate2D destCoordinate = view.annotation.coordinate;
            self.coors2 = destCoordinate;
            // 将数据传到反地址编码模型
            self.option.reverseGeoPoint = CLLocationCoordinate2DMake( view.annotation.coordinate.latitude,  view.annotation.coordinate.longitude);
            
            // 调用反地址编码方法，让其在代理方法中输出
            [self.geoCode reverseGeoCode:self.option];
            
            break;
        }
            
        default:
            break;
    }

}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (result) {
        //        self.address.text = [NSString stringWithFormat:@"%@", result.address];
        //NSLog(@"位置结果是：%@ - %@", result.address, result.addressDetail.city);
        //        NSLog(@"经纬度为：%@ 的位置结果是：%@", locationString, result.address);
        
        self.locationStr = result.address;
        self.provinceid = result.addressDetail.province;
        self.cityid = result.addressDetail.city;
        self.coutry = result.addressDetail.district;
        if (self.isLocation == NO) {
             self.pointAnnotation.subtitle = result.address;
        }
        //确定已拿到位置信息
        _isGetLocation = YES;
        
        // 定位一次成功后就关闭定位
       // [_locService stopUserLocationService];
        
    }else{
        //NSLog(@"%@", @"找不到相对应的位置");
    }
    
}

#pragma mark 代理方法返回地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSString *locationString = [NSString stringWithFormat:@"经度为：%.2f   纬度为：%.2f", result.location.longitude, result.location.latitude];
        NSLog(@"经纬度为：%@ 的位置结果是：%@", locationString, result.address);
        //        NSLog(@"%@", result.address);
    }else{
        //        self.location.text = @"找不到相对应的位置";
        NSLog(@"%@", @"找不到相对应的位置");
    }
}

//确定
- (void)customLocationAccuracyCircle {

    if (_isGetLocation) {
        
        self.returePositon(self.locationStr,self.provinceid,self.cityid,self.coutry,self.coors2);
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"还未定位到当前位置"];
    }
   
}


-(BMKMapView*)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mapView.backgroundColor=[UIColor whiteColor];
        _mapView.mapType = BMKMapTypeStandard;
    }

    return _mapView;
}

-(BMKPointAnnotation *)pointAnnotation{

    if (!_pointAnnotation) {
       _pointAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _pointAnnotation;
}

-(NSString*)locationStr{

    if (!_locationStr) {
        _locationStr=[NSString string];
    }
    return _locationStr;

}
-(NSString*)provinceid{
    
    if (!_provinceid) {
        _provinceid=[NSString string];
    }
    return _provinceid;
    
}
-(NSString*)cityid{
    
    if (!_cityid) {
        _cityid=[NSString string];
    }
    return _cityid;
    
}
-(NSString*)coutry{
    
    if (!_coutry) {
        _coutry=[NSString string];
    }
    return _coutry;
    
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
- (void)dealloc {
    if (_geoCode != nil) {
        _geoCode = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

@end
