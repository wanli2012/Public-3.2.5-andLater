//
//  AnotherSearchViewController.m
//
//  Created by Caoyq on 16/3/29.
//  Copyright (c) 2016年 Caoyq. All rights reserved.
//

#import "AnotherSearchViewController.h"
#import "ZYPinYinSearch.h"
#import "HCSortString.h"
#import "LBSearchModel.h"
#import "LBSerachFriendTableViewCell.h"
#import "NTESSessionViewController.h"

#define kColor          [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];

@interface AnotherSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UITableView *friendTableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (strong, nonatomic) NSArray *friendArr;/**<好友列表*/
@property (assign, nonatomic) BOOL isSearch;

@end

@implementation AnotherSearchViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"搜索好友";
    _dataSource = [NSMutableArray array];
    [self initData];
    [self.view addSubview:self.friendTableView];
    [self.view addSubview:self.searchBar];
    
    self.friendTableView.tableFooterView = [UIView new];
    
    [self.friendTableView registerNib:[UINib nibWithNibName:@"LBSerachFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBSerachFriendTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void) keyboardWillHide : (NSNotification*)notification {
    
    _searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _isSearch = NO;
    [_friendTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init
- (void)initData {
    
    _friendArr = [[NIMSDK sharedSDK].userManager myFriends];
    
    for (int i = 0 ; i < _friendArr.count; i++) {
        NIMUser *user = _friendArr[i];
        LBSearchModel *dic = [LBSearchModel new];
        dic.userId = user.userId;
        dic.avatarUrl = user.userInfo.avatarUrl;
        
        if (user.alias.length > 0 ) {
            dic.name = user.alias;
        }
        
        if (user.alias.length <= 0 && user.userInfo.nickName.length > 0) {
            dic.name = user.userInfo.nickName;
        }
        
        if (user.alias.length <= 0 && user.userInfo.nickName.length <= 0) {
            dic.name = user.userId;
        }
        
        [_dataSource addObject:dic];
    }
    
    
    _searchDataSource = [NSMutableArray new];
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    
}

- (UITableView *)friendTableView {
    if (!_friendTableView) {
        _friendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, self.view.height-CGRectGetMaxY(self.searchBar.frame)) style:UITableViewStylePlain];
        _friendTableView.backgroundColor = kColor;
        _friendTableView.delegate = self;
        _friendTableView.dataSource = self;
    }
    return _friendTableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_isSearch) {
        return _indexDataSource.count;
    }else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_isSearch) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
        return value.count;
    }else {
        return _searchDataSource.count;
    }
}
//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!_isSearch) {
        return _indexDataSource[section];
    }else {
        return nil;
    }
}
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!_isSearch) {
        return _indexDataSource;
    }else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBSerachFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBSerachFriendTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imagev.image = nil;
    if(!_isSearch){
        LBSearchModel *model = _allDataSource[_indexDataSource[indexPath.section]][indexPath.row];
        cell.namelb.text = model.name;
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
        
    }else{
        LBSearchModel *model = _searchDataSource[indexPath.row];
        cell.namelb.text = model.name;
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
        
    }
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LBSearchModel *model;
    if (!_isSearch) {
        model = _allDataSource[_indexDataSource[indexPath.section]][indexPath.row];
    }else{
        model = _searchDataSource[indexPath.row];
    }
    
    self.hidesBottomBarWhenPushed = YES;
    NIMSession *session = [NIMSession session:model.userId type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController showViewController:vc sender:nil];
    [self searchBarCancelButtonClicked:self.searchBar];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchDataSource removeAllObjects];
    NSArray *ary = [HCSortString getAllValuesFromDict:_allDataSource];
    
    if (searchText.length == 0) {
        _isSearch = NO;
        [_searchDataSource addObjectsFromArray:ary];
    }else {
        _isSearch = YES;
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:searchText andSearchByPropertyName:@"name"];
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.friendTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        _searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        _friendTableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, self.view.height-CGRectGetMaxY(self.searchBar.frame));
        _searchBar.showsCancelButton = YES;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    _friendTableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, self.view.height-CGRectGetMaxY(self.searchBar.frame));
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _isSearch = NO;
    [_friendTableView reloadData];
}

#pragma mark - block
- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}

@end

