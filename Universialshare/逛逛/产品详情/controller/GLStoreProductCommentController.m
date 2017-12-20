//
//  GLStoreProductCommentController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLStoreProductCommentController.h"
//#import "GLStoreProductCommentCell.h"
#import "LBStoreDetailreplaysTableViewCell.h"

#import "formattime.h"

@interface GLStoreProductCommentController ()
@property (nonatomic, strong)NSMutableArray *models;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@end

static NSString *ID = @"LBStoreDetailreplaysTableViewCell";
@implementation GLStoreProductCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
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
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
}
- (void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getGoodsCommentListAsUser" paramDic:@{@"goods_id":self.goodId,@"page":[NSNumber numberWithInteger:_page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.models removeAllObjects];
                if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                    [self.models addObjectsFromArray:responseObject[@"data"]];
                }
                
                [self.tableView reloadData];
            }else{
                
                if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                    [self.models addObjectsFromArray:responseObject[@"data"]];
                }
                
                [self.tableView reloadData];
                
            }
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
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
    
    self.tableView.estimatedRowHeight = 75;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.starView.progress = [self.models[indexPath.row][@"mark"] integerValue];
    cell.nameLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"user_name"]];
    cell.contentLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"comment"]];
    cell.contentLb.text =  [self.models[indexPath.row][@"comment"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.timeLb.text = [formattime formateTimeYM:self.models[indexPath.row][@"addtime"]];
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.models[indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"tx_icon"] options:SDWebImageAllowInvalidSSLCertificates];
    if ([self.models[indexPath.row][@"is_comment"] integerValue] == 2) {
        cell.replyLb.hidden = NO;
        cell.replyLb.text = [NSString stringWithFormat:@"商家回复:%@",[self.models[indexPath.row][@"reply"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        cell.constaritH.constant = 15;
        cell.constraitTop.constant = 0;
        
    }else{
        cell.replyLb.hidden = YES;
        cell.replyLb.text = @"";
        cell.constaritH.constant = 0;
        cell.constraitTop.constant = 6;
        
    }
    
    if ([cell.nameLb.text rangeOfString:@"null"].location != NSNotFound) {
        cell.nameLb.text = @"无名";
    }
    
        return cell;

}

-(NSMutableArray*)models{
    if (!_models) {
        _models=[NSMutableArray array];
    }
    return _models;
}

@end
