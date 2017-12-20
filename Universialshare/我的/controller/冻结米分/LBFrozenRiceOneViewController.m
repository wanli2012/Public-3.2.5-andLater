//
//  LBFrozenRiceOneViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFrozenRiceOneViewController.h"
#import "LBFrozenRiceTableViewCell.h"
#import "LBFrozenRiceModel.h"

@interface LBFrozenRiceOneViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView * _loadV;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *allMoenyLb;

@end

static NSString *ID = @"LBFrozenRiceTableViewCell";

@implementation LBFrozenRiceOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _refreshType = NO;
    _page=1;
    [self.tableview setTableFooterView:[UIView new]];
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    [self repustDatasource];
}

-(void)repustDatasource{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"page"] = @(_page);
    dic[@"type"] = @"1";

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getFrozenMarkList" paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == 1){
            if (_refreshType == NO) {
                [self.dataArr removeAllObjects];
            }
            self.allMoenyLb.text = [NSString stringWithFormat:@"%@",responseObject[@"active_mark"]];
            
            for (NSDictionary *dic in responseObject[@"data"]) {

                LBFrozenRiceModel *model  = [LBFrozenRiceModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }

        }else{
        
              [self.view.window makeToast:responseObject[@"message"] duration:2 position:CSToastPositionCenter];
        
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.view.window makeToast:@"请求失败" duration:2 position:CSToastPositionCenter];
        
    }];

}
//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self repustDatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self repustDatasource];
}
- (void)endRefresh {
    
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
}
#pragma  UITableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBFrozenRiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

-(NSMutableArray*)dataArr{
    
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

@end
