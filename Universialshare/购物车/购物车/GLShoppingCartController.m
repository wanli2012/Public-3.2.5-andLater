//
//  GLShoppingCartController.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLShoppingCartController.h"
#import "GLShoppingCell.h"
#import "GLConfirmOrderController.h"
#import "UIButton+SetEdgeInsets.h"

@interface GLShoppingCartController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    LoadWaitView *_loadV;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@property (nonatomic, assign)BOOL isSelectedRightBtn;

@property (nonatomic, strong)NSMutableArray *selectArr;

@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, assign)NSInteger totalNum;

@property (nonatomic, strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UILabel *navaTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;
@property (strong, nonatomic)NodataView *nodataV;

@property (nonatomic, assign)NSInteger selectCurerrt;// 当前选中那个

@end

static NSString *ID = @"GLShoppingCell";
@implementation GLShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectCurerrt = -1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLShoppingCell" bundle:nil] forCellReuseIdentifier:ID];

     [self.clearingBtn addTarget:self action:@selector(clearingMore:) forControlEvents:UIControlEventTouchUpInside];

    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:¥ 0"];
   
    [self.tableView addSubview:self.nodataV];
    
    [self.tableView.mj_header beginRefreshing];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self postRequest];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRequest) name:@"refreshCartNotification" object:nil];

}



- (void)postRequest {
    
    _selectCurerrt = -1;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/myCartList" paramDic:dict finish:^(id responseObject) {
        
        [self.models removeAllObjects];
        if (![responseObject[@"data"] isEqual:[NSNull null]]) {
            
            if ([responseObject[@"code"] integerValue] == 1){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLShoppingCartModel *model = [GLShoppingCartModel mj_objectWithKeyValues:dic];
                    model.isSelect = NO;
                    [self.models addObject:model];
                }
                
                self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ 0"];

            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } enError:^(NSError *error) {
         [MBProgressHUD showError:@"请求数据失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

//去结算
- (void)clearingMore:(UIButton *)sender{
    
    if (_selectCurerrt == -1) {
        [MBProgressHUD showError:@"还未选择商品"];
        return;
    }

    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    NSMutableArray *tempArr3 = [NSMutableArray array];
    NSMutableArray *tempArr4 = [NSMutableArray array];
    

        GLShoppingCartModel *model = self.models[_selectCurerrt];
            
            [tempArr addObject:model.goods_id];
            [tempArr2 addObject:model.num];
            [tempArr3 addObject:model.cart_id];
            [tempArr4 addObject:model.spec_id];
    //重置
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ 0"];
    model.isSelect = NO;
    _selectCurerrt = -1;
    [self.tableView reloadData];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"token"] = [UserModel defaultUser].token;
    dict1[@"uid"] = [UserModel defaultUser].uid;
    dict1[@"goods_id"] = [tempArr componentsJoinedByString:@","];
    dict1[@"goods_count"] = [tempArr2 componentsJoinedByString:@","];
    //请求商品信息
    [NetworkManager requestPOSTWithURLStr:@"Shop/placeOrderBefore" paramDic:dict1 finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            self.hidesBottomBarWhenPushed= YES;
            GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
            vc.goods_id = [tempArr componentsJoinedByString:@","];
            vc.goods_count = [tempArr2 componentsJoinedByString:@","];
            vc.orderType = 2; //订单类型
            vc.dataDic = responseObject[@"data"];
            vc.cart_id = [tempArr3 componentsJoinedByString:@","];
            vc.goods_spec = [tempArr4 componentsJoinedByString:@","];
            [self.navigationController pushViewController:vc animated:YES];
             self.hidesBottomBarWhenPushed = NO;
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];

}



- (void)updateTitleNum {
    
    if (self.isMainVC == NO) {
        self.navaTitle.text = [NSString stringWithFormat:@"购物车"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"购物车"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self updateTitleNum];
    
    if (self.isMainVC == NO) {
      self.navigationController.navigationBar.hidden = YES;
        self.bottomConstrait.constant = 49;
    }else{
        self.navigationController.navigationBar.hidden = NO;
        self.bottomConstrait.constant = 0;
    }
    
}

#pragma  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.models.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count == 0 ? 0:self.models.count;

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.model = self.models.count == 0 ? nil:self.models[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectCurerrt == -1) {
        GLShoppingCartModel *model = self.models[indexPath.row];
        model.isSelect = !model.isSelect;
        float  num = 0;

        num = num + [model.goods_price floatValue] * [model.num floatValue];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
         _selectCurerrt = indexPath.row;
    }else{
    
        if (_selectCurerrt == indexPath.row) {
            GLShoppingCartModel *model = self.models[indexPath.row];
            model.isSelect = !model.isSelect;
            
            float  num = 0;
    
            self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
             _selectCurerrt = -1;
        }else{
        
            GLShoppingCartModel *oldmodel = self.models[_selectCurerrt];
            oldmodel.isSelect = !oldmodel.isSelect;
            
            GLShoppingCartModel *model = self.models[indexPath.row];
            model.isSelect = !model.isSelect;
            
            float  num = 0;
            
            num = num + [model.goods_price floatValue] * [model.num floatValue];
            
            self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_selectCurerrt inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
             _selectCurerrt = indexPath.row;
        
        }
    
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            GLShoppingCartModel *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"goods_id"] = model.goods_id;
            dict[@"cart_id"] = model.cart_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:@"Shop/delCart" paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];

                if ([responseObject[@"code"] integerValue] == 1){

                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    BOOL  b = NO;
                    float  num = 0;
                    
                    for (int i = 0; i < self.models.count; i++) {
                        GLShoppingCartModel *model = self.models[i];
                        
                        if (model.isSelect == NO) {
                            b = YES;
                            
                        }else{
                            
                            num = num + [model.goods_price floatValue] * [model.num floatValue];
                            
                        }
                    }
                    
                    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                    
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
                
            } enError:^(NSError *error) {
                [_loadV removeloadview];
            }];

        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
@end
