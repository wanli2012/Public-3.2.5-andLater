//
//  GLMyHeartController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyHeartController.h"
#import "GLMine_MyHeartCell.h"
#import "GLMyHeartRecoderController.h"
#import "GLMyheartRl_typeModel.h"

@interface GLMyHeartController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,strong)NSMutableArray *titleArr;

@end

static NSString *ID = @"GLMine_MyHeartCell";

@implementation GLMyHeartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的米分";
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GLMine_MyHeartCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self requestDataSorce];
    
}
//请求数据
-(void)requestDataSorce{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/mylove_new" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLMyheartModel *model = [GLMyheartModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

#pragma  UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_MyHeartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    GLMyheartModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.titileLb.text = self.titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMyHeartRecoderController *vc =[[GLMyHeartRecoderController alloc]init];
    [GLMyheartRl_typeModel defaultUser].rl_type = indexPath.row + 1;
    [self.navigationController pushViewController:vc animated:YES];

}

-(NSMutableArray*)models{

    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;

}

-(NSMutableArray*)titleArr{

    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@"20%奖励",@"10%奖励",@"5%奖励",@"3%奖励", nil];
    }
    
    return _titleArr;

}


@end
