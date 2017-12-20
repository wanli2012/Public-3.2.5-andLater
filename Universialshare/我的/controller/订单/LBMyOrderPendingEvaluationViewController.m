//
//  LBMyOrderPendingEvaluationViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderPendingEvaluationViewController.h"
#import "LBMyOrderListTableViewCell.h"
#import "LBMineCenterMYOrderEvaluationDetailViewController.h"
#import <MJRefresh/MJRefresh.h>


@interface LBMyOrderPendingEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger refreshindex;//刷新下标

@end

@implementation LBMyOrderPendingEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMyOrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMyOrderListTableViewCell"];
    _page = 1;
    [self initdatasource];
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
    //评论成功刷新数据源
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshdatasource:) name:@"LBMyOrderPendingEvaluationViewController" object:nil];
}

-(void)initdatasource{
    
    //_loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getWaitingOrderCommentList" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page] } finish:^(id responseObject) {
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

            if (self.dataarr.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }

            
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataarr.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMyOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyOrderListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.payBt setTitle:@"去评价" forState:UIControlStateNormal];
    cell.stauesLb.text = @"待评价";
    cell.index = indexPath.row;
    cell.deleteBt.hidden = YES;
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"planceholder"] options:SDWebImageAllowInvalidSSLCertificates];
    cell.namelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"order_num"]];
    cell.numlb.text = [NSString stringWithFormat:@"总价:¥%@",self.dataarr[indexPath.row][@"order_money"]];
    cell.priceLb.text = [NSString stringWithFormat:@"数量:%@",self.dataarr[indexPath.row][@"total"]];
    
    __weak typeof(self)  weakself = self;
    cell.retunpaybutton = ^(NSInteger index){
        _refreshindex = index;
        LBMineCenterMYOrderEvaluationDetailViewController *vc=[[LBMineCenterMYOrderEvaluationDetailViewController alloc]init];
        vc.arr = weakself.dataarr[index][@"goods_data"];
        [weakself.navigationController pushViewController:vc animated:YES];
        
    };
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)refreshdatasource:(NSNotification*)noti{
   
    NSDictionary *dic = noti.userInfo;
    
    NSInteger row = [dic[@"row"] integerValue];

    NSMutableDictionary *dic1=[NSMutableDictionary dictionaryWithDictionary:self.dataarr[_refreshindex][@"goods_data"][row]];
    
    dic1[@"is_comment"] = @"1";
    dic1[@"mark"] = dic[@"mark"];
    dic1[@"comment"] = dic[@"comment"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataarr[_refreshindex][@"goods_data"]];
    
    [arr replaceObjectAtIndex:row withObject:dic1];
    
    NSMutableDictionary *dic2=[NSMutableDictionary dictionaryWithDictionary:self.dataarr[_refreshindex]];
    
    dic2[@"goods_data"] = arr;
    
    [self.dataarr replaceObjectAtIndex:_refreshindex withObject:dic2];
    
    [self.tableview reloadData];
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
@end
