//
//  LBMyOrderPendingPaymentViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderPendingPaymentViewController.h"
#import "LBMyOrderListTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "LBMyOrdersHeaderView.h"
#import "LBMyOrdersModel.h"
#import "LBMyOrdersListModel.h"
#import "GLMine_RicePayController.h"
#import "LBMineCenterPayPagesViewController.h"

@interface LBMyOrderPendingPaymentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (nonatomic, copy)NSString *useableScore;//剩余积分

@end

@implementation LBMyOrderPendingPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMyOrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMyOrderListTableViewCell"];
    
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
    
    [self loadNewData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadNewData];
}

-(void)initdatasource{
    
    //_loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/order_mark_list" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page] , @"type":@1} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (int i = 0; i<[responseObject[@"data"] count]; i++) {
                    
                    LBMyOrdersModel *ordersMdel=[[LBMyOrdersModel alloc]init];
                    ordersMdel.addtime = responseObject[@"data"][i][@"addtime"];
                    ordersMdel.order_id = responseObject[@"data"][i][@"order_id"];
                    ordersMdel.order_money = responseObject[@"data"][i][@"order_money"];
                    ordersMdel.order_num = responseObject[@"data"][i][@"order_num"];
                    ordersMdel.order_type = responseObject[@"data"][i][@"order_type"];
                    ordersMdel.realy_price = responseObject[@"data"][i][@"realy_price"];
                    ordersMdel.total = responseObject[@"data"][i][@"total"];
                    ordersMdel.rice = responseObject[@"data"][i][@"rice"];
                    ordersMdel.coupus = responseObject[@"data"][i][@"coupons"];
                    ordersMdel.isExpanded = NO;
                    ordersMdel.MyOrdersListModel = responseObject[@"data"][i][@"goods"];
                    ordersMdel.crypt = responseObject[@"data"][i][@"crypt"];
                    [self.dataarr addObject:ordersMdel];
                }
                self.useableScore = responseObject[@"mark"];
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [self.tableview reloadData];
            
            if (self.dataarr.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.dataarr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    LBMyOrdersModel *model=self.dataarr[section];
    return model.isExpanded?model.MyOrdersListModel.count:0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 118;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBMyOrdersHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBMyOrdersHeaderView"];
    
    if (!headerview) {
        headerview = [[LBMyOrdersHeaderView alloc] initWithReuseIdentifier:@"LBMyOrdersHeaderView"];
    }
    __weak typeof(self)  weakself = self;
    LBMyOrdersModel *sectionModel = self.dataarr[section];
    headerview.sectionModel = sectionModel;
    headerview.expandCallback = ^(BOOL isExpanded) {
        
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    headerview.section = section;
    headerview.cancelBt.hidden = NO;
    headerview.returnCancelBt = ^(NSInteger index){//取消订单
        weakself.hidesBottomBarWhenPushed=YES;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        
        LBMyOrdersModel *model = self.dataarr[section];
        dict[@"order_id"] = model.order_id;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/qxOrder" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                [weakself loadNewData];
                                
            }
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
        }];
        
    };
    headerview.returnPayBt = ^(NSInteger index){//支付
        weakself.hidesBottomBarWhenPushed=YES;
        if ([sectionModel.order_type integerValue] == 2) {//米劵订单
            GLMine_RicePayController *vc=[[GLMine_RicePayController alloc]init];
            LBMyOrdersModel *model = self.dataarr[section];
            vc.order_sn =  model.order_num;
            vc.order_id = model.order_id;
            vc.order_sh = model.crypt;
            vc.orderPrice = model.realy_price;
            vc.useableScore = self.useableScore;
            vc.rice = model.rice;
            vc.order_type = model.order_type;
            vc.coupose = model.coupus;
            [weakself.navigationController pushViewController:vc animated:YES];

        }else{//非米劵订单
            
            LBMineCenterPayPagesViewController *vc=[[LBMineCenterPayPagesViewController alloc]init];
            LBMyOrdersModel *model = self.dataarr[section];
            vc.order_sn =  model.order_num;
            vc.order_id = model.order_id;
            vc.order_sh = model.crypt;
            vc.orderPrice = model.realy_price;
            vc.payType = [model.order_type intValue];
            vc.useableScore = self.useableScore;
            vc.pushIndex = 2;
            vc.rice = model.rice;
            vc.coupose = model.coupus;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    
    };
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMyOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyOrderListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.payBt setTitle:@"去支付" forState:UIControlStateNormal];
    cell.payBt.hidden = YES;
    cell.index = indexPath.row;
    cell.deleteBt.hidden = YES;
    cell.stauesLb.text = @"待付款";
    
    LBMyOrdersModel *model= (LBMyOrdersModel*)self.dataarr[indexPath.section];
    
    cell.myorderlistModel = model.MyOrdersListModel[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
