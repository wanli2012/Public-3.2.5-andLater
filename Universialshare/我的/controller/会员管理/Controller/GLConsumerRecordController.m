//
//  GLConsumerRecordController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLConsumerRecordController.h"
#import "GLConsumerRecordCell.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "GLMemberConsumerModel.h"

@interface GLConsumerRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalIncomeLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (strong, nonatomic)NodataView *nodataV;
@property (nonatomic,assign) BOOL flag;

@property (nonatomic, copy)NSString *type;//1线上 2线下
@property (nonatomic, copy)NSString *shop_type;//1本店 2他店

@end

static NSString *ID = @"GLConsumerRecordCell";
@implementation GLConsumerRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消费记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //右键自定义
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 44);
    [rightBtn setImage:[UIImage imageNamed:@"筛选更多"] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)
    [rightBtn addTarget:self action:@selector(filte) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLConsumerRecordCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.totalIncomeLabel.text = @"¥ ";
    self.totalIncomeLabel.layer.cornerRadius = 5.f;
 
    [self setPopMenu];
     __weak __typeof(&*self)weakSelf = self;
    //获取数据
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;

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
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    //默认
    self.type = @"0";
    self.shop_type = @"0";
    
    [self updateData:YES];
    
}
- (void)setPopMenu {
    
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectMake(0, 0, 100, 0) target:self dataArray:self.dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        weakSelf.flag = YES; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [CommonMenuView clearMenu];   // 移除菜单
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
    dict[@"userID"] = self.uid;
    dict[@"type"] = self.type;
    dict[@"shop_type"] = self.shop_type;
    dict[@"page"] = @(self.page);
    dict[@"usertype"] = [NSString stringWithFormat:@"%zd",self.usertype];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getUserConsumptionHistory" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMemberConsumerModel *model = [GLMemberConsumerModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        //总收益Label赋值
        if ([responseObject[@"total_money"] floatValue] > 10000) {
            self.totalIncomeLabel.text = [NSString stringWithFormat:@"¥ %.2f万",[responseObject[@"total_money"] floatValue] / 10000];
        }else{
            self.totalIncomeLabel.text = [NSString stringWithFormat:@"¥ %@",responseObject[@"total_money"]];
        }
        //nodata图片展示
        if (self.models.count <= 0 ) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
//筛选
- (void)filte {
     [self popMenu:CGPointMake(SCREEN_WIDTH-30, 50)];
}
- (void)popMenu:(CGPoint)point{
    if (self.flag) {
        [CommonMenuView showMenuAtPoint:point];
        self.flag = NO;
    }else{
        [CommonMenuView hidden];
        self.flag = YES;
    }
}
#pragma mark -- 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
  
    switch (tag) {
        case 1:
        {
            
            self.type = @"1";
            self.shop_type = @"1";
            self.navigationItem.title = @"线上本店";
            [self updateData:YES];
        }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"filterExtensionCategories" object:nil userInfo:@{@"indexVc":@1}];
            break;
        case 2:
        {
            self.type = @"2";
            self.shop_type = @"1";
            self.navigationItem.title = @"线下本店";
            [self updateData:YES];
        }
            break;
        case 3:
        {
            self.type = @"1";
            self.shop_type = @"2";
            self.navigationItem.title = @"线上他店";
            [self updateData:YES];
        }
            break;
        case 4:
        {
            
            self.type = @"2";
            self.shop_type = @"2";
            self.navigationItem.title = @"线下他店";
            [self updateData:YES];
        }
            break;
            
        default:
            break;
    }
    
    
    [CommonMenuView hidden];
    self.flag = YES;
}


#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLConsumerRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-154);
    }
    return _nodataV;
    
}
@end
