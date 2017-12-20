//
//  GLMyHeartUnderLineRecoderController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyHeartUnderLineRecoderController.h"
#import "GLMine_MyHeartRecoderCell.h"
#import "GLMyheartRl_typeModel.h"

@interface GLMyHeartUnderLineRecoderController ()<UITableViewDataSource,UITableViewDelegate>
{
    LoadWaitView *_loadV;
}
@property (nonatomic,strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,assign)NSInteger page;

@end

static NSString *ID = @"GLMine_MyHeartRecoderCell";

@implementation GLMyHeartUnderLineRecoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GLMine_MyHeartRecoderCell" bundle:nil] forCellReuseIdentifier:ID];

    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestDataSorce:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataSorce:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    [self requestDataSorce:YES];
    
}

//请求数据
-(void)requestDataSorce:(BOOL)status{
    
    if (status) {
        _page = 1;
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"type"] = @(2);//表示线下2 线上1
    dict[@"page"] = @(_page);
    dict[@"rl_type"] = @([GLMyheartRl_typeModel defaultUser].rl_type) ;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getMarkLogList" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            if (status) {
                [self.models removeAllObjects];
            }
            if ([responseObject[@"data"] count] > 0) {
                [self.models addObjectsFromArray:responseObject[@"data"]];
            }
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    } enError:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

#pragma  UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_MyHeartRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.consumptionLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"order_money"]];
    cell.rebateLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"mark"]];
    cell.timeLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"addtime"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(NSMutableArray*)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
    
}
@end
