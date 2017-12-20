//
//  LBMyBusinessListDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyBusinessListDetailViewController.h"
#import "LBMyBusinessListDetailTableViewCell.h"


@interface LBMyBusinessListDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *backtitle;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UILabel *rangliLb;
@property (weak, nonatomic) IBOutlet UIImageView *lineimage;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@end

@implementation LBMyBusinessListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [UIView new];
    _page = 0;
    _dataarr=[NSMutableArray array];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMyBusinessListDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMyBusinessListDetailTableViewCell"];
    
    [self initdatasorce];//请求数据
    
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

-(void)initdatasorce{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/dealer" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":self.dic[@"dealer_id"]} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         if ([responseObject[@"code"] integerValue]==1) {
             self.numlb.text = [NSString stringWithFormat:@"%@",responseObject[@"sum"]];
             if ([self.numlb.text rangeOfString:@"null"].location != NSNotFound) {
                 self.numlb.text = @"0元";
             }
             if (_refreshType == NO) {
                 [self.dataarr removeAllObjects];
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
             }else{
                 
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataarr addObjectsFromArray:responseObject[@"data"]];
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
    
    [self initdatasorce];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasorce];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.navigationController.navigationBar.hidden = YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LBMyBusinessListDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyBusinessListDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@""]]] placeholderImage:[UIImage imageNamed:@""]];
    cell.namelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"dealer_name"]];
    cell.usernamelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"dealer_num"]];
    cell.useridlb.text = [NSString stringWithFormat:@"X%@",self.dataarr[indexPath.row][@"dealer_addtime"]];
    cell.moneylb.text = [NSString stringWithFormat:@"¥%@",self.dataarr[indexPath.row][@"dealer_money"]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


- (IBAction)backbutton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
