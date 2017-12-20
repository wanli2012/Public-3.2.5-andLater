//
//  GLCityChooseController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLCityChooseController.h"
#import "GLCityChooseCell.h"

@interface GLCityChooseController ()<UITableViewDelegate,UITableViewDataSource>
{
     LoadWaitView * _loadV;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *keys;

@property (nonatomic, strong)NSArray *data;

@end

static NSString *ID = @"GLCityChooseCell";
@implementation GLCityChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLCityChooseCell" bundle:nil] forCellReuseIdentifier:ID];
    [self postRequest];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)postRequest {
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getCityListByLetter" paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){

            self.data = responseObject[@"data"];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}
#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.data[section][@"ct"];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLCityChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    NSDictionary *dic = self.data[indexPath.section][@"ct"][indexPath.row];
    cell.titleLabel.text = dic[@"name"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.data[indexPath.section][@"ct"][indexPath.row];
     self.block(dic[@"name"],dic[@"code"]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerV.backgroundColor = YYSRGBColor(235, 235, 235, 0.3);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    
    titleLabel.text = self.data[section][@"cn"];
    [headerV addSubview:titleLabel];
    
    return headerV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (int i = 0;i <self.data.count; i++) {
        NSString *title = self.data[i][@"cn"];
        [resultArray addObject:title];
    }
    return resultArray;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    
    }else{
        
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
    
}
- (NSMutableArray *)keys{
    if (!_keys) {
        _keys = [NSMutableArray array];
    }
    return _keys;
}
@end
