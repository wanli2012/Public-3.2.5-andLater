//
//  LBBaiduMapViewController.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/3/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LBBaiduMapViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>{
    
    BMKMapView *_mapView;
    BMKPoiSearch *_poisearch;
    int curPage;
}

@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;        // 地理编码
@property (nonatomic, strong) BMKLocationService *locService;        // 地理编码


@property (nonatomic, copy)void(^returePositon)(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors);

@end
