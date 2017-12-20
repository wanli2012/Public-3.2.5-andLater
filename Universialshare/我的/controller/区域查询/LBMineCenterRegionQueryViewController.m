//
//  LBMineCenterRegionQueryViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterRegionQueryViewController.h"
#import "LBMineCenterRegionQueryTableViewCell.h"
#import "LBMineCenterWantToSignUpViewController.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "SDCycleScrollView.h"

@interface LBMineCenterRegionQueryViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,SDCycleScrollViewDelegate>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UIButton *chechBt;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *signUpBt;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@property (weak, nonatomic) IBOutlet UILabel *provinceLb;
@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (weak, nonatomic) IBOutlet UILabel *areaLb;


@property (nonatomic, strong)NSMutableArray *provinceArr;
@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSMutableArray *countryArr;
@property (nonatomic, assign)NSInteger ischosePro;//记录选择省的第几行
@property (nonatomic, assign)NSInteger ischoseCity;//记录选择市的第几行
@property (nonatomic, assign)NSInteger ischoseArea;//记录选择区的第几行

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@end

@implementation LBMineCenterRegionQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"区域查询";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterRegionQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterRegionQueryTableViewCell"];
    
    self.tableview.tableHeaderView = self.cycleScrollView;
    
    [self.tableview addSubview:self.nodataV];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf footerrefresh];
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//    }];
    
    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableview.mj_header = header;
    //self.tableview.mj_footer = footer;
    
    [self initdatasource];
    [self getPickerData];
    
}

#pragma mark - get data
- (void)getPickerData {
    
    [NetworkManager requestPOSTWithURLStr:@"User/getCityList" paramDic:@{} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue]==1) {

            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.provinceArr = responseObject[@"data"];
            }
        }
    } enError:^(NSError *error) {

        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(void)initdatasource{
    
    NSDictionary *dic=[NSDictionary dictionary];
    if ([self.provinceLb.text isEqualToString:@"不限"] && [self.cityLb.text isEqualToString:@"不限"] && [self.areaLb.text isEqualToString:@"不限"]) {
        dic =@{@"provinceID":@"",@"cityID":@"",@"areaID":@""};
    }else if ( [self.cityLb.text isEqualToString:@"不限"] && [self.areaLb.text isEqualToString:@"不限"]){
        if (self.provinceArr.count > 0) {
            dic =@{@"provinceID":_provinceArr[_ischosePro][@"province_code"],@"cityID":@"",@"areaID":@""};
        }
    }else if ( [self.areaLb.text isEqualToString:@"不限"]){
        if (self.provinceArr.count > 0) {
            dic =@{@"provinceID":_provinceArr[_ischosePro][@"province_code"],@"cityID":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"city_code"],@"areaID":@""};
        }
    }else{
        if (self.provinceArr.count > 0) {
            dic =@{@"provinceID":_provinceArr[_ischosePro][@"province_code"],@"cityID":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"city_code"],@"areaID":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][_ischoseArea][@"country_code"]};
        }
    }
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/getAreasAgent" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
   // [self initdatasource];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count > 0) {
        self.nodataV.hidden = YES;
    }else{
       self.nodataV.hidden = NO;
    }
    return self.dataarr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataarr[indexPath.row][@"type"] integerValue]==3) {
        
        return 160;
    }
    
    return 200;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterRegionQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterRegionQueryTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.dataarr[indexPath.row][@"type"] integerValue]==1) {
        cell.agenceLb.text = @"省级代理";
        cell.industryImage.hidden = NO;
        cell.industryAgenclb.hidden = NO;
        cell.industryNumLb.hidden = NO;
        cell.industryMoneyLb.hidden = NO;
        cell.topconstrait.constant = 8;
    }else if ([self.dataarr[indexPath.row][@"type"] integerValue]==2){
        cell.agenceLb.text = @"市级代理";
        cell.industryImage.hidden = NO;
        cell.industryAgenclb.hidden = NO;
        cell.industryNumLb.hidden = NO;
        cell.industryMoneyLb.hidden = NO;
        cell.topconstrait.constant = 8;
    }else if ([self.dataarr[indexPath.row][@"type"] integerValue]==3){
        cell.agenceLb.text = @"区级代理";
        cell.industryImage.hidden = YES;
        cell.industryAgenclb.hidden = YES;
        cell.industryNumLb.hidden = YES;
        cell.industryMoneyLb.hidden = YES;
        cell.topconstrait.constant = -32;
    }
    
    cell.adreesLb.text = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"name"]];
    cell.serviceNumLb.text = [NSString stringWithFormat:@"剩余: %@",self.dataarr[indexPath.row][@"dl_count"]];
    cell.serviceMoneyLb.text = [NSString stringWithFormat:@"价格: %@元",self.dataarr[indexPath.row][@"agentPrice"]];
    cell.industryMoneyLb.text = [NSString stringWithFormat:@"价格: %@元",self.dataarr[indexPath.row][@"trade_money"]];
    cell.industryNumLb.text = [NSString stringWithFormat:@"剩余: %@",self.dataarr[indexPath.row][@"qy_count"]];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
//选择省
- (IBAction)tapgestureProvince:(UITapGestureRecognizer *)sender {
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr;
    vc.titlestr = @"请选择省份";
    vc.returnreslut = ^(NSInteger index){
        _ischosePro = index;
        _provinceLb.text = _provinceArr[index][@"province_name"];
        _cityLb.text = @"不限";
        _areaLb.text = @"不限";
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];

}
//选择市
- (IBAction)tapgestureCity:(UITapGestureRecognizer *)sender {
    
    if (self.provinceLb.text.length <= 0 || [self.provinceLb.text isEqualToString:@"不限"]) {
        [MBProgressHUD showError:@"请选择省份"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"];
    vc.titlestr = @"请选择城市";
    vc.returnreslut = ^(NSInteger index){
        _ischoseCity = index;
        _cityLb.text = _provinceArr[_ischosePro][@"city"][index][@"city_name"];
        _areaLb.text = @"不限";
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//选择区
- (IBAction)tapgestureArea:(UITapGestureRecognizer *)sender {
    
    if (self.cityLb.text.length <= 0 || [self.cityLb.text isEqualToString:@"不限"]) {
        [MBProgressHUD showError:@"请选择城市"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"];
    vc.titlestr = @"请选择区域";
    vc.returnreslut = ^(NSInteger index){
        _ischoseArea = index;
        _areaLb.text = _provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][index][@"country_name"];
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//查询
- (IBAction)queryEvent:(UIButton *)sender {
    
    [self initdatasource];
    
    
}


//我要报名
- (IBAction)signUpEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterWantToSignUpViewController *vc=[[LBMineCenterWantToSignUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
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
        toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
            
        }];
        
    }
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.chechBt.layer.cornerRadius = 4;
    self.chechBt.clipsToBounds = YES;
    
    self.signUpBt.layer.cornerRadius = 4;
    self.signUpBt.clipsToBounds = YES;
    
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;
    
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100 )
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@""]];
        
        _cycleScrollView.localizationImageNamesGroup = @[@"banner1(1)",@"banner2(1)",@"banner3(1)"];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }
    
    return _cycleScrollView;
    
}


@end
