//
//  GLRecommendBeansController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendBeansController.h"

#import "GLRecommendModel.h"
#import "GLRecommendCell.h"

@interface GLRecommendBeansController ()<UITableViewDelegate,UITableViewDataSource>
{

//    NSMutableArray *_return_timeArr;
//    NSMutableArray *_returnamountArr;
    LoadWaitView *_loadV;
    float _beanSum;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *models;


@end
static NSString *ID = @"GLRecommendCell";
@implementation GLRecommendBeansController

-(UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-154)];
        
           }
    return _tableView;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLRecommendCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/rec_list" paramDic:dict finish:^(id responseObject) {
       
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                GLRecommendModel *model = [GLRecommendModel mj_objectWithKeyValues:dict];
                
                [_models addObject:model];
            }
            
            _beanSum = [responseObject[@"sum"] floatValue];
            
        }else if([responseObject[@"code"] integerValue] == 3){
            if (_models.count != 0) {
                
                [MBProgressHUD showError:@"已经没有更多数据了"];
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
             _beanSum = [responseObject[@"sum"] floatValue];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
       
        
        //赋值
        if (self.retureValue) {
            if (_beanSum > 10000) {
                
                self.retureValue([NSString stringWithFormat:@"%.2f万",_beanSum/10000]);
            }else{
                
                self.retureValue([NSString stringWithFormat:@"%.2f",_beanSum]);
            }
        }
        _beanSum = 0;
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        //赋值
        if (self.retureValue) {
            self.retureValue(@"0");
        }
        
        [_loadV removeloadview];
        [self endRefresh];
        self.nodataV.hidden = NO;
    }];
}

#pragma  UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * autoSizeScaleY;
}


@end
