//
//  LBMineStoreAllOrdersViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineStoreAllOrdersViewController.h"
#import "LBMineStoreOrderingTableViewCell.h"
#import "LBMineStoreOrderingOneTableViewCell.h"

@interface LBMineStoreAllOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;


@end

@implementation LBMineStoreAllOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _page = 1;
    [self.tableview addSubview:self.nodataV];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineStoreOrderingOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineStoreOrderingOneTableViewCell"];
    self.tableview.estimatedRowHeight = 95;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
     [self initdatasource];
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
    [NetworkManager requestPOSTWithURLStr:@"User/order_list_shop" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token } finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {

                if (_refreshType == NO) {
                    [self.dataarr removeAllObjects];
                    if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                        [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                        [self.tableview reloadData];
                    }
                }else{
                    
                    if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                        [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                        [self.tableview reloadData];
                    }
            }
            
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
    
    
    if (self.dataarr.count > 0) {
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
    }
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return UITableViewAutomaticDimension;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LBMineStoreOrderingOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineStoreOrderingOneTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.namelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"goods_name"]];
    cell.numlb.text = [NSString stringWithFormat:@"数量:%@",self.dataarr[indexPath.row][@"goods_total"]];
    cell.modelLb.text = [NSString stringWithFormat:@"奖励模式:%@",self.dataarr[indexPath.row][@"rlmodel_type"]];
    cell.moneyLb.text = [NSString stringWithFormat:@"实付款:%@",self.dataarr[indexPath.row][@"line_money"]];
    cell.orderCode.text = [NSString stringWithFormat:@"订单号:%@",self.dataarr[indexPath.row][@"order_num"]];
    
    if ([self.dataarr[indexPath.row][@"status"] integerValue] == 0) {
        cell.status.text = @"审核失败";
        cell.status.textColor = YYSRGBColor(198, 51, 14, 1);
    }else if ([self.dataarr[indexPath.row][@"status"] integerValue] == 1){
        cell.status.text = @"成功";
        cell.status.textColor = TABBARTITLE_COLOR;
    }else if ([self.dataarr[indexPath.row][@"status"] integerValue] == 2){
        cell.status.text = @"未审核";
        cell.status.textColor = YYSRGBColor(198, 51, 14, 1);
    }
    return cell;
    
    
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
