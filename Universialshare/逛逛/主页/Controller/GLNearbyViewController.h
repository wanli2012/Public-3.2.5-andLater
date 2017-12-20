//
//  GLNearbyViewController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface GLNearbyViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    
    BMKMapView *_mapView;
    
}

@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;        // 地理编码
@property (nonatomic, strong) BMKLocationService *locService;        // 地理编码
@end
