//
//  LBMineCenterReceivingGoodsViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterReceivingGoodsViewController.h"
#import "LBMineCenterReceivingGoodsTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LBMineCenterFlyNoticeDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LBWaitOrdersHeaderView.h"
#import "LBWaitOrdersModel.h"
#import "LBWaitOrdersListModel.h"
#import "LBMineCenterMyOrderViewController.h"

@interface LBMineCenterReceivingGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,LBMineCenterReceivingGoodsDelegete,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@property (assign, nonatomic)NSIndexPath *indexpath;
@property (strong, nonatomic)NSString *good_id;
@property (strong, nonatomic)NSString *order_id;
@end

@implementation LBMineCenterReceivingGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterReceivingGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterReceivingGoodsTableViewCell"];
    
//    [self.tableview registerClass:[LBWaitOrdersHeaderView class] forHeaderFooterViewReuseIdentifier:@"LBWaitOrdersHeaderView"];
    
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
    
    [self initdatasource];
    
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/gain_list" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                    
                    LBWaitOrdersModel *orderMode = [[LBWaitOrdersModel alloc]init];

                    orderMode.order_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"order_id"]];
                    orderMode.order_number = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"order_number"]];
                    orderMode.creat_time = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"creat_time"]];
                    orderMode.logistics_sta = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"logistics_sta"]];
                     orderMode.order_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"order_type"]];
                    orderMode.isExpanded = NO;
                    for (int j =0; j < [responseObject[@"data"][i][@"order_glist"]count]; j++) {
                        LBWaitOrdersListModel   *listmodel = [LBWaitOrdersListModel mj_objectWithKeyValues:responseObject[@"data"][i][@"order_glist"][j]];
                        [orderMode.dataArr addObject:listmodel];
                    }
   
                    [self.dataarr addObject:orderMode];
                }
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            [MBProgressHUD showError:responseObject[@"message"]];
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
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
    
    LBWaitOrdersModel *model = self.dataarr[section];
    return model.isExpanded ? model.dataArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterReceivingGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterReceivingGoodsTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegete = self;
    cell.indexpath = indexPath;
    LBWaitOrdersModel *model = self.dataarr[indexPath.section];
        cell.order_id = model.order_id;
    cell.WaitOrdersListModel = model.dataArr[indexPath.row];
    [cell.downMenuButton dismissButtons];
   
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 90;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    LBWaitOrdersHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBWaitOrdersHeaderView"];

    if (!headerview) {
        headerview = [[LBWaitOrdersHeaderView alloc] initWithReuseIdentifier:@"LBWaitOrdersHeaderView"];
    
    }
    LBWaitOrdersModel *sectionModel = self.dataarr[section];
    headerview.sectionModel = sectionModel;
    headerview.wuliuBt.hidden = YES;
    headerview.sureGetBt.hidden = YES;
    headerview.expandCallback = ^(BOOL isExpanded) {
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };

    return headerview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark ---- LBMineCenterReceivingGoodsDelegete
//确认收货
-(void)BuyAgaingoodid:(NSString *)goog_id orderid:(NSString *)orderid indexpath:(NSIndexPath *)indexpath{
    self.good_id = goog_id;
    self.order_id = orderid;
    self.indexpath = indexpath;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定已收货吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {

        LBWaitOrdersModel *model = self.dataarr[_indexpath.section];
        LBWaitOrdersListModel *modelist= model.dataArr[_indexpath.row];
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/ConfirmReceipt" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"order_goods_id":_good_id,@"order_id":self.order_id } finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue]==1) {
                [MBProgressHUD showError:responseObject[@"message"]];
                modelist.is_receipt = @"1";
                [self.tableview reloadData];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"orderJumptype" object:nil userInfo:@{@"order_type":model.order_type}];
               
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];
        
    }
    
}

-(void)checklogistics:(NSIndexPath *)index{

    LBWaitOrdersModel *model = self.dataarr[index.section];
    LBWaitOrdersListModel *listmodel= model.dataArr[index.row];
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterFlyNoticeDetailViewController *vc=[[LBMineCenterFlyNoticeDetailViewController alloc]init];
    vc.codestr = [NSString stringWithFormat:@"%@",listmodel.odd_num];
    [self.navigationController pushViewController:vc animated:YES];


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
