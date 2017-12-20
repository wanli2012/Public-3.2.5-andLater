//
//  LBMyBusinessListViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyBusinessListViewController.h"
#import "LBNybusinessListTableViewCell.h"
#import "LBMyBusinessListDetailViewController.h"
#import <MapKit/MapKit.h>
#import <MJRefresh/MJRefresh.h>


@interface LBMyBusinessListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tapH;

@property (weak, nonatomic) IBOutlet UIView *navgationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationH;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@end

@implementation LBMyBusinessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"商家列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _page = 1;
    _refreshType = NO;
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBNybusinessListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBNybusinessListTableViewCell"];
    //获取数据
    [self initdatasource];
    [self.tableview addSubview:self.nodataV];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/dealerList" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         if ([responseObject[@"code"] integerValue]==1) {
             
             if (_refreshType == NO) {
                 [self.dataarr removeAllObjects];
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
             }else{
                 
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
                 
             }
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else if ([responseObject[@"code"] integerValue]==3){
             
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
             
             
         }
     } enError:^(NSError *error) {
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         [MBProgressHUD showError:error.localizedDescription];
         
     }];
    
    
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasource];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableview.estimatedRowHeight = 150;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        LBNybusinessListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBNybusinessListTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.index = indexPath.row;
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"dealer_pic"]]] placeholderImage:[UIImage imageNamed:@""]];
    cell.namelb.text =[NSString stringWithFormat:@"商户名:%@",self.dataarr[indexPath.row][@"dealer_name"]];
    cell.name1Lb.text =[NSString stringWithFormat:@"商户类型:%@",self.dataarr[indexPath.row][@"dealer_type"]];
    cell.adressLb.text =[NSString stringWithFormat:@"商户地址:%@",self.dataarr[indexPath.row][@"dealer_address"]];
     cell.moenyLb.text =[NSString stringWithFormat:@"销售额:¥%@",self.dataarr[indexPath.row][@"dealer_money"]];
    cell.phoneLb.text =[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"dealer_phone"]];
    
    if ([cell.namelb.text rangeOfString:@"null"].location != NSNotFound) {
        cell.namelb.text = @"商户名:";
    }
    if ([cell.name1Lb.text rangeOfString:@"null"].location != NSNotFound) {
        cell.name1Lb.text = @"商户类型:";
    }
    if ([cell.adressLb.text rangeOfString:@"null"].location != NSNotFound) {
        cell.adressLb.text = @"商户地址:";
    }
    if ([cell.moenyLb.text rangeOfString:@"null"].location != NSNotFound) {
        cell.moenyLb.text = @"销售额:¥0";
    }
    __weak typeof(self) weakself =self;
    cell.returnGowhere = ^(NSInteger index){
        if (weakself.HideNavB == NO) {
            double lat = [weakself.dataarr[index][@"dealer_lat"]doubleValue];double lng = [weakself.dataarr[index][@"dealer_lng"]doubleValue];
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"baidumap://map/geocoder?location=%f,%f&coord_type=bd09ll&src=webapp.rgeo.yourCompanyName.yourAppName",lat,lng]]];
            }else{
                //使用自带地图导航
                
                CLLocationCoordinate2D destCoordinate;
                // 将数据传到反地址编码模型
                destCoordinate = CLLocationCoordinate2DMake(lat,lng);
                
                MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
                
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destCoordinate addressDictionary:nil]];
                
                [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                           MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            }

        }else{
        
            if (weakself.returnpushinfovc) {
                weakself.returnpushinfovc(index);
            }
        }
        
    };
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.HideNavB == YES) {
        self.hidesBottomBarWhenPushed = YES;
        LBMyBusinessListDetailViewController *vc=[[LBMyBusinessListDetailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];

    }else{
        if (self.returnpushvc) {
            self.returnpushvc(self.dataarr[indexPath.row]);
        }
    
    }
    
    
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}

@end
