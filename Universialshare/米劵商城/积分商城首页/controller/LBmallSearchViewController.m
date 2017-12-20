//
//  LBmallSearchViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBmallSearchViewController.h"
#import "LBIntegralGoodsCollectionViewCell.h"
#import "GLHourseDetailController.h"
#import "GLClassifyModel.h"
#import "LBRiceShopDataBase.h"
#import "DWQTagView.h"
#import "HistorySearchCell.h"
#import "HotSerachCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *ID = @"LBIntegralGoodsCollectionViewCell";
static NSString *const HotCellID = @"HotCellID";
static NSString *const HistoryCellID = @"HistoryCellID";

@interface LBmallSearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,LBIntegralGoodsCollectionViewdelegete,UICollectionViewDelegateFlowLayout,DWQTagViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView * _loadV;
}
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,strong) UITableView *tagtableview;
/** 历史搜索数组 */
@property (nonatomic, strong) NSMutableArray *historyArr;
/** 热门搜索数组 */
@property (nonatomic, strong) NSMutableArray *HotArr;
/** 得到热门搜索TagView的高度 */
@property (nonatomic ,assign) CGFloat tagViewHeight;
@property (nonatomic,strong) LBRiceShopDataBase      *projiectmodel;//综合项目本地保存

@end

@implementation LBmallSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH /2 - 6, (SCREEN_WIDTH /2 - 6)  + 80);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    self.collectionview.collectionViewLayout = layout;
     [self.collectionview registerNib:[UINib nibWithNibName:@"LBIntegralGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
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
    
    
    self.collectionview.mj_header = header;
    self.collectionview.mj_footer = footer;
    
    [self getFmdbDatasoruce];
    [self requstHotTags];
    [self.view addSubview:self.tagtableview];
    
    // 搜索框
    [[self.searchTF rac_textSignal]subscribeNext:^(id x) {
        if ([x isEqualToString:@""]) {
            self.collectionview.hidden = YES;
            self.tagtableview.hidden = NO;
            [self.models removeAllObjects];
            [self getFmdbDatasoruce];
        }
    }];

}

-(void)getFmdbDatasoruce{
    
    //获取本地搜索记录
    _projiectmodel = [LBRiceShopDataBase greateTableOfFMWithTableName:@"LBRiceShopDataBase"];
    
    if ([_projiectmodel isDataInTheTable]) {
        [self.historyArr removeAllObjects];
        for (int i = 0; i < [[_projiectmodel queryAllDataOfFMDB]count]; i++) {
            [self.self.historyArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"recoder"]];
        }
    }
    
    [self.tagtableview reloadData];
    
}
//请求热门记录
-(void)requstHotTags{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Other/getSearchHistoryRecord" paramDic:@{@"type":@"2"} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.HotArr addObject:responseObject[@"data"][i][@"content"]];
            }
            [self.tagtableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

//发送请求
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        
    }else{
        _page ++;
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = [NSString stringWithFormat:@"%zd",_page];
    dict[@"content"] = [NSString stringWithFormat:@"%@",self.searchTF.text];
    if ([UserModel defaultUser].loginstatus == YES) {
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
    }
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/searchMarkGoodsByGoodsName" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            if (status) {
                
                [self.models removeAllObjects];
            }
                for (NSDictionary *dict in responseObject[@"data"]) {
                    
                    GLintegralGoodsModel  *model = [GLintegralGoodsModel mj_objectWithKeyValues:dict];
                    [self.models addObject:model];
                }
            
            if (self.models.count > 0) {
                self.collectionview.hidden = NO;
                self.tagtableview.hidden = YES;
            }
            
        }else if ([responseObject[@"code"] integerValue] == 3){
            [MBProgressHUD showError:responseObject[@"message"]];
        }else {
            if (status) {
                [self.models removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        BOOL isSava = YES;//是否保存
        for (int i = 0; i < self.historyArr.count; i++) {
            if ([self.historyArr[i] isEqualToString:self.searchTF.text]) {
                isSava = NO;
            }
        }
        
        if (isSava == YES) {//保存记录
            [_projiectmodel insertOfFMWithstring:self.searchTF.text];
        }

        
        [self.collectionview reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self.view endEditing:YES];
    if (textField.text.length <= 0) {
        [self.view makeToast:@"请输入关键字" duration:2 position:CSToastPositionCenter];
        return NO;
    }
    [self updateData:YES];
    return YES;
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.item];
    cell.delegate = self;
    cell.index = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    GLintegralGoodsModel *model = self.models[indexPath.row];
    detailVC.goods_id = model.goods_id;
    detailVC.type = 1;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 0, 0, 0);
}
#pragma mark ----LBIntegralGoodsCollectionViewdelegete
//点击收藏
-(void)clickcheckcollectionbutton:(NSInteger)index{
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [self.view.window makeToast:@"请先去登录" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    GLintegralGoodsModel *model = self.models[index];
    
    if ([model.is_collection integerValue] == 1) {//已收藏
        [self cancelCollectionProduct:index];
    }else{//未收藏
        [self collectionProduct:index];
    }
}

//收藏
-(void)collectionProduct:(NSInteger)index{
    
    GLintegralGoodsModel *model = self.models[index];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"GID"] = model.goods_id;
    dict[@"type"] = @(1);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            
            model.is_collection = @"1";
            
            [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil]];
            
            [self.view.window makeToast:@"收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
            [self.view.window makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.view.window makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
        
    }];
    
}
//取消收藏
-(void)cancelCollectionProduct:(NSInteger)index{
    GLintegralGoodsModel *model = self.models[index];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"GID"] = model.goods_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            
            model.is_collection = @"0";
            
            [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil]];
            [self.view.window makeToast:@"取消收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
            [self.view.window makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
        }
        
        
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.view.window makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
    }];
    
}

