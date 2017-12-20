//
//  GLMemberManagerController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMemberManagerController.h"
#import "GLMemberManagerCell.h"
#import "GLConsumerRecordController.h"
#import "GLMemberModel.h"

@interface GLMemberManagerController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *_dict1 ;
    NSDictionary *_dict2 ;
    NSDictionary *_dict3 ;
    NSDictionary *_dict4 ;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic)UIButton *currentbutton;//当前按钮

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)NSInteger pageone;//页数默认为1
@property (assign, nonatomic)NSInteger currentPage;//当前页数
@property (assign, nonatomic)NSInteger type;//1:锁定会员  2平台会员

//@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (nonatomic, strong)NSMutableArray *models;//锁定会员数据
@property (nonatomic, strong)NSMutableArray *modelsone;//平台会员数据
@property (strong, nonatomic)NodataView *nodataV;

@end

static NSString *ID = @"GLMemberManagerCell";

@implementation GLMemberManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员管理";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page = 1;
    self.pageone = 1;
    self.type = 1;
    [self setupConst];
    self.currentbutton = self.leftBtn;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMemberManagerCell" bundle:nil] forCellReuseIdentifier:ID];
    
    __weak __typeof(self) weakSelf = self;
    //获取数据
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self updateData:YES];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        if (self.type == 1) {
            
            [self.models removeAllObjects];
        }else{
            [self.modelsone removeAllObjects];
        }
        
    }else{
        _page ++;
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"type"] = [NSNumber numberWithInteger:self.type];
    dict[@"page"] = @(self.page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getTjUserList" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];

        if ([responseObject[@"code"] integerValue] == 1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMemberModel *model = [GLMemberModel mj_objectWithKeyValues:dic];
                    if (self.type == 1) {
                        
                        [self.models addObject:model];
                    }else{
                        [self.modelsone addObject:model];
                    }
                }
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
        if (self.type == 1 ) {
            if (self.models.count <= 0) {
                self.nodataV.hidden = NO;
            }else{
                self.nodataV.hidden = YES;
            }
        }else{
            if (self.modelsone.count <= 0) {
                self.nodataV.hidden = NO;
            }else{
                self.nodataV.hidden = YES;
            }
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)typeChoose:(UIButton *)sender {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (sender == self.leftBtn) {

        self.type = 1;
        [self.leftBtn setTitleColor:YYSRGBColor(26, 183, 58, 1) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }else{

        self.type = 2;
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:YYSRGBColor(26, 183, 58, 1) forState:UIControlStateNormal];

    }
    [self updateData:YES];

}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.type == 1?self.models.count:self.modelsone.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMemberManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    
    if (self.type == 1) {
        
        cell.model = self.models[indexPath.row];
    }else{
        
        cell.model = self.modelsone[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLConsumerRecordController *consumerVC = [[GLConsumerRecordController alloc] init];
    
    
    if (self.type == 1) {
        
        GLMemberModel *model = self.models[indexPath.row];
        consumerVC.uid = model.uid;
        consumerVC.dataArray = @[_dict2,_dict4,_dict1,_dict3];
        consumerVC.usertype = self.type;
    }else{
        
        GLMemberModel *model = self.modelsone[indexPath.row];
        consumerVC.uid = model.uid;
        consumerVC.dataArray = @[_dict2,_dict4];
        consumerVC.usertype = self.type;
    }
    
    [self.navigationController pushViewController:consumerVC animated:YES];
}

//筛选选项
- (void)setupConst {
    
    _dict1 = @{@"imageName" : @"",
               @"itemName" : @"线上他店"
               };
    _dict2 = @{@"imageName" : @"",
               @"itemName" : @"线上本店"
               };
    _dict3 = @{@"imageName" : @"",
               @"itemName" : @"线下他店"
               };
    _dict4 = @{@"imageName" : @"",
               @"itemName" : @"线下本店"
               };
    
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}

- (NSMutableArray *)modelsone{
    if (!_modelsone) {
        _modelsone = [NSMutableArray array];
        
    }
    return _modelsone;
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
@end
