//
//  LBMeterChangePointsRecordViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/7/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMeterChangePointsRecordViewController.h"
#import "GLBuyBackRecordCell.h"

@interface LBMeterChangePointsRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (strong, nonatomic)NodataView *nodataV;

@end

static NSString *ID = @"GLBuyBackRecordCell";
@implementation LBMeterChangePointsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    //获取数据
    [self initdatasource];
    [self.tableView addSubview:self.nodataV];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"GLBuyBackRecordCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getLcLog" paramDic:@{@"uid":[UserModel defaultUser].uid  ,@"token":[UserModel defaultUser].token ,@"page":[NSNumber numberWithInteger:_page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
                
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                
                [self.tableView reloadData];
            }else{
                
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                
                [self.tableView reloadData];
                
            }
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableView reloadData];
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    
    
    return 44 *autoSizeScaleY;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLBuyBackRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLBuyBackRecordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"addtime"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"money"]];
    
    if ([self.dataarr[indexPath.row][@"bili"]integerValue] == 1) {
        cell.beanTypeLabel.text = @"理财一";
    }else  if ([self.dataarr[indexPath.row][@"bili"]integerValue] == 2) {
        cell.beanTypeLabel.text = @"理财二";
    }else  if ([self.dataarr[indexPath.row][@"bili"]integerValue] == 3) {
        cell.beanTypeLabel.text = @"理财三";
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
