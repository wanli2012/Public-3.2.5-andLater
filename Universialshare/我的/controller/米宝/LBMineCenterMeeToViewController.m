//
//  LBMineCenterMeeToViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/5.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMeeToViewController.h"
#import "LBMineCenterMeeToTableViewCell.h"
#import "LBMineCenterTurnoutAndTurnInViewController.h"
#import "LBTurnoutRewardRecoderViewController.h"
#import "LBMineCenterMeeToTableViewCell.h"


@interface LBMineCenterMeeToViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)UIButton *buttonedt;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (strong, nonatomic)NSMutableArray *dataarr;
@property (weak, nonatomic) IBOutlet UILabel *miquanLb;
@property (weak, nonatomic) IBOutlet UILabel *meeple;
@property (weak, nonatomic) IBOutlet UILabel *meeboPrice;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UIView *baseView;


@end

@implementation LBMineCenterMeeToViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self loadNewData];
    self.navigationController.navigationBar.hidden = NO;
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"米宝";
    self.automaticallyAdjustsScrollViewInsets = NO;
     [self.tableView registerNib:[UINib nibWithNibName:@"LBMineCenterMeeToTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMeeToTableViewCell"];
  
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
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    
}

//下拉刷新
-(void)loadNewData{
    _refreshType = NO;
    _page=1;
    [self requestDatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    [self requestDatasource];
}

-(void)requestDatasource{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"type"] = @"1";
    dic[@"page"] = @(_page);
    
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Meeple/reward" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.meeple.text = [NSString stringWithFormat:@"%@",responseObject[@"meeple"]];
        self.miquanLb.text = [NSString stringWithFormat:@"%@",responseObject[@"mark"]];
        self.meeboPrice.text = [NSString stringWithFormat:@"%@",responseObject[@"ratio"]];
        self.marketPrice.text = [NSString stringWithFormat:@"%@",responseObject[@"market"]];
      
        if ([responseObject[@"code"] integerValue]==1) {
            
                if (_refreshType == NO) {
                    [self.dataarr removeAllObjects];
                    
                }
                
                for (int i = 0; i < [responseObject[@"data"]count]; i++) {
                    LBMeeBomodel *model = [LBMeeBomodel mj_objectWithKeyValues:responseObject[@"data"][i]];
                    [self.dataarr addObject:model];
                }
            
           [self.tableView reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
         
                if (_refreshType == NO) {
                    [self.dataarr removeAllObjects];
                }
            
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];

        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}


#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
            LBMineCenterMeeToTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMeeToTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataarr[indexPath.row];
            return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}

//转出
- (IBAction)turnOutEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterTurnoutAndTurnInViewController *vc =[[LBMineCenterTurnoutAndTurnInViewController alloc]init];
    vc.type = 1;
    vc.singalPrice = [self.meeboPrice.text floatValue];
    [self.navigationController pushViewController:vc animated:YES];
}
//转入
- (IBAction)trunInEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterTurnoutAndTurnInViewController *vc =[[LBMineCenterTurnoutAndTurnInViewController alloc]init];
    vc.type = 2;
    vc.singalPrice = [self.meeboPrice.text floatValue];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)edtingInfo{
    self.hidesBottomBarWhenPushed = YES;
    LBTurnoutRewardRecoderViewController *vc =[[LBTurnoutRewardRecoderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.baseView.layer.shadowColor = TABBARTITLE_COLOR.CGColor;//shadowColor阴影颜色
    self.baseView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.baseView.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
}

@end
