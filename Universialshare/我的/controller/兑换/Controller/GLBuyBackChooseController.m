//
//  GLBuyBackChooseController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackChooseController.h"
#import "GLBankCardCellTableViewCell.h"
#import "GLBuyBackChooseCardController.h"

@interface GLBuyBackChooseController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *cardModels;
@end

static NSString *ID = @"GLBankCardCellTableViewCell";
@implementation GLBuyBackChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航栏右按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.automaticallyAdjustsScrollViewInsets = NO;
    button.frame = CGRectMake(SCREEN_WIDTH - 60, 14, 30, 30);
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    [button setImage:[UIImage imageNamed:@"增加符号"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [button addTarget:self action:@selector(pushToAddVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    self.navigationItem.title = @"我的银行卡";
//    self.tableView.editing = YES;
    
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLBankCardCellTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.cardModels removeAllObjects];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getbank" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLBankCardModel *model = [GLBankCardModel mj_objectWithKeyValues:dic];
                [self.cardModels addObject:model];
            }
        }else{
            
            [UserModel defaultUser].banknumber = @"";
            [UserModel defaultUser].defaultBankname = @"";
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}
- (void)pushToAddVC {
    GLBuyBackChooseCardController * vc = [[GLBuyBackChooseCardController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)cardModels{
    if (!_cardModels) {
        _cardModels = [NSMutableArray array];
        
    }
    return _cardModels;
}
#pragma UITableviewDelegate UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLBankCardCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.cardModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)returnModel:(ReturnBlock)block{
    self.returnBlock = block;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLBankCardModel *model = self.cardModels[indexPath.row];
    if ([model.name isEqualToString:@"中国银行"]) {
        model.iconName = @"BOC";
    }else if([model.name isEqualToString:@"中国工商银行"]){
        model.iconName = @"ICBC";
    }else if([model.name isEqualToString:@"中国农业银行"]){
        model.iconName = @"ABC";
    }else if([model.name isEqualToString:@"中国建设银行"]){
        model.iconName = @"CCB";
    }else{
        model.iconName = @"bank_nopicture";
    }
    
    self.returnBlock(model);
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ADAPT(70);
}

/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        GLBankCardModel *model = self.cardModels[indexPath.row];
        [self deleteCard:model.number];
        
        [self.cardModels removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    return @[action1];
}
- (void)deleteCard:(NSString *)banknumber {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"banknumber"] = banknumber;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/del_bank" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
//        NSLog(@"responseObject = %@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBankCardNotification" object:nil userInfo:@{@"banknumber":banknumber}];
            
            [MBProgressHUD showSuccess:@"删除银行卡成功!"];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
}

@end
