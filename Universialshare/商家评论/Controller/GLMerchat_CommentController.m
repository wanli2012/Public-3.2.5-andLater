//
//  GLMerchat_CommentController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_CommentController.h"
#import "GLMerchat_CommentGoodsModel.h"
#import "GLMerchat_CommentGoodCell.h"
#import "GLMerchat_CommentTableController.h"
#import "LBStoreSendGoodsListViewController.h"

@interface GLMerchat_CommentController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NodataView *nodataV;
@end

static NSString *ID = @"GLMerchat_CommentGoodCell";
@implementation GLMerchat_CommentController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.collectionView addSubview:self.nodataV];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.nodataV.hidden = YES;
    
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
    
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
    [self updateData:YES];
    
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
    dict[@"page"] = [NSString stringWithFormat:@"%zd",_page];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getArealyCommentGoodsList" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMerchat_CommentGoodsModel *model = [GLMerchat_CommentGoodsModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
        if (self.models.count <= 0 ) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
            self.collectionView.backgroundColor = YYSRGBColor(184, 184, 184, 0.2);
        }
        
        [self.collectionView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        
        if (self.models.count <= 0 ) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
            self.collectionView.backgroundColor = YYSRGBColor(184, 184, 184, 0.2);
        }

        [self.collectionView reloadData];
    }];
    
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64 - 49);
    }
    return _nodataV;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMerchat_CommentGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GLMerchat_CommentGoodsModel *model = self.models[indexPath.row];
//    if ([model.pl_count integerValue] <= 0) {
//        [MBProgressHUD showError:@"暂无评论"];
//        return;
//    }
    self.hidesBottomBarWhenPushed = YES;
    GLMerchat_CommentTableController *commentVC = [[GLMerchat_CommentTableController alloc] init];
    //commentVC.model = model;
    
    [self.navigationController pushViewController:commentVC animated:YES];

}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH / 2 - 0.5, SCREEN_WIDTH / 2 - 0.5);
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (IBAction)clickorderList:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBStoreSendGoodsListViewController *commentVC = [[LBStoreSendGoodsListViewController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];

    
}
- (IBAction)clickBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}



@end
