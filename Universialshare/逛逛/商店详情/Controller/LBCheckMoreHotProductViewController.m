//
//  LBCheckMoreHotProductViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBCheckMoreHotProductViewController.h"
#import "LBStoreDetailHotProductTableViewCell.h"

#import "LBStoreProductDetailInfoViewController.h"

@interface LBCheckMoreHotProductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@end

static NSString *ID = @"LBStoreDetailHotProductTableViewCell";
@implementation LBCheckMoreHotProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"商品列表";
    
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    _page = 1;
    [self initdatasource];
    
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

}
- (void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/UsergetStoreGoodsList" paramDic:@{@"shop_id":self.storeId,@"page":[NSNumber numberWithInteger:_page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.models removeAllObjects];
                if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                    [self.models addObjectsFromArray:responseObject[@"data"]];
                }
                
                [self.tableview reloadData];
            }else{
                
                if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                    [self.models addObjectsFromArray:responseObject[@"data"]];
                }
                
                [self.tableview reloadData];
                
            }
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
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
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBStoreDetailHotProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailHotProductTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.models[indexPath.row][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"planceholder"] options:SDWebImageAllowInvalidSSLCertificates];
     cell.nameLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"name"]];
     cell.moneyLb.text = [NSString stringWithFormat:@"¥%@",self.models[indexPath.row][@"price"]];
     cell.descrebLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"goods_info"]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.hidesBottomBarWhenPushed = YES;
    LBStoreProductDetailInfoViewController *vc=[[LBStoreProductDetailInfoViewController alloc]init];
    vc.goodname = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"name"]];
    vc.storename = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"shop_name"]];
    vc.goodId = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"goods_id"]];
    [self.navigationController pushViewController:vc animated:YES];

}

-(NSMutableArray*)models{
    if (!_models) {
        _models=[NSMutableArray array];
    }
    return _models;
}



@end
