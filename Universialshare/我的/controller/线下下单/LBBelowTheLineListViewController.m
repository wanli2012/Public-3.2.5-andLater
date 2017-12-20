//
//  LBBelowTheLineListViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBelowTheLineListViewController.h"
#import "LBBelowTheLineListTableViewCell.h"
#import "QQPopMenuView.h"

@interface LBBelowTheLineListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic)NSString *type;//0 审核失败 1成功 2未审核 不传代表查所有
@property (strong, nonatomic)UIButton *buttonedt;

@end

@implementation LBBelowTheLineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    self.type = @"3";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBBelowTheLineListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBBelowTheLineListTableViewCell"];
    
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
    
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setImage:[UIImage imageNamed:@"筛选更多"] forState:UIControlStateNormal];
    [_buttonedt setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 0, -5)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(chooseevent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getUserOrderList" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page],@"type":self.type} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.dataarr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        self.tableview.estimatedRowHeight = 120;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBBelowTheLineListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBBelowTheLineListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderCodeLb.text = [NSString stringWithFormat:@"订  单  号: %@",self.dataarr[indexPath.row][@"order_num"]];
    cell.numLb.text = [NSString stringWithFormat:@"商品数量: %@",self.dataarr[indexPath.row][@"goods_total"]];
    cell.moenyLb.text = [NSString stringWithFormat:@"¥%@",self.dataarr[indexPath.row][@"line_money"]];
    cell.modelLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"rlmodel_type"]];
   
    if ([self.dataarr[indexPath.row][@"order_status"] integerValue] == 0) {
        cell.status.text = @"审核状态: 已拒绝";
        cell.reason.text = [NSString stringWithFormat:@"失败原因: %@",self.dataarr[indexPath.row][@"fail_reason"]];
        cell.reason.hidden = NO;
        cell.top.constant = 5;
    }else  if ([self.dataarr[indexPath.row][@"order_status"] integerValue] == 1){
        cell.status.text = @"审核状态: 已完成";
         cell.reason.hidden = YES;
        cell.reason.text =  @"";
        cell.top.constant = 0;
    }else  if ([self.dataarr[indexPath.row][@"order_status"] integerValue] == 2){
        cell.status.text = @"审核状态: 待提交";
         cell.reason.hidden = YES;
         cell.reason.text =  @"";
        cell.top.constant = 0;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
//帅选
-(void)chooseevent{

    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:@[@{@"title":@"已拒绝",@"imageName":@""},
                                                                  @{@"title":@"已完成",@"imageName":@""},
                                                                  @{@"title":@"待提交",@"imageName":@""},
                                                                  @{@"title":@"全部",@"imageName":@""}]
                        
                                                              width:100
                                                   triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
                                                            action:^(NSInteger index) {
                                                                
                                                                weakself.type = [NSString stringWithFormat:@"%ld",(long)index];
                                                                
                                                                _refreshType = NO;
                                                                _page=1;
                                                                
                                                                [weakself initdatasource];
                                                                
                                                               }];
    
    popview.isHideImage = YES;
    
    [popview show];

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
