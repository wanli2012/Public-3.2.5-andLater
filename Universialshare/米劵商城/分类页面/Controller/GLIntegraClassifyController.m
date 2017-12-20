//
//  GLIntegraClassifyController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegraClassifyController.h"
#import "LBIntegralGoodsCollectionViewCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLHourseDetailController.h"
#import "UIButton+SetEdgeInsets.h"
#import "JSDropDownMenu.h"
#import "LBFilterMallShopViewController.h"
#import "InvestmentFilterPresentationController.h"
#import "GLClassifyModel.h"
#import "LBmallSearchViewController.h"

@interface GLIntegraClassifyController ()<UICollectionViewDelegate,UICollectionViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,LBIntegralGoodsCollectionViewdelegete>
{

    LoadWaitView * _loadV;
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
    //分类
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    
}

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *fitterBt;


@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)GLSet_MaskVeiw *maskV;

@property (nonatomic, strong)JSDropDownMenu *dropDownMenu;

@property (nonatomic, strong)NSMutableArray *classifyModels;

@end

static NSString *ID = @"LBIntegralGoodsCollectionViewCell";
@implementation GLIntegraClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCategreyData];
    
    [self.view addSubview:self.dropDownMenu];

    [self setCollection];
    
    [self setRefresh];

    [self getMarkGoodsType];//获取分类
    
    [self.collectionView addSubview:self.nodataV];
    
    if (self.catename != nil && self.catename.length > 0) {
        [_fitterBt setTitle:self.catename forState:UIControlStateNormal];
        [self.fitterBt horizontalCenterTitleAndImage:5];
    }
    
}

-(void)initCategreyData{

    _data1 = [NSMutableArray arrayWithObjects:@"全部", @"热卖推荐", @"尖货热销", nil];
    _data2 = [NSMutableArray arrayWithObjects:@"默认",@"销量正序", @"销量倒序", @"价格正序", @"价格倒序",  nil];
    
    NSInteger currentindex = 0;
    for (int i = 0; i < self.classftyArr.count; i++) {
        [_data1 addObject:self.classftyArr[i][@"chinese_title"]];
        if (self.jumpindex == 3) {
            if ([self.classftyArr[i][@"chinese_title"] isEqualToString:self.classftyname]) {
                currentindex =  3 + i;
                self.classId = self.classftyArr[i][@"id"];
            }
        }
    }
    
    if (self.jumpindex == 4) {
        _currentData1Index = 0;
    }else{
        if (self.jumpindex == 3) {
            _currentData1Index = currentindex;
        }else{
           _currentData1Index = self.jumpindex;
        }
    }
    _currentData2Index = 0;

}
-(void)setRefresh{

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
    
    [self updateData:YES];
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;


}
-(void)setCollection{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH /2 - 6, (SCREEN_WIDTH /2 - 6) + 80);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBIntegralGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

//发送请求
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        
    }else{
        _page ++;
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.jumpindex == 4) {
        if (_currentData1Index >= 3) {
             dict[@"comprehensive"] = [NSString stringWithFormat:@"3:%@",self.classId];
        }else{
              dict[@"comprehensive"] = @(_currentData1Index);
        }
    }else{
        if (self.jumpindex == 3) {
           dict[@"comprehensive"] = [NSString stringWithFormat:@"3:%@",self.classId];
        }else{
            dict[@"comprehensive"] = @(_currentData1Index);
        }
    }

    dict[@"sort"] = @(_currentData2Index);
    dict[@"cate_id"] = _classifyid;
    dict[@"page"] = [NSString stringWithFormat:@"%zd",_page];
    if ([UserModel defaultUser].loginstatus == YES) {
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
    }
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getMarkGoodsList" paramDic:dict finish:^(id responseObject) {
        
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
    
        }else if([responseObject[@"code"] integerValue] == 3){
            if (status) {
                [self.models removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
    }];

}
- (void)getMarkGoodsType {
    
    //请求数据
    [NetworkManager requestPOSTWithURLStr:@"Shop/getMarkGoodsCate" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            [self.classifyModels removeAllObjects];
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"]] rangeOfString:@"null"].location == NSNotFound ) {

                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLClassifyModel *model = [GLClassifyModel mj_objectWithKeyValues:dic];
                    [self.classifyModels addObject:model];
                    
                }
            }
            
        }
        
    } enError:^(NSError *error) {
        
    }];
}

