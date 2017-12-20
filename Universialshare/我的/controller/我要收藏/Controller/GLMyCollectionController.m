//
//  GLMyCollectionController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyCollectionController.h"
#import "GLMyCollectionCell.h"
#import "GLMyCollectionModel.h"
#import "LBStoreProductDetailInfoViewController.h"
#import "MXNavigationBarManager.h"
#import "GLHourseDetailController.h"

@interface GLMyCollectionController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;//页数
    LoadWaitView *_loadV;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@property (nonatomic ,strong)NodataView *nodataV;
@property (assign, nonatomic) NSInteger isdelete;//是否需要移除下标

@end

static NSString *ID = @"GLMyCollectionCell";
@implementation GLMyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我的收藏";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMyCollectionCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self.tableView addSubview:self.nodataV];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removedatasource) name:@"GLMyCollectionController" object:nil];
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
    [NetworkManager requestPOSTWithURLStr:@"Shop/myCollection_list" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];

        if ([responseObject[@"code"] integerValue] == 1) {

            for (NSDictionary *dict in responseObject[@"data"]) {
                GLMyCollectionModel *model = [GLMyCollectionModel mj_objectWithKeyValues:dict];
                [_models addObject:model];
            }
            
        }else if([responseObject[@"code"] integerValue] == 3){
            
            [MBProgressHUD showError:@"已经没有更多数据了"];
        }
    
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
        if (self.models.count <= 0) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
        }
        
        [self.tableView reloadData];

    }];
}
- (NSMutableArray *)models{
    
    if (!_models) {
        
        _models = [NSMutableArray array];
     
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    return _nodataV;
    
}
#pragma UITableViewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.models.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 10;
//    return self.tableView.rowHeight;
    return 120;
}


//左滑删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    WS(weakself);
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            
            GLMyCollectionModel *model = self.models[indexPath.row];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            if ([model.goods_type isEqualToString:@"2"]) {//米分收藏
                dict[@"GID"] = model.goodsID;
            }else{
                dict[@"GID"] = model.goodsID;
            }
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:@"Shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
                [_loadV removeloadview];
                [self endRefresh];

                if ([responseObject[@"code"] integerValue] == 1) {
                    
                    [MBProgressHUD showSuccess:responseObject[@"message"]];
                    
                    [self.models removeObjectAtIndex:indexPath.row];
                    
                }else{
                    
                    [MBProgressHUD showSuccess:responseObject[@"message"]];

                }
                [self.tableView reloadData];
        
            } enError:^(NSError *error) {
                [_loadV removeloadview];
                [MBProgressHUD showError:error.localizedDescription];
            }];

            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GLMyCollectionModel *model = self.models[indexPath.row];
    if ([model.status integerValue]==2) {
        [MBProgressHUD showError:@"该商品已下架"];
        return;
    }
    self.isdelete = indexPath.row;
    self.hidesBottomBarWhenPushed = YES;
    if ([model.goods_type isEqualToString:@"2"]) {//米分收藏
        GLHourseDetailController *vc = [[GLHourseDetailController alloc] init];
        vc.goods_id = model.goodsID;
        vc.is_notice = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LBStoreProductDetailInfoViewController *vc=[[LBStoreProductDetailInfoViewController alloc]init];
        vc.goodId = model.goodsID;
        vc.goodname = model.name;
        vc.storename = model.shop_name;
        vc.isnotice = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];

}

-(void)removedatasource{
    [self.models removeObjectAtIndex:self.isdelete];
    [self.tableView reloadData];

}

@end
