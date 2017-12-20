//
//  LBTurnoutRewardRecoderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBTurnoutRewardRecoderViewController.h"
#import "LBTurnoutRewardRecoderTableViewCell.h"

@interface LBTurnoutRewardRecoderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *miquanLb;
@property (weak, nonatomic) IBOutlet UILabel *miziLb;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBTurnoutRewardRecoderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBTurnoutRewardRecoderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBTurnoutRewardRecoderTableViewCell"];
    CGFloat headerH = (SCREEN_WIDTH - 60)/2.0*(1/1.44) + 42;
    self.tableview.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerH);
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
    [NetworkManager requestPOSTWithURLStr:@"Meeple/reward" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        self.miquanLb.text = [NSString stringWithFormat:@"%@",responseObject[@"mark"]];
        self.miziLb.text = [NSString stringWithFormat:@"%@",responseObject[@"meeple"]];
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
    
    if (indexPath.section == 0) {
        LBTurnoutRewardRecoderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBTurnoutRewardRecoderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.meeboLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"amount"]];
        cell.miquanLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"voucher"]];
        cell.allMeebo.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"money"]];
        cell.allmiquan.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"mark"]];
         cell.timelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"addtime"]];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
    
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
