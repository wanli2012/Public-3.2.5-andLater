//
//  LBMineSystemMessageViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineSystemMessageViewController.h"
#import "LBMineSystemMessageTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "QQPopMenuView.h"

@interface LBMineSystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (assign, nonatomic)NSInteger messageType;//消息类型 默认为1
@property (strong, nonatomic)NSMutableArray *messageArr;
@property (strong, nonatomic)UIButton *buttonedt;
@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic)NSMutableArray *typeArr;

//@property (nonatomic, strong)NSDictionary *msgDic;//未读消息
@property (nonatomic, strong)NSMutableArray *hongDianArr;//小红点数组

@end

@implementation LBMineSystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setRedPoint];
     _page=1;
     self.navigationItem.title = self.typeArr[0][@"title"];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.messageType = 1;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.estimatedRowHeight = 70;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineSystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineSystemMessageTableViewCell"];
    //获取数据
    [self initdatasource];
    [self.tableview addSubview:self.nodataV];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"分类" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
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

- (void)setRedPoint{
    
    self.hongDianArr = [NSMutableArray array];
    
    for (int i = 0; i < 7; i ++) {
        [self.hongDianArr addObject:@""];
    }

    if ([self.msgDic[@"back"] integerValue] != 0) {//兑换
        [self.hongDianArr replaceObjectAtIndex:0 withObject:@"小红点"];

    }else if([self.msgDic[@"bonus_log"] integerValue] != 0){//奖金
        [self.hongDianArr replaceObjectAtIndex:1 withObject:@"小红点"];
        
    }else if([self.msgDic[@"log"] integerValue] != 0){//推荐
        [self.hongDianArr replaceObjectAtIndex:2 withObject:@"小红点"];
        
    }else if([self.msgDic[@"order_line"] integerValue] != 0){//订单
        [self.hongDianArr replaceObjectAtIndex:3 withObject:@"小红点"];
        
    }else if([self.msgDic[@"give"] integerValue] != 0){//转赠
        [self.hongDianArr replaceObjectAtIndex:4 withObject:@"小红点"];
        
    }else if([self.msgDic[@"logtd"] integerValue] != 0){//团队
        [self.hongDianArr replaceObjectAtIndex:5 withObject:@"小红点"];
        
    }else if([self.msgDic[@"system_message"] integerValue] != 0 ||  [self.msgDic[@"push_log"] integerValue] != 0){//系统
        [self.hongDianArr replaceObjectAtIndex:6 withObject:@"小红点"];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)initdatasource{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/msg_list" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token ,@"type":[NSNumber numberWithInteger:self.messageType]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
           
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
                
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                [self.tableview reloadData];
            }else{
                
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                [self.tableview reloadData];
            }
            
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

//消息变为已读
- (void)readMsg{
    
    for (int i = 0; i < 7; i ++) {
        [self.hongDianArr replaceObjectAtIndex:i withObject:@""];
    }

    
    [NetworkManager requestPOSTWithURLStr:@"User/user_msg_read" paramDic:@{ @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token} finish:^(id responseObject) {
        [_loadV removeloadview];
        
    } enError:^(NSError *error) {
        
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
//筛选
-(void)edtingInfo{

    __weak typeof(self) weakself = self;
    
    QQPopMenuView *popview = [[QQPopMenuView alloc] initWithItems:self.typeArr
                              
                                                           width:130
                                                triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
                                                          action:^(NSInteger index) {
                                                              
                                                              weakself.refreshType = NO;
                                                              weakself.page=1;
                                                              if (index >= 5) {
                                                                  weakself.messageType = index + 2;
                                                              }else{
                                                                  weakself.messageType = index + 1;
                                                              }
                                                              weakself.navigationItem.title = weakself.typeArr[index][@"title"];
                                                              if ([weakself.hongDianArr[index] isEqualToString:@"小红点"]) {
                                                                  weakself.typeArr = nil;
                                                                  [weakself readMsg];
                                                                  popview.tableData = self.typeArr;
                                                                  [popview.tableView reloadData];
                                                              }
                                                              [weakself initdatasource];
                                                              
                                                          }];
    
        popview.isHideImage = NO;
    
    [popview show];

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
    
    
    
        LBMineSystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineSystemMessageTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.contentlb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"content"]];
    cell.timelb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"time"]];
    
       cell.titlelb.text=self.messageArr[self.messageType - 1];
        
        return cell;
   
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

-(NSMutableArray*)typeArr{

    if (!_typeArr) {
        _typeArr = [NSMutableArray arrayWithArray:@[@{@"title":@"兑换消息",@"imageName":self.hongDianArr[0]},
                                                    @{@"title":@"奖金消息",@"imageName":self.hongDianArr[1]},
                                                    @{@"title":@"推荐消息",@"imageName":self.hongDianArr[2]},
                                                    @{@"title":@"下单消息",@"imageName":self.hongDianArr[3]},
                                                    @{@"title":@"转赠消息",@"imageName":self.hongDianArr[4]},
                                                    @{@"title":@"团队消息",@"imageName":self.hongDianArr[5]},
                                                    @{@"title":@"系统消息",@"imageName":self.hongDianArr[6]},
                                                    ]];
    }

    return _typeArr;
}
@end