- (void)endRefresh {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
}
//返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.models.count > 0) {
        self.nodataV.hidden = YES;
    }else{
         self.nodataV.hidden = NO;
    }
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
    
      GLintegralGoodsModel *model = self.models[indexPath.item];
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    detailVC.navigationItem.title = @"米券兑换详情";
    detailVC.type = 1;
    detailVC.goods_id = model.goods_id;
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
            
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil]];
            
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
            
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil]];
            [self.view.window makeToast:@"取消收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
            [self.view.window makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.view.window makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
    }];
    
}
//跳转搜索
- (IBAction)jumpSerachVc:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBmallSearchViewController *searchVC = [[LBmallSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    
}

#pragma JSDropDownMenuDataSource,JSDropDownMenuDelegate

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
  
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
    
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {

        return _data1.count;
       
    } else if (column==1){
        
        return _data2.count;
        
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _data1[_currentData1Index];
            break;
        case 1: return _data2[_currentData2Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {

       return _data1[indexPath.row];

    } else {
        
        return _data2[indexPath.row];
        
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
 
        if (indexPath.row >= 3) {
            self.classId = self.classftyArr[indexPath.row - 3][@"id"];
        }
        _currentData1Index = indexPath.row;
        
    } else {
        
        _currentData2Index = indexPath.row;
        
    }
    //刷新

    [self updateData:YES];
}

#pragma mark ------筛选

- (IBAction)filterevent:(UIButton *)sender {
    
    if (self.dropDownMenu.currentSelectedMenudIndex != -1) {
        [self.dropDownMenu backgroundTapped:nil];
    }
   
    LBFilterMallShopViewController *vc =[[LBFilterMallShopViewController alloc]init] ;
    vc.transitioningDelegate=self;
    [vc.models addObjectsFromArray:self.classifyModels];
    __weak typeof(self) weaks = self;
    vc.refreshClassifyData = ^(NSString *cataid,NSString *catename){
        _classifyid = cataid;
        [_fitterBt setTitle:catename forState:UIControlStateNormal];
        [_fitterBt horizontalCenterTitleAndImage:5];
        [weaks updateData:YES];
    
    };
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.searchView.layer.cornerRadius = 4;
    self.searchView.clipsToBounds = YES;
    
     [self.fitterBt horizontalCenterTitleAndImage:5];

}

#pragma mark UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[InvestmentFilterPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT);
  
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            toView.frame=CGRectMake(60, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
       
            [UIView animateWithDuration:0.3 animations:^{
                
               toView.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT);
                //[toView removeFromSuperview];
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [toView removeFromSuperview];
                    [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
                }
                
            }];
            
        }
        
    }

- (GLSet_MaskVeiw *)maskV{
    
    if (!_maskV) {
        _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskV.bgView.alpha = 0.3;
    }
    
    return _maskV;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
- (NSMutableArray *)classifyModels{
    if (!_classifyModels) {
        _classifyModels = [NSMutableArray array];
    }
    return _classifyModels;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}

-(JSDropDownMenu*)dropDownMenu{

    if (!_dropDownMenu) {
        _dropDownMenu = ({
        
            JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:50 andWidth:SCREEN_WIDTH * 2/3.0];
            menu.indicatorColor = [UIColor colorWithRed:235/255.0f green:136/255.0f blue:26/255.0f alpha:1.0];
            menu.separatorColor = [UIColor whiteColor];
            menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
            menu.dataSource = self;
            menu.delegate = self;
            menu;
            
        });
    }

    return _dropDownMenu;
}

@end
