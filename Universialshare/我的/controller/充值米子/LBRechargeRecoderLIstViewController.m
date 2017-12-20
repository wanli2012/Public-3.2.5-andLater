//
//  LBRechargeRecoderLIstViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRechargeRecoderLIstViewController.h"
#import "LBRechargeableRiceTableViewCell.h"

@interface LBRechargeRecoderLIstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@end

@implementation LBRechargeRecoderLIstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"充值记录";
    self.view.backgroundColor =[UIColor whiteColor];
    self.tableview.tableFooterView = [UIView new];
      [self.tableview addSubview:self.nodataV];
     [self.tableview registerNib:[UINib nibWithNibName:@"LBRechargeableRiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBRechargeableRiceTableViewCell"];
     _page=1;
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
    [NetworkManager requestPOSTWithURLStr:@"User/getRechargeLog" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if ([responseObject[@"data"] count] > 0) {
                if (_refreshType == NO) {
                    [self.dataarr removeAllObjects];
                    [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                    [self.tableview reloadData];
                }else{
                    
                    [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                    [self.tableview reloadData];
                }
            }
            
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
    
    
    return 70;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBRechargeableRiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBRechargeableRiceTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recharge_number.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"recharge_number"]];
    cell.addtime.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"addtime"]];
    cell.recharge_money.text = [NSString stringWithFormat:@"¥%@",self.dataarr[indexPath.row][@"recharge_money"]];
    cell.recharge_remodel.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"recharge_remodel"]];
  
    
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
