//
//  LBMineCenterUsualUnderOrderThreeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterUsualUnderOrderThreeViewController.h"
#import "LBMineCenterUsualUnderOrderTableViewCell.h"

@interface LBMineCenterUsualUnderOrderThreeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation LBMineCenterUsualUnderOrderThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableview addSubview:self.nodataV];
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterUsualUnderOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterUsualUnderOrderTableViewCell"];
    
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

-(void)initdatasource{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"page"] = [NSNumber numberWithInteger:_page];
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @2;
   
    dic[@"typeID"] = [UserModel defaultUser].usrtype;
    

    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/order_line" paramDic:dic finish:^(id responseObject) {
        
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
            
            [MBProgressHUD showError:@"没有更多数据"];
            
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.dataarr.count > 0) {
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
    }
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 140;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterUsualUnderOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterUsualUnderOrderTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.orderCode.text = [NSString stringWithFormat:@"订单号:%@",self.dataarr[indexPath.row][@"order_num"]];
    cell.name.text = [NSString stringWithFormat:@"名称:%@",self.dataarr[indexPath.row][@"goods_name"]];
    cell.momey.text = [NSString stringWithFormat:@"订单金额:¥%@元",self.dataarr[indexPath.row][@"line_money"]];
    cell.mode.text = [NSString stringWithFormat:@"奖励比例:%@",self.dataarr[indexPath.row][@"bili"]];
    cell.time.text = [NSString stringWithFormat:@"下单时间:%@",self.dataarr[indexPath.row][@"addtime"]];
       
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
