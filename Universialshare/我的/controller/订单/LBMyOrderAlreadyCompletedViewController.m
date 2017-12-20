//
//  LBMyOrderAlreadyCompletedViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderAlreadyCompletedViewController.h"
#import "LBMyOrderListTableViewCell.h"
#import "LBMineCenterOrderDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LBMyOrdersHeaderView.h"
#import "LBMyOrdersModel.h"
#import "LBMyOrdersListModel.h"
#import "LBFaceToFacePayHeaderView.h"

@interface LBMyOrderAlreadyCompletedViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@property (assign, nonatomic)NSInteger deleteRow;//删除下标

@end

@implementation LBMyOrderAlreadyCompletedViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadNewData];
    
}

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
    
}

-(void)initdatasource{
    
    //_loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/order_mark_list" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page] , @"type":@5} finish:^(id responseObject) {
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
                    ordersMdel.shop_name = responseObject[@"data"][i][@"shop_name"];
                     ordersMdel.isExpanded = NO;
                    ordersMdel.MyOrdersListModel = responseObject[@"data"][i][@"goods"];
                    [self.dataarr addObject:ordersMdel];
                }
            }
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMyOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyOrderListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.payBt setTitle:@"再次购买" forState:UIControlStateNormal];
    cell.payBt.hidden = YES;
    cell.deleteBt.hidden = YES;
   
    cell.index = indexPath.row;
    
    LBMyOrdersModel *model= (LBMyOrdersModel*)self.dataarr[indexPath.section];
    
    cell.myorderlistModel = model.MyOrdersListModel[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LBMineCenterOrderDetailViewController *vc=[[LBMineCenterOrderDetailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    LBMyOrdersModel *model= (LBMyOrdersModel*)self.dataarr[section];
    if ([model.order_type isEqualToString:@"3"]) {//面对面支付
         return 140;
        
    }else{
         return 85;
        
    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     LBMyOrdersModel *sectionModel = self.dataarr[section];
    
    if ([sectionModel.order_type isEqualToString:@"3"]) {//面对面支付
        LBFaceToFacePayHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBFaceToFacePayHeaderView"];
        
        if (!headerview) {
            headerview = [[LBFaceToFacePayHeaderView alloc] initWithReuseIdentifier:@"LBFaceToFacePayHeaderView"];
            
        }
        headerview.sectionModel = sectionModel;
         headerview.DeleteBt.hidden = NO;
        headerview.section = section;
        headerview.returnDeleteBt = ^(NSInteger section){
            self.deleteRow =section;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert show];
            
        };
        return headerview;
        
    }
    
    LBMyOrdersHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBMyOrdersHeaderView"];
    
    if (!headerview) {
        headerview = [[LBMyOrdersHeaderView alloc] initWithReuseIdentifier:@"LBMyOrdersHeaderView"];
        
    }
    
   headerview.section = section;
    headerview.sectionModel = sectionModel;
    headerview.expandCallback = ^(BOOL isExpanded) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    headerview.DeleteBt.hidden = NO;
    headerview.payBt.hidden = YES;
    headerview.returnDeleteBt = ^(NSInteger section){
        self.deleteRow =section;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        [alert show];

    
    };
    
    return headerview;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex==1) {
        
        LBMyOrdersModel *model=(LBMyOrdersModel*)self.dataarr[self.deleteRow];
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
        [NetworkManager requestPOSTWithURLStr:@"shop/delOrderLine" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"order_id" :model.order_id , @"type":@1} finish:^(id responseObject) {
            [_loadV removeloadview];
    
            if ([responseObject[@"code"] integerValue]==1) {
                
                 [MBProgressHUD showError:responseObject[@"message"]];
                [self.dataarr removeObjectAtIndex:self.deleteRow];
                [self.tableview reloadData];
                
            }else if ([responseObject[@"code"] integerValue]==3){
                
                [MBProgressHUD showError:responseObject[@"message"]];
                
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
                
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];
        
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
