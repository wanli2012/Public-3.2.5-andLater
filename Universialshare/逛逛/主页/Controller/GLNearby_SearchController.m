//
//  GLNearby_SearchController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_SearchController.h"
#import "LBNearbySearchTableViewCell.h"
#import "LBStoreMoreInfomationViewController.h"
#import "projiectmodel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DWQTagView.h"
#import "HistorySearchCell.h"
#import "HotSerachCell.h"
#import "LBNearbySearchHeaderView.h"
#import "LBStoreProductDetailInfoViewController.h"

@interface GLNearby_SearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DWQTagViewDelegate>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITableView *tagtableview;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

//@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, strong)NSMutableArray *nearModels;

@property (nonatomic,strong) projiectmodel      *projiectmodel;//综合项目本地保存

/** 历史搜索数组 */
@property (nonatomic, strong) NSMutableArray *historyArr;
/** 热门搜索数组 */
@property (nonatomic, strong) NSMutableArray *HotArr;
/** 得到热门搜索TagView的高度 */
@property (nonatomic ,assign) CGFloat tagViewHeight;

@end

static NSString *ID = @"LBNearbySearchTableViewCell";
static NSString *const HotCellID = @"HotCellID";
static NSString *const HistoryCellID = @"HistoryCellID";

@implementation GLNearby_SearchController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.searchView.layer.cornerRadius = 5.f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
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
    [self getFmdbDatasoruce];
    [self requstHotTags];
    self.tableView.hidden = YES;
    
    // 搜索框
    [[self.searchTF rac_textSignal]subscribeNext:^(id x) {
        if ([x isEqualToString:@""]) {
            self.tableView.hidden = YES;
            self.tagtableview.hidden = NO;
            [self.nearModels removeAllObjects];
            [self getFmdbDatasoruce];
        }
    }];
    
    [self.view addSubview:self.tagtableview];
}

-(void)getFmdbDatasoruce{

    //获取本地搜索记录
    _projiectmodel = [projiectmodel greateTableOfFMWithTableName:@"projiectmodel"];
    
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
    [NetworkManager requestPOSTWithURLStr:@"Other/getSearchHistoryRecord" paramDic:@{@"type":@"1"} finish:^(id responseObject) {
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

- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        [self.nearModels removeAllObjects];
        
    }else{
        _page ++;
        
    }
    
    if (self.searchTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        [self endRefresh];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"lng"] = [GLNearby_Model defaultUser].longitude;
    dict[@"lat"] = [GLNearby_Model defaultUser].latitude;
    dict[@"page"] = [NSString stringWithFormat:@"%zd",_page];
    dict[@"content"] = self.searchTF.text;
    
   _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Shop/searchNearShopByContent" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic  in responseObject[@"data"][@"shop_data"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.nearModels addObject:model];
                }
                
                if (self.nearModels.count > 0) {
                    self.tableView.hidden = NO;
                    self.tagtableview.hidden = YES;
                }
                
                [self.tableView reloadData];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableView reloadData];
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
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        [self.tableView reloadData];
    }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}

- (IBAction)cancel:(id)sender {

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    [self updateData:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self updateData:YES];
    [self.view endEditing:YES];
    return YES;
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
    }else{
        return self.nearModels.count;
    }
    
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
    }else{
        GLNearby_NearShopModel *model = self.nearModels[section];
      return model.goods.count;
    }
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
    }else{
        LBNearbySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = 0;
        cell.model = ((GLNearby_NearShopModel*)self.nearModels[indexPath.section]).goods[indexPath.row];
        return cell;
    }
    
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
    }else{
        LBNearbySearchHeaderView  *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBNearbySearchHeaderView"];
        if (!view) {
            view = [[LBNearbySearchHeaderView alloc] initWithReuseIdentifier:@"LBNearbySearchHeaderView"];
        }
        view.model = self.nearModels[section];
        __weak typeof(self) wself = self;
        view.retureShopID = ^(NSString *shopid){
            wself.hidesBottomBarWhenPushed = YES;
            LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
            store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            GLNearby_NearShopModel *model = self.nearModels[section];
            store.storeId = model.shop_id;
            [wself.navigationController pushViewController:store animated:YES];
        };
        return view;
    }
    
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
    if (tableView == self.tableView) {
        return 110;
    }
    return 40;
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
    return 60;
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
    
    if (tableView == self.tagtableview) {
        if (indexPath.section == 1) {
            self.searchTF.text = self.historyArr[indexPath.row];
            [self updateData:YES];
        }
        return;
    }
    
    GLNearby_NeargoodsModel *model = ((GLNearby_NearShopModel*)self.nearModels[indexPath.section]).goods[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    LBStoreProductDetailInfoViewController *vc=[[LBStoreProductDetailInfoViewController alloc]init];
    vc.goodname = model.goods_name;
    vc.storename =  ((GLNearby_NearShopModel*)self.nearModels[indexPath.section]).shop_name;
    vc.goodId = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

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
#pragma 懒加载
- (NSMutableArray *)nearModels{
    if (!_nearModels) {
        _nearModels = [NSMutableArray array];
    }
    return _nearModels;
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}
@end
