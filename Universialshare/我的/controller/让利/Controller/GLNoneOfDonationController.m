//
//  GLNoneOfDonationController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNoneOfDonationController.h"
#import "NodataView.h"
#import "GLNoneOfDonationCell.h"

@interface GLNoneOfDonationController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
    int _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic ,strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UILabel *rangliLabel;
@property (weak, nonatomic) IBOutlet UILabel *yirangliLabel;


@property (nonatomic ,strong)NodataView *nodataV;

@end

static NSString *ID = @"GLNoneOfDonationCell";
@implementation GLNoneOfDonationController

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
   

        
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114);
    }
    return _nodataV;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"让利捐赠";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLNoneOfDonationCell" bundle:nil] forCellReuseIdentifier:ID];
    _page = 1;
    
    _rangliLabel.text =[NSString stringWithFormat:@"应让利合计:0"];
    _yirangliLabel.text = [NSString stringWithFormat:@"已让利合计:0"];

    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [self updateData:YES];
}
- (void)endRefresh {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
}

- (void)updateData:(BOOL)status {
    
    if (status) {
        
        _page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"page"] = [NSString stringWithFormat:@"%d",_page];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/myRl_list" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                GLNoneOfDonationModel *model = [GLNoneOfDonationModel mj_objectWithKeyValues:dict];
                [_models addObject:model];
            }

            _rangliLabel.text =[NSString stringWithFormat:@"应让利合计:%@",responseObject[@"surrendersun"]];
            _yirangliLabel.text = [NSString stringWithFormat:@"已让利合计:%@",responseObject[@"surrender"]];
            
        }else if([responseObject[@"code"] integerValue] == 3){
            
            [MBProgressHUD showError:@"已经没有更多数据了"];
        }

        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        self.nodataV.hidden = NO;
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
}
#pragma  UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_models.count <= 0 ) {
        self.nodataV.hidden = NO;
        
    }else{
        self.nodataV.hidden = YES;
        
    }
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLNoneOfDonationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
