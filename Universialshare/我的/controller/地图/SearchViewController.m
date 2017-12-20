//
//  SearchViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchModel.h"

@interface SearchViewController ()<BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    
    BMKPoiSearch *_poisearch;            //poi搜索
    BMKGeoCodeSearch  *_geocodesearch;   //geo搜索服务
}

@property (nonatomic,strong) NSMutableArray *addressArray;//搜索的地址数组

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _inputAddTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 150, 30)];
    
    [self.inputAddTF addTarget:self action:@selector(inputAddTFAction:) forControlEvents:UIControlEventEditingChanged];
    
    self.inputAddTF.borderStyle =UITextBorderStyleNone;
    
    self.inputAddTF.backgroundColor = [UIColor whiteColor];
    
    self.inputAddTF.layer.cornerRadius = 4;
    self.inputAddTF.clipsToBounds = YES;
    
    self.inputAddTF.placeholder = @"输入搜索地址";
//    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
//    imageViewPwd.image=[UIImage imageNamed:@"搜索"];
//    imageViewPwd.contentMode = UIViewContentModeScaleAspectFit;
//    self.inputAddTF.leftView=imageViewPwd;
//    self.inputAddTF.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
//    self.inputAddTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     [self.inputAddTF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    self.inputAddTF.textAlignment = NSTextAlignmentCenter;
    self.inputAddTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputAddTF.returnKeyType = UIReturnKeySearch;
    self.inputAddTF.delegate =self;
    
    self.displayTableView.dataSource = self;
    
    self.displayTableView.delegate = self;
    
    self.inputAddTF.font = [UIFont boldSystemFontOfSize:14];
    
    self.inputAddTF.textColor = [UIColor blackColor];
    
    self.navigationItem.titleView = _inputAddTF;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.addressArray = [NSMutableArray array];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //自动让输入框成为第一响应者,弹出键盘
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.inputAddTF becomeFirstResponder];
        
    });
    
}



-(void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    _poisearch.delegate = nil; // 不用时，置nil
    
    _geocodesearch.delegate = nil;
    
}

#pragma mark TableViewDelegate

//设置 row

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.addressArray.count;
    
}

//设置 tableViewCell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *cell_id = @"cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:3 reuseIdentifier:cell_id];
        
    }
    
    SearchModel *sModel = [[SearchModel alloc] init];
    
    sModel = self.addressArray[indexPath.row];
    
    cell.textLabel.text = sModel.name;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    

    cell.detailTextLabel.text = sModel.address;
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    
    return cell;
    
}

//设置选中事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //block 传值
    
    __weak typeof(self) wSelf = self;
    SearchModel *sModel = [[SearchModel alloc] init];
    
    sModel = self.addressArray[indexPath.row];
    
    if (self.block) {
        wSelf.block(sModel.address, sModel.pt);
        
    }

}

#pragma mark ---- 设置高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 50;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length <= 0 ) {
        [MBProgressHUD showError:@"请输入搜索关键字"];
        return NO;
    }
      [self performSelector:@selector(delay) withObject:self afterDelay:0.3];
    return YES;

}

#pragma mark 监听输入文本信息

-(void)inputAddTFAction:(UITextField *)textField

{
    
    //延时搜索
    
    [self performSelector:@selector(delay) withObject:self afterDelay:0.3];
    
}



#pragma mark ----- 延时搜索

- (void)delay {
    
    [self nameSearch];
    
}



#pragma mark ---- 输入地点搜索

-(void)nameSearch

{
    
    _poisearch = [[BMKPoiSearch alloc]init];
    
    _poisearch.delegate = self;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    
    citySearchOption.pageIndex = 0;
    
    citySearchOption.pageCapacity = 30;
    
    citySearchOption.city= _locationCity;
    
    citySearchOption.keyword = self.inputAddTF.text;
    
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    
    if(flag)
        
    {
        
       // NSLog(@"城市内检索发送成功");
        
    }
    
    else
        
    {
        
        //NSLog(@"城市内检索发送失败");
        
    }
    
}

#pragma mark --------- poi 代理方法

-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode

{
    
    if(errorCode == BMK_SEARCH_NO_ERROR)
        
    {
        
        [self.addressArray removeAllObjects];
        
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            
            SearchModel * model = [[SearchModel alloc] init];
            
            model.name = info.name;
            
            model.address = info.address;
            
            model.pt = info.pt;
            
            [self.addressArray addObject:model];
            
        }

        [self.displayTableView reloadData];
        
    }
    
}



#pragma mark 滑动的时候收起键盘

- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    
    [self.view endEditing:YES];
    
    [self.navigationItem.titleView endEditing:YES];
    
}



-(void)dealloc

{
    
    if (_poisearch != nil) {
        
        _poisearch = nil;
        
    }
    
    if (_geocodesearch != nil) {
        
        _geocodesearch = nil;
        
    }
    
}

@end
