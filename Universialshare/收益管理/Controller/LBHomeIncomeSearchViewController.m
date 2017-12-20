//
//  LBHomeIncomeSearchViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeIncomeSearchViewController.h"
#import "GLIncomeManagerCell.h"
#import "GLMerchant_IncomeCell.h"
#import "GLTeam_IncomeCell.h"
#import "GLMember_IncomeCell.h"
#import "GLintegralGoodsModel.h"

@interface LBHomeIncomeSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView * _loadV;
}
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

static NSString *ID1 = @"GLIncomeManagerCell";//推荐奖励
static NSString *ID2 = @"GLMerchant_IncomeCell";//线上线下
static NSString *ID3 = @"GLTeam_IncomeCell";//商户
static NSString *ID4 = @"GLMember_IncomeCell";//团队

@implementation LBHomeIncomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableview registerNib:[UINib nibWithNibName:ID1 bundle:nil] forCellReuseIdentifier:ID1];
    [self.tableview registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellReuseIdentifier:ID2];
    [self.tableview registerNib:[UINib nibWithNibName:ID3 bundle:nil] forCellReuseIdentifier:ID3];
    [self.tableview registerNib:[UINib nibWithNibName:ID4 bundle:nil] forCellReuseIdentifier:ID4];
    
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
    
}

//发送请求
- (void)updateData:(BOOL)status {
    if (status) {

        self.page = 1;
        
    }else{
        _page ++;
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = [NSString stringWithFormat:@"%zd",_page];
    dict[@"typer"] = [NSString stringWithFormat:@"%zd",_typer];
    dict[@"content"] = [NSString stringWithFormat:@"%@",self.searchTF.text];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/searchByType" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            if (status) {
                
                [self.models removeAllObjects];
            }
            
            [self.dataArr addObjectsFromArray:responseObject[@"data"]];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                if ([dict[@"typer"] integerValue] == 1) {
                    GLIncomeRecommendModel *model = [GLIncomeRecommendModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }else if ([dict[@"typer"] integerValue] == 2){
                    GLIncomeRecommendModel *model = [GLIncomeRecommendModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }else if ([dict[@"typer"] integerValue] == 3){
                    GLIncomeManagerModel *model = [GLIncomeManagerModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }else if ([dict[@"typer"] integerValue] == 4){
                    GLIncomeManagerModel *model = [GLIncomeManagerModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }else if ([dict[@"typer"] integerValue] == 5){
                    GLIncomeBusinessModel *model = [GLIncomeBusinessModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }else if ([dict[@"typer"] integerValue] == 6){
                    GLIncomeBusinessModel *model = [GLIncomeBusinessModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
                
            }
            
            [self.tableview reloadData];
        }else if ([responseObject[@"code"] integerValue] == 3){
            [self.view makeToast:responseObject[@"message"] duration:2.0 position:CSToastPositionCenter];
        }else {
            if (status) {
                [self.models removeAllObjects];
            }
            [self.view makeToast:responseObject[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
        [self.tableview reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
    
}

#pragma mark ---- UITableViewDelegate,UITableViewDataSource

#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 1) {
        GLIncomeManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.models[indexPath.row];
        return cell;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 2){
        GLIncomeManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model1 = self.models[indexPath.row];
        return cell;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 3){
        GLMerchant_IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.models[indexPath.row];
        return cell;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 4){
        GLMerchant_IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.models[indexPath.row];
        return cell;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 5){
        GLTeam_IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID3 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.models[indexPath.row];
        return cell;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 6){
        GLMember_IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID4 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.models[indexPath.row];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 1) {
         return 112;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 2){
         return 112;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 3){
         return 130;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 4){
         return 130;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 5){
        return 170;
    }else if ([self.dataArr[indexPath.row][@"typer"] integerValue] == 6){
         return 130;
    }
    return 0;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    if (textField.text.length <= 0) {
        [self.view makeToast:@"请输入关键字" duration:2 position:CSToastPositionCenter];
        return NO;
    }
    [self updateData:YES];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.searchTF becomeFirstResponder];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.searchTF resignFirstResponder];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
- (void)endRefresh {
    
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    
}

- (IBAction)cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
