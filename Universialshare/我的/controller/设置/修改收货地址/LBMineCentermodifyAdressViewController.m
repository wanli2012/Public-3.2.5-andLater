//
//  LBMineCentermodifyAdressViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCentermodifyAdressViewController.h"
#import "LBMineCentermodifyAdressTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/NSObject+RACKVOWrapper.h>
#import "LBMineCenterAddAdreassViewController.h"

#import "GLConfirmOrderController.h"

@interface LBMineCentermodifyAdressViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)UIButton *rightBt;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger  deleteIndex;//删除下标

@end

@implementation LBMineCentermodifyAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"收货地址";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page = 1;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.estimatedRowHeight = 105;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCentermodifyAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCentermodifyAdressTableViewCell"];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:self.rightBt];
    
    self.navigationItem.rightBarButtonItem = ba;
    
    [self initdatasource];//加载数据
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReceivingAddress) name:@"refreshReceivingAddress" object:nil];
    
}

-(void)refreshReceivingAddress{
    [self initdatasource];

}
//请求数据
-(void)initdatasource{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/address_list" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" : [NSNumber numberWithInteger:self.page]} finish:^(id responseObject) {
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
    
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCentermodifyAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCentermodifyAdressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"collect_name"]];
//    cell.phoneLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"s_phone"]];
    cell.phoneLb.text = [NSString stringWithFormat:@"%@*****%@",[self.dataarr[indexPath.row][@"s_phone"] substringToIndex:3],[self.dataarr[indexPath.row][@"s_phone"] substringFromIndex:7]];
    cell.adressLn.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"s_address"]];
    cell.address_id = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"address_id"]];
    if ([self.dataarr[indexPath.row][@"is_default"] integerValue] == 1) {
        [cell.setupBt setImage:[UIImage imageNamed:@"支付选中"] forState:UIControlStateNormal];
    }else{
        [cell.setupBt setImage:[UIImage imageNamed:@"支付未选中"] forState:UIControlStateNormal];
    }
    cell.index = indexPath.row;
    __weak typeof(self) weakself=self;
    cell.returnSetUpbt = ^(NSInteger index){
    
        [weakself setupDefaultSelect:index];
        
    };
    
    cell.returnEditbt = ^(NSInteger index){
        weakself.hidesBottomBarWhenPushed = YES;
        LBMineCenterAddAdreassViewController *vc=[[LBMineCenterAddAdreassViewController alloc]init];
        vc.isEdit = YES;
        vc.dataDic = _dataarr[index];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    cell.returnDeletebt = ^(NSInteger index){
        
        self.deleteIndex = index;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除地址吗?" delegate:weakself cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    };
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCentermodifyAdressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *vcsArray = [self.navigationController viewControllers];
    NSInteger vcCount = vcsArray.count;
    UIViewController *lastVC = vcsArray[vcCount-2];//最后一个vc是自己，倒数第二个是上一个控制器。

    if([lastVC isKindOfClass:[GLConfirmOrderController class]]){
    
        self.block(cell.nameLb.text,cell.phoneLb.text,cell.adressLn.text,cell.address_id);
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//添加地址
-(void)addAdressEvent{

    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterAddAdreassViewController *vc=[[LBMineCenterAddAdreassViewController alloc]init];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];


}
//设为默认
-(void)setupDefaultSelect:(NSInteger)index{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/setDefaultAddress" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"address_id" : self.dataarr[index][@"address_id"]} finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            [self initdatasource];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    //确定
    if (buttonIndex == 1) {
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/delAddress" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"address_id" : self.dataarr[self.deleteIndex][@"address_id"]} finish:^(id responseObject) {
            [_loadV removeloadview];
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
            if ([responseObject[@"code"] integerValue]==1) {
               [MBProgressHUD showError:responseObject[@"message"]];
                [self.dataarr removeObjectAtIndex:self.deleteIndex];
                [self.tableview reloadData];
                
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

}

-(UIButton*)rightBt{

    if (!_rightBt) {
        _rightBt=[UIButton buttonWithType:UIButtonTypeContactAdd];
        _rightBt.frame = CGRectMake(0, 0, 30, 30);
        _rightBt.backgroundColor=[UIColor clearColor];
        [_rightBt addTarget:self action:@selector(addAdressEvent) forControlEvents:UIControlEventTouchUpInside];
        [_rightBt setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    }
    
    return _rightBt;

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
