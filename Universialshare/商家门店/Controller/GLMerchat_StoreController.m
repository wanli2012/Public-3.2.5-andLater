//
//  GLMerchat_StoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreController.h"
#import "GLMerchat_StoreCell.h"
#import "GLAddStoreController.h"
#import "GLMerchat_StoreModel.h"
#import "GLMerchat_StoreModifyController.h"
#import "GLMerchat_StoreDetailController.h"
#import "LBSavaTypeModel.h"

@interface GLMerchat_StoreController ()<GLMerchat_StoreCellDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    LoadWaitView *_loadV;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *addStoreBtn;

@property (weak, nonatomic) IBOutlet UITextField *serachtf;

@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NodataView *nodataV;

@property (weak, nonatomic) IBOutlet UIView *searchView;


@end

static NSString *ID = @"GLMerchat_StoreCell";
@implementation GLMerchat_StoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView addSubview:self.nodataV];
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
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
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
    dict[@"page"] = [NSString stringWithFormat:@"%ld",_page];
    dict[@"content"] = [NSString stringWithFormat:@"%@",self.serachtf.text];

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getSonStoreList" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];

        if ([responseObject[@"code"] integerValue] == 1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMerchat_StoreModel *model = [GLMerchat_StoreModel mj_objectWithKeyValues:dic];
                    [_models addObject:model];
                }
            }
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        if (self.models.count <= 0 ) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    }
    return _nodataV;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)addStore:(id)sender {
    
    if([[UserModel defaultUser].is_main integerValue] == 1){
        [MBProgressHUD showError:@"分店不能开通门店"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLAddStoreController *addVC = [[GLAddStoreController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];

}
#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMerchat_StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.models[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.estimatedRowHeight = 64;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed = YES;
    GLMerchat_StoreModel  *model = self.models[indexPath.row];
    GLMerchat_StoreDetailController *vc =[[GLMerchat_StoreDetailController alloc]init];
    [LBSavaTypeModel  defaultUser].shop_id = model.shop_id;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma GLMerchat_StoreCellDelegate

- (void)cellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath btnTitle:(NSString *)title{
    if (index == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"暂停营业" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
        }];
        __weak typeof(self) weakself = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *pwdTF = alertController.textFields.firstObject;
            
            [weakself openOrCloseIndexPath:indexPath title:title pwd:pwdTF.text];
        
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入密码";
            textField.secureTextEntry = YES;
        }];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        GLMerchat_StoreModel *model = self.models[indexPath.row];

        self.hidesBottomBarWhenPushed = YES;
        GLMerchat_StoreModifyController *modifyVC = [[GLMerchat_StoreModifyController alloc] init];
        modifyVC.uid = model.uid;
        [self.navigationController pushViewController:modifyVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }
}
- (void)openOrCloseIndexPath:(NSIndexPath *)indexPath title:(NSString *)title pwd:(NSString *)pwd{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    GLMerchat_StoreModel *model = self.models[indexPath.row];
    if ([title isEqualToString:@"暂停营业"]) {
        
        dict[@"status"] = @(2);//暂停营业
    }else{
        
        dict[@"status"] = @1;//开始营业
    }
    dict[@"shop_id"] = model.shop_id;
    dict[@"pwd"] = [RSAEncryptor encryptString:pwd publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/setStoreOpenOrClose" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue]==1) {
            
            [self updateData:YES];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

- (IBAction)backclick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//搜索
- (IBAction)searchTapgesture:(UITapGestureRecognizer *)sender {
    if (self.serachtf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入搜索条件"];
        return;
    }
     [self updateData:YES];
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.view endEditing:YES];
    self.serachtf.text = @"";
    [self updateData:YES];
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
 [self.view endEditing:YES];
    if (self.serachtf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入搜索条件"];
        return NO;
    }
    
    [self updateData:YES];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength == 0) {
        [self.view endEditing:YES];
        self.serachtf.text = @"";
        [self updateData:YES];
    }
    return YES;
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.searchView.layer.cornerRadius = 3;
    self.searchView.clipsToBounds = YES;


}

-(NSMutableArray *)models{
    
    if (!_models) {
        _models=[NSMutableArray array];
    }
    
    return _models;
    
}
@end
