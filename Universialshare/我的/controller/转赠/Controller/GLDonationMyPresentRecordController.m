//
//  GLDonationMyPresentRecordController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/3.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationMyPresentRecordController.h"

#import "GLDonationRecordCell.h"
#import "GLDonationRecordModel.h"

@interface GLDonationMyPresentRecordController ()<UITableViewDelegate,UITableViewDataSource>

{
    LoadWaitView *_loadV;
}

@property (strong, nonatomic)NodataView *nodataV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UILabel *riceqAllLb;
@property (weak, nonatomic) IBOutlet UILabel *ricezAllLb;


@end

static NSString *ID = @"GLDonationRecordCell";

@implementation GLDonationMyPresentRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLDonationRecordCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [self updateData:YES];
}

- (void)updateData:(BOOL)status {
    //    NSInteger page;
    if (status) {
        
        _page = 1;
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dit = [NSMutableDictionary dictionary];
    dit[@"token"] = [UserModel defaultUser].token;
    dit[@"uid"] = [UserModel defaultUser].uid;
    dit[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    dit[@"type"] = @"0";
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/give_list" paramDic:dit finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1) {
            if (status) {
                [self.models removeAllObjects];
            }
            self.riceqAllLb.text = [NSString stringWithFormat:@"总米券:%@",responseObject[@"total_mark"]];
            self.ricezAllLb.text = [NSString stringWithFormat:@"总米子:%@",responseObject[@"total_price"]];
            if ([responseObject[@"total_mark"] intValue] > 10000) {
                
                CGFloat num = [responseObject[@"total_mark"]  floatValue] / 10000;
                self.riceqAllLb.text = [NSString stringWithFormat:@"总米券: %.2f万",num];
                
            }
            if ([responseObject[@"total_price"] intValue] > 10000) {
                
                CGFloat num = [responseObject[@"total_price"]  floatValue] / 10000;
                self.ricezAllLb.text = [NSString stringWithFormat:@"总米子: %.2f万",num];
                
            }
            
            self.riceqAllLb.attributedText = [self setStrSpecilStr:[NSString stringWithFormat:@"%@",responseObject[@"total_mark"]] oldstr:self.riceqAllLb.text];
            self.ricezAllLb.attributedText = [self setStrSpecilStr:[NSString stringWithFormat:@"%@",responseObject[@"total_price"]] oldstr:self.ricezAllLb.text];
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLDonationRecordModel *model = [GLDonationRecordModel mj_objectWithKeyValues:dic];
                [_models addObject:model];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        self.nodataV.hidden = NO;
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

-(NSAttributedString*)setStrSpecilStr:(NSString*)speStr oldstr:(NSString*)oldstr{
    NSRange range = [oldstr rangeOfString:speStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oldstr];
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:TABBARTITLE_COLOR range:range];
    
    return str;
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma  UITableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_models.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLDonationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90 ;
}


- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
