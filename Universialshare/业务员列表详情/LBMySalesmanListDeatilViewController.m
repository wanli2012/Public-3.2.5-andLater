//
//  LBMySalesmanListDeatilViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListDeatilViewController.h"
#import "LBMySalesmanListDeatilTableViewCell.h"
#import "LBMyBusinessListViewController.h"


@interface LBMySalesmanListDeatilViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *backtitle;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@end

@implementation LBMySalesmanListDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];

        self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [UIView new];
    _page = 1;
    _dataarr=[NSMutableArray array];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMySalesmanListDeatilTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMySalesmanListDeatilTableViewCell"];
    
    self.numlb.text = [NSString stringWithFormat:@"%@",self.dic[@"saleman_num"]];
    
    [self initdatasorce];//请求数据
    
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

-(void)initdatasorce{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/twoSaler" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":self.dic[@"saleman_id"]} finish:^(id responseObject)
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
    
    [self initdatasorce];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasorce];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBar.hidden = YES;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LBMySalesmanListDeatilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMySalesmanListDeatilTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.index = indexPath.row;
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"saleman_headpic"]]] placeholderImage:[UIImage imageNamed:@""]];
    cell.namelb.text = [NSString stringWithFormat:@"用户名: %@",self.dataarr[indexPath.row][@"saleman_name"]];
    cell.namelb.text = [NSString stringWithFormat:@"手机号: %@",self.dataarr[indexPath.row][@"saleman_phone"]];
    cell.namelb.text = [NSString stringWithFormat:@"地址: %@",self.dataarr[indexPath.row][@"saleman_address"]];
    cell.allMoney.text = [NSString stringWithFormat:@"销售总额: %@元",self.dataarr[indexPath.row][@"shop_mon"]];
    
    __weak typeof(self) waekself = self;
    cell.returnbusiness = ^(NSInteger index){
        waekself.hidesBottomBarWhenPushed = YES;
        LBMyBusinessListViewController *vc = [[LBMyBusinessListViewController alloc]init];
        vc.HideNavB = YES;
        [waekself.navigationController pushViewController:vc animated:YES];
    };
    cell.returnsaleman = ^(NSInteger index){
        
    };
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


- (IBAction)backEvent:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
