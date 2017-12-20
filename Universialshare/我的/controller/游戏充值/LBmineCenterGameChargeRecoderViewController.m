//
//  LBmineCenterGameChargeRecoderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBmineCenterGameChargeRecoderViewController.h"
#import "LBmineCenterGameChargeRecoderCell.h"

@interface LBmineCenterGameChargeRecoderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBmineCenterGameChargeRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"充值记录";
    [self.tableview registerNib:[UINib nibWithNibName:@"LBmineCenterGameChargeRecoderCell" bundle:nil] forCellReuseIdentifier:@"LBmineCenterGameChargeRecoderCell"];
   
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
//下拉刷新
-(void)loadNewData{
    _refreshType = NO;
    _page=1;
    
    [self requestDatasource];
}
//上啦刷新
-(void)footerrefresh{
    
    _refreshType = YES;
    _page++;
    
    [self requestDatasource];
}

-(void)requestDatasource{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"page"] = @(_page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/game_log" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
       
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
                
            }
            [self.dataarr addObjectsFromArray:responseObject[@"data"]];
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        LBmineCenterGameChargeRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBmineCenterGameChargeRecoderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"addtime"]];
        cell.typelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"pay_type"]];
        cell.moneylb.text = [NSString stringWithFormat:@"¥%@",self.dataarr[indexPath.row][@"recharge_money"]];
        cell.gameMoney.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"game_currency"]];
    
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}
- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
}
@end

