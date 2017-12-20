//
//  LBTurnoutAndTurnInRecoderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBTurnoutAndTurnInRecoderViewController.h"
#import "LBTurnoutAndTurnInRecoderTableViewCell.h"

@interface LBTurnoutAndTurnInRecoderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBTurnoutAndTurnInRecoderViewController
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
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBTurnoutAndTurnInRecoderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBTurnoutAndTurnInRecoderTableViewCell"];
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
    [NetworkManager requestPOSTWithURLStr:@"Meeple/meeple_log" paramDic:dic finish:^(id responseObject) {
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
    
    if (indexPath.section == 0) {
        LBTurnoutAndTurnInRecoderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBTurnoutAndTurnInRecoderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"type"]];
         cell.timelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"addtime"]];
         cell.moneylb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"rice_num"]];
        if ([self.dataarr[indexPath.row][@"type"] integerValue] == 1) {
             cell.alllb.text = [NSString stringWithFormat:@"米宝余额: %@",self.dataarr[indexPath.row][@"balance"]];
        }else if ([self.dataarr[indexPath.row][@"type"] integerValue] == 2){
             cell.alllb.text = [NSString stringWithFormat:@"米子余额: %@",self.dataarr[indexPath.row][@"balance"]];
        }
       
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
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
