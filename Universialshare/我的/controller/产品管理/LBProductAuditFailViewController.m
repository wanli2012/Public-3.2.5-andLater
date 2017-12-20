//
//  LBProductAuditFailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductAuditFailViewController.h"
#import "LBProductManagementTableViewCell.h"
#import "UIHelper.h"
#import "SUPopupMenu.h"
#import "LBmodifyMineProductionViewController.h"

@interface LBProductAuditFailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SUDropMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic)SUPopupMenu *popupView;
@property (assign, nonatomic)NSInteger currentIndex;//被选cell
@property (assign, nonatomic)CGPoint point;

@end

@implementation LBProductAuditFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBProductManagementTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBProductManagementTableViewCell"];
    [self.tableview addSubview:self.nodataV];
    
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
    
    self.page = 1;
    [self initdatasource];
}
-(void)initdatasource{
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getStoreGoodsList" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page],@"type":@"1"} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
            
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count > 0) {
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
    }
    
    return self.dataarr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 120;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBProductManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBProductManagementTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rowIndex = indexPath.row;
    
    if ([self.dataarr[indexPath.row][@"type"]integerValue] == 1) {
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 20%%"];
    }else if ([self.dataarr[indexPath.row][@"type"]integerValue] == 2){
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 10%%"];
    }else if ([self.dataarr[indexPath.row][@"type"]integerValue] == 3){
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 5%%"];
    }else if([self.dataarr[indexPath.row][@"type"]integerValue] == [KThreePersent integerValue]){
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 3%%"];
    }
    
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"熊"] options:SDWebImageAllowInvalidSSLCertificates] ;
    
    cell.productNameLb.text = [NSString stringWithFormat:@"商品名称:%@",self.dataarr[indexPath.row][@"name"]];
    cell.numLb.text = [NSString stringWithFormat:@"商品数量:%@",self.dataarr[indexPath.row][@"num"]];
    cell.moneyLb.text = [NSString stringWithFormat:@"商品价格:¥%@",self.dataarr[indexPath.row][@"price"]];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    CGRect rect = [tableView convertRect:rectInTableView toView:[UIApplication sharedApplication].keyWindow];
    
    self.point = CGPointMake(SCREEN_WIDTH/2.0, rect.origin.y + 30);
    
    [self.popupView presentWithAnchorPoint: self.point];
    
    self.currentIndex = indexPath.row;
    
}

-(void)dropMenuDidTappedAtIndex:(NSInteger)index{

    switch (index) {
        case 0:
            [self  modifyProduct];//修改商品
            break;
        case 1:
            [self  deleteProduct];//删除商品
            break;
//        case 2:
//            [self  auditFailSeaion];//失败原因
//            break;
            
        default:
            break;
    }

}

-(void)modifyProduct{
    self.hidesBottomBarWhenPushed = YES;
    LBmodifyMineProductionViewController *vc=[[LBmodifyMineProductionViewController alloc]init];
    vc.datadic = self.dataarr[self.currentIndex];
    vc.refreshData = ^(){
        [_dataarr removeObjectAtIndex:self.currentIndex];
        [_tableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)auditFailSeaion{
//     SUPopupMenu   *popupView = [[SUPopupMenu alloc] initWithContents: @"明月几时有 把酒问青天 不知天上宫阙 今夕是何年 明月几时有 把酒问青天 不知天上宫阙 今夕是何年 明月几时有 把酒问青天 不知天上宫阙 今夕是何年 明月几时有 把酒问青天 不知天上宫阙 今夕是何年明月几时有 把酒问青天 不知天上宫阙 今夕是何年" maxWidth: SCREEN_WIDTH - 40];
//
//     [popupView presentWithAnchorPoint: self.point];
    
}

-(void)deleteProduct{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/setStoreGoods" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"goods_id" :self.dataarr[self.currentIndex][@"goods_id"],@"status" :@"1"} finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.dataarr removeObjectAtIndex:self.currentIndex];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
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

-(SUPopupMenu*)popupView{
    
    if (!_popupView) {
        _popupView = [[SUPopupMenu alloc] initWithTitles: @[@"修改商品",@"删除商品"] icons: nil menuItemSize:CGSizeMake(110, 44)];
        _popupView.delegate = self;
    }
    
    return _popupView;
    
}


@end
