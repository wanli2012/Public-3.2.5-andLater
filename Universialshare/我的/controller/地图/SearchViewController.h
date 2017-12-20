//
//  SearchViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef void(^FinishBlock)(NSString *address,CLLocationCoordinate2D pt);//传回地址和百度地图经纬度

@interface SearchViewController : UIViewController

@property (nonatomic,strong) UITextField *inputAddTF;//输入地址框

@property (weak, nonatomic) IBOutlet UITableView *displayTableView;//显示的tableView

@property (nonatomic,strong) NSString *placeStr;

@property (nonatomic,strong) FinishBlock block;//回调的 block

@property (nonatomic,strong) NSString *locationCity;//定位城市

@end
