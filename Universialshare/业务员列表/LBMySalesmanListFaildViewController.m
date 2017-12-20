//
//  LBMySalesmanListFaildViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListFaildViewController.h"
#import "LBMySalesmanListTableViewCell.h"
#import "LBMySalesmanListDeatilViewController.h"
#import "LBSaleManPersonInfoViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LBSavaTypeModel.h"

@interface LBMySalesmanListFaildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, copy)NSString *type;//1:推广员  2:高级推广员

@end

@implementation LBMySalesmanListFaildViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMySalesmanListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMySalesmanListTableViewCell"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(filterExtensionCategories:) name:@"filterExtensionCategories" object:nil];
    
    //获取数据
    [self.tableview addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
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
    
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
    [self updateData:YES];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"status"] = @3;// 1通过 2审核中 3失败
    dict[@"type"] = [LBSavaTypeModel defaultUser].type;
    dict[@"page"] = @(self.page);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/get_tg_list" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMySalesmanModel *model = [GLMySalesmanModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        if (self.models.count <= 0 ) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
- (void)endRefresh {
    
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    
}

//筛选
-(void)filterExtensionCategories:(NSNotification*)notification{
    
    [self updateData:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[LBSavaTypeModel defaultUser].type isEqualToString:@"1"]) {

        return 100;
    }
    return 130;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMySalesmanListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMySalesmanListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.typestr = [LBSavaTypeModel defaultUser].type;
    cell.model = self.models[indexPath.row];
        
    //    __weak typeof(self) weakself =self;
    //    cell.returntapgestureimage = ^(NSInteger index){
    //
    //        //        if (weakself.returnpushinfovc) {
    //        //            weakself.returnpushinfovc(index);
    //        //        }
    //
    //    };
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.returnpushvc) {
        //self.returnpushvc(self.dataarr[indexPath.row]);
    }
    
}

-(NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
    
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}
@end