#pragma UITableviewDelegate UITableviewDataSource
/** section的数量 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tagtableview) {
        if (self.historyArr.count == 0) {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    
    return 0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tagtableview) {
        if (self.historyArr.count == 0) {
            return 1;
        }
        else
        {
            if (section == 0) {
                return 1;
            }
            else
            {
                return self.historyArr.count;
            }
        }
    }
    
    return 0;
}
/** 使第一个cell（热门搜索的cell不可编辑） */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tagtableview) {
        if (indexPath.section == 0) {
            return UITableViewCellEditingStyleNone;
        }
        else
        {
            return UITableViewCellEditingStyleDelete;
        }
        
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tagtableview) {
        if (self.historyArr.count == 0) {
            HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
            
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            hotCell.userInteractionEnabled = YES;
            hotCell.hotSearchArr = self.HotArr;
            hotCell.dwqTagV.delegate = self;
            /** 将通过数组计算出的tagV的高度存储 */
            self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
            return hotCell;
        }
        else
        {
            if (indexPath.section == 0) {
                HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
                hotCell.dwqTagV.delegate = self;
                hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
                hotCell.userInteractionEnabled = YES;
                hotCell.hotSearchArr = self.HotArr;
                /** 将通过数组计算出的tagV的高度存储 */
                self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
                return hotCell;
            }
            else
            {
                HistorySearchCell *HistoryCell = [tableView dequeueReusableCellWithIdentifier:HistoryCellID forIndexPath:indexPath];
                HistoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                HistoryCell.tagNameLab.text = self.historyArr[indexPath.row];
                
                [HistoryCell.removeTagBtn addTarget:self action:@selector(removeSingleTagClick:) forControlEvents:UIControlEventTouchUpInside];
                HistoryCell.removeTagBtn.tag = 250 + indexPath.row;
                
                return HistoryCell;
            }
        }
    }
    
    return [[UITableViewCell alloc]init];
    
}
/** HeaderView */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tagtableview) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
        headView.backgroundColor = [UIColor colorWithWhite:0.922 alpha:1.000];
        for (UILabel *lab in headView.subviews) {
            [lab removeFromSuperview];
        }
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 45)];
        titleLab.textColor = [UIColor colorWithWhite:0.229 alpha:1.000];
        titleLab.font = [UIFont systemFontOfSize:14];
        [headView addSubview:titleLab];
        if (self.historyArr.count == 0) {
            
            titleLab.text = @"热门搜索";
        }
        else
        {
            if (section == 0) {
                titleLab.text = @"热门搜索";
            }
            else
            {
                titleLab.text = @"搜索历史";
                
            }
        }
        return headView;
    }
    return nil;
    
}
/** FooterView */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.tagtableview) {
        if (section == 1) {
            UIButton *removeAllHistory = [UIButton buttonWithType:0];
            removeAllHistory.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 46);
            removeAllHistory.backgroundColor = [UIColor whiteColor];
            [removeAllHistory setTitleColor:[UIColor colorWithRed:1.000 green:0.058 blue:0.000 alpha:1.000] forState:0];
            [removeAllHistory setTitle:@"清除所有搜索记录" forState:0];
            removeAllHistory.titleLabel.font = [UIFont systemFontOfSize:16];
            [removeAllHistory addTarget:self action:@selector(removeAllHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            return removeAllHistory;
        }
        else
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.1)];
            return view;
        }
        
    }
    
    return nil;
}
/** 头部的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tagtableview) {
        return 40;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tagtableview) {
        if (self.historyArr.count == 0) {
            
            return self.tagViewHeight + 40;
        }
        else
        {
            if (indexPath.section == 0) {
                return self.tagViewHeight + 40;
            }
            else
            {
                return 46;
            }
        }
    }
    return 0;
}
/** FooterView的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.tagtableview) {
        if (self.historyArr.count == 0) {
            return 0.1;
        }
        else
        {
            if (section == 0) {
                return 0.1;
            }
            else
            {
                return 46;
            }
        }
    }
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.view endEditing:YES];
    if (tableView == self.tagtableview) {
        if (indexPath.section == 1) {
            self.searchTF.text = self.historyArr[indexPath.row];
            [self updateData:YES];
            
        }
        return;
    }
}
#pragma mark -- 实现点击热门搜索tag  Delegate
-(void)DWQTagView:(UIView *)dwq fetchWordToTextFiled:(NSString *)KeyWord
{
    self.searchTF.text = KeyWord;
    [self updateData:YES];
    
}

#pragma mark -- 删除单个搜索历史
-(void)removeSingleTagClick:(UIButton *)removeBtn
{
    [_projiectmodel deleteOneDataOfFMDB:self.historyArr[removeBtn.tag - 250]];
    [self.historyArr removeObjectAtIndex:removeBtn.tag - 250];
    
    [self.tagtableview reloadData];
}
#pragma mark -- 删除所有的历史记录
-(void)removeAllHistoryBtnClick
{
    [_projiectmodel deleteAllDataOfFMDB];
    [self.historyArr removeAllObjects];
    [self.tagtableview reloadData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
- (void)endRefresh {
    
    [self.collectionview.mj_header endRefreshing];
    [self.collectionview.mj_footer endRefreshing];
    
}

- (IBAction)cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
- (NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}
- (NSMutableArray *)HotArr{
    if (!_HotArr) {
        _HotArr = [NSMutableArray array];
    }
    return _HotArr;
}

#pragma mark -- 懒加载
-(UITableView *)tagtableview
{
    if (!_tagtableview) {
        
        _tagtableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _tagtableview.delegate = self;
        _tagtableview.dataSource = self;
        _tagtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tagtableview registerClass:[HotSerachCell class] forCellReuseIdentifier:HotCellID];
        [_tagtableview registerNib:[UINib nibWithNibName:@"HistorySearchCell" bundle:nil] forCellReuseIdentifier:HistoryCellID];
        _tagtableview.backgroundColor = [UIColor colorWithWhite:0.934 alpha:1.000];
    }
    return _tagtableview;
}

@end
