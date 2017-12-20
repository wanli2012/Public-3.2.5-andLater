//
//  GLRecommendStroe_RecordController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStroe_RecordController.h"
#import "GLRecommendStore_RecordCell.h"
#import "GLRecommendStroe_RecordDateCell.h"
#import "formattime.h"
#import "JXAlertview.h"
#import "CustomDatePicker.h"


@interface GLRecommendStroe_RecordController ()<CustomAlertDelegete>
{
    CustomDatePicker *_Dpicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@property(strong , nonatomic)NSString *date_time;

@end

static NSString *ID = @"GLRecommendStore_RecordCell";
//static NSString *ID2 = @"GLRecommendStroe_RecordDateCell";
@implementation GLRecommendStroe_RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queryBtn.layer.cornerRadius = 5.f;
    self.page = 1;
    self.refreshType = NO;
    self.date_time = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"推店记录";
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView addSubview:self.nodataV];
    
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
    
    [self initdatasource];

}

-(void)initdatasource{
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getPushStoreList" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page] ,@"date_time":self.date_time} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
        
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];

            }
            
            [self.tableView reloadData];
            
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
- (IBAction)monthChoose:(id)sender {
    
    //闰年非闰年都做了判断 年份取得是当前年份的前后三十年，大家也可自行按照自己需求自行修改
    _Dpicker = [[CustomDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width-20, 200)];
    JXAlertview *alert = [[JXAlertview alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height-260)/2, self.view.frame.size.width-20, 260)];

    alert.delegate = self;
    [alert initwithtitle:@"请选择年月" andmessage:@"" andcancelbtn:@"取消" andotherbtn:@"确定"];
    
    //我把Dpicker添加到一个弹出框上展现出来 当然大家还是可以以任何其他动画形式展现
    [alert addSubview:_Dpicker];
    [alert show];

}
-(void)btnindex:(int)index :(int)tag
{
    if (index == 2) {
        self.monthLabel.textColor = [UIColor blackColor];
        self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月",_Dpicker.year,_Dpicker.month];
        self.date_time = [NSString stringWithFormat:@"%d.%d",_Dpicker.year,_Dpicker.month];
       
    }
}

- (IBAction)query:(id)sender {
    
    _page = 1;
    _refreshType = NO;
    [self initdatasource];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.dataarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLRecommendStore_RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    
    cell.namelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"truename"]];
    cell.adresslb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"address"]];
    cell.codelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"sn_code"]];
    cell.timelb.text = [formattime formateTimeYM:self.dataarr[indexPath.row][@"addtime"]];
    
    if ([cell.codelb.text rangeOfString:@"null"].location != NSNotFound) {
        cell.codelb.text = @"";
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.estimatedRowHeight = 11;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
//    GLRecommendStore_RecordCell *consumerVC = [[GLRecommendStore_RecordCell alloc] init];
//    [self.navigationController pushViewController:consumerVC animated:YES];
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
