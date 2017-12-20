//
//  LBNearClassfityAdviseViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBNearClassfityAdviseViewController.h"
#import "GLNearby_classifyCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomeLiveChooseController.h"
#import "GLNearby_MerchatListModel.h"
#import "GLCityChooseController.h"
#import <MapKit/MapKit.h>
#import "LBStoreMoreInfomationViewController.h"
#import "GLNearby_NearShopModel.h"
#import "GLHomeLiveChooseController.h"
#import "UIButton+SetEdgeInsets.h"
#import "MXNavigationBarManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface LBNearClassfityAdviseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    GLSet_MaskVeiw *_maskV;
    UIView *_contentView;
    UIButton *_tmpBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *nearModels;
@property (nonatomic, strong)NSMutableArray *recModels;
@property (nonatomic, strong)NSMutableArray *tradeArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, strong)UIView  *maskV;//遮罩
@property (nonatomic, strong)GLHomeLiveChooseController *chooseVC2;//选择控制器
@property (nonatomic, strong)GLHomeLiveChooseController *chooseVC;//选择控制器

@property (nonatomic, copy)NSString  *city_id;//选择城市

@property (nonatomic, copy)NSString  *sort;// 选择排序

@property (nonatomic, copy)NSString  *limit;//选择距离


@end

static NSString *ID = @"GLNearby_classifyCell";
@implementation LBNearClassfityAdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView addSubview:self.nodataV];
    self.city_id = @"";
    self.sort = @"";
    self.limit = @"";
    
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
   
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)updateData:(BOOL)status {
    
    if (status) {
        _page = 1;
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = @(self.page);
    dict[@"trade_id"] = self.trade_id;
    dict[@"two_trade_id"] = self.two_trade_id;
        [NetworkManager requestPOSTWithURLStr:@"Shop/getMoreRecShop" paramDic:dict finish:^(id responseObject) {
            [self endRefresh];
            if ([responseObject[@"code"] integerValue] == 1){
                if (status) {
                    [self.recModels removeAllObjects];
                }
                if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                    
                    for (NSDictionary *dic  in responseObject[@"data"]) {
                        GLNearby_MerchatListModel *model = [GLNearby_MerchatListModel mj_objectWithKeyValues:dic];
                        [self.recModels addObject:model];
                    }
                }
            }
            [self.tableView reloadData];
            
            
        } enError:^(NSError *error) {
            [self endRefresh];
            [self.tableView reloadData];
            [MBProgressHUD showError:@"数据加载失败"];
        }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    }
    return _nodataV;
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_maskV removeFromSuperview];
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chooseVC.view.height = 0;
        self.chooseVC2.view.height = 0;
    } completion:^(BOOL finished) {
        _maskV.alpha = 0;
        
    }];
   
}

#pragma UITableviewDelegate UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.recModels.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }

        return self.recModels.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (self.recModels.count != 0) {
            
            cell.merchatModel = self.recModels[indexPath.row];
        }
        cell.distanceLabel.hidden = YES;
       cell.selectionStyle = 0;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
    
    GLNearby_NearShopModel *model;
    

        model = self.recModels[indexPath.row];
   
    
    storeVC.lat = [model.lat floatValue];
    storeVC.lng = [model.lng floatValue];
    storeVC.storeId = model.shop_id;
    
    [self.navigationController pushViewController:storeVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115;
    
}


- (NSMutableArray *)nearModels{
    if (!_nearModels) {
        _nearModels = [NSMutableArray array];
    }
    return _nearModels;
}
- (NSMutableArray *)recModels{
    if (!_recModels) {
        _recModels = [NSMutableArray array];
    }
    return _recModels;
}
- (NSMutableArray *)tradeArr{
    if (!_tradeArr) {
        _tradeArr = [NSMutableArray array];
    }
    return _tradeArr;
}


- (GLHomeLiveChooseController *)chooseVC2{
    if (!_chooseVC2) {
        _chooseVC2 = [[GLHomeLiveChooseController alloc] init];
        
    }
    return _chooseVC2;
}


@end
