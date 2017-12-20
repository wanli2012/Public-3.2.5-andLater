//
//  LBIntegralMallViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralMallViewController.h"
#import "GLIntegralHeaderView.h"
#import "GLIntegralMallTopCell.h"
#import "GLIntegralGoodsCell.h"

#import "GLHourseDetailController.h"
#import "GLIntegraClassifyController.h"

#import "GLMallHotModel.h"
#import "GLMall_InterestModel.h"

//城市定位 选择
#import "GLCityChooseController.h"

//公告
#import "GLHomePageNoticeView.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomePageNoticeView.h"
#import "GLConfirmOrderController.h"
#import "LBFrontView.h"
#import "GLAdModel.h"
#import "GLMine_AdController.h"

#import "LBStoreMoreInfomationViewController.h"//商家详情
#import "LBStoreProductDetailInfoViewController.h"//商品详情
#import "GLHomePageNoticeView.h"
#import "GLSet_MaskVeiw.h"
#import "LBmallSearchViewController.h"
#import "GLIntegralGoodsOneCell.h"
#import "GLIntegralGoodsTwoCell.h"
#import "WYWebController.h"
#import "GLShareView.h"
#import <Social/Social.h>
#import "UMSocial.h"
#import "LBintegralGoodsAciticityTableViewCell.h"
#import "LBCountDownActivityTableViewCell.h"
#import "LBCountDownActivityContraryTableViewCell.h"

@interface LBIntegralMallViewController ()<UITableViewDelegate,UITableViewDataSource,GLIntegralMallTopCellDelegete,GLIntegralGoodsCellDelegate,LBFrontViewdelegete,GLIntegralGoodsOnedelegete,GLIntegralGoodsTwodelegete,GLIntegralHeaderViewdelegete>
{
    LoadWaitView * _loadV;
    NSInteger _page;
    NSString *_htmlString;
    GLHomePageNoticeView *_contentView;
    GLSet_MaskVeiw *_maskV;
    GLShareView *_shareV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *hotModels;//五个商品
@property (nonatomic, strong)NSMutableArray *goods;//商品
@property (nonatomic, strong)NSMutableArray *bannerArr;//轮播图数组
@property (nonatomic, strong)NSDictionary *banner_url;//活动数组
@property (nonatomic, strong)NSMutableArray *beautiful;//精品推荐
@property (nonatomic, strong)NSMutableArray *modular_cate;//分类
@property (nonatomic, strong)NSMutableArray *activeArr;//活动数组
@property (nonatomic, strong)LBFrontView *frontView;
@property (nonatomic, strong)UIView *maskView;

@property (weak, nonatomic) IBOutlet UIImageView *footerimage;
@property (assign , nonatomic)NSInteger alreadyIndex;
@property (assign , nonatomic)CGFloat gg_bili_footer;
@property (assign , nonatomic)CGFloat gg_bili_header;
@property (assign , nonatomic)CGFloat active_banner;

@property (assign , nonatomic)CGFloat beautfHeight;//缓存精品推荐高度
@property (assign , nonatomic)CGFloat bannerOneH;//缓存高度
@property (assign , nonatomic)CGFloat bannerTwoH;//缓存高度
@property (assign , nonatomic)CGFloat bannerThreeH;//缓存高度
@property (nonatomic, assign)CGFloat goodOneH;
@property (nonatomic, assign)CGFloat goodTwoH;
@property (nonatomic, assign)CGFloat goodThreeH;
@property (nonatomic, assign)CGFloat goodFourH;
@property (nonatomic, assign)CGFloat hotGoodH;

@end

static NSString *topCellID = @"GLIntegralMallTopCell";
static NSString *goodsCellID = @"GLIntegralGoodsCell";
static NSString *goodsOneCellID = @"GLIntegralGoodsOneCell";
static NSString *goodsTwoCellID = @"GLIntegralGoodsTwoCell";
static NSString *integralGoodsAciticity = @"LBintegralGoodsAciticityTableViewCell";
static NSString *countDownActivityTableViewCell = @"LBCountDownActivityTableViewCell";
static NSString *countDownActivityContraryTableViewCell = @"LBCountDownActivityContraryTableViewCell";

@implementation LBIntegralMallViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralMallTopCell" bundle:nil] forCellReuseIdentifier:topCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralGoodsCell" bundle:nil] forCellReuseIdentifier:goodsCellID];
    [self.tableView registerNib:[UINib nibWithNibName:goodsOneCellID bundle:nil] forCellReuseIdentifier:goodsOneCellID];
    [self.tableView registerNib:[UINib nibWithNibName:goodsTwoCellID bundle:nil] forCellReuseIdentifier:goodsTwoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:integralGoodsAciticity bundle:nil] forCellReuseIdentifier:integralGoodsAciticity];
    [self.tableView registerNib:[UINib nibWithNibName:countDownActivityTableViewCell bundle:nil] forCellReuseIdentifier:countDownActivityTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:countDownActivityContraryTableViewCell bundle:nil] forCellReuseIdentifier:countDownActivityContraryTableViewCell];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf countDownActivity];
        [weakSelf postRequest];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest];//求情数据
    [self countDownActivity];
    /**
     * 数组tableHeaderView
     */
    self.tableView.tableHeaderView = self.frontView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];

}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)postRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    if ([UserModel defaultUser].loginstatus == YES) {
         dic[@"token"] = [UserModel defaultUser].token;
         dic[@"uid"] = [UserModel defaultUser].uid;
    }

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/main" paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"is_show"] integerValue] == 1 && _alreadyIndex == 0) {
            _alreadyIndex = 1;
            [self initInterDataSorceinfomessage];
        }
        if ([responseObject[@"banner_bili"] floatValue] > 0) {
            self.frontView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60 + SCREEN_WIDTH * ([responseObject[@"banner_bili"] floatValue]));
        }
        self.gg_bili_header = [responseObject[@"gg_bili_header"] floatValue];
        self.gg_bili_footer = [responseObject[@"gg_bili_footer"] floatValue];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",responseObject[@"kf_url"]] forKey:@"kf_url"];

        if ([responseObject[@"code"] integerValue] == 1){

                [self.hotModels removeAllObjects];
                [self.goods removeAllObjects];
                [self.bannerArr removeAllObjects];
                [self.beautiful removeAllObjects];
                
                if([responseObject[@"data"][@"five_goods"] count]){
                    
                    for (NSDictionary *dic in responseObject[@"data"][@"five_goods"]) {
                        
                        GLMallHotModel *model = [GLMallHotModel mj_objectWithKeyValues:dic];
                        [_hotModels addObject:model];
                    }
                }
            
                if ([responseObject[@"data"][@"advert"] count] != 0) {
                    [self.bannerArr removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"data"][@"advert"]) {
                        GLAdModel *model = [GLAdModel mj_objectWithKeyValues:dic];
                        [self.bannerArr addObject:model];
                    }
                }

                if (self.bannerArr.count > 0) {
                    NSMutableArray *imageAr = [NSMutableArray array];
                    for (int i = 0; i < self.bannerArr.count; i ++) {
                        GLAdModel *model = self.bannerArr[i];
                        [imageAr addObject:model.thumb];
                    }
                    
                    [self.frontView reloadImage:imageAr];

                }
            
            [self.goods addObjectsFromArray:responseObject[@"data"][@"goods"]];
            [self.beautiful addObjectsFromArray:responseObject[@"data"][@"beautiful"]];
            self.modular_cate = responseObject[@"data"][@"modular_cate"];
            self.banner_url = responseObject[@"data"][@"banner_url"];
            
            if (self.banner_url.count > 0) {
                NSString *urlstr = [NSString stringWithFormat:@"%@",self.banner_url[@"name1"][@"thumb"]];
                if (urlstr.length > 0 && [urlstr rangeOfString:@"null"].location == NSNotFound) {
                    self.bannerOneH = SCREEN_WIDTH * _gg_bili_header;
                }
                NSString *urlstr1 = [NSString stringWithFormat:@"%@",self.banner_url[@"name2"][@"thumb"]];
                if (urlstr1.length > 0 && [urlstr1 rangeOfString:@"null"].location == NSNotFound) {
                    self.bannerTwoH = SCREEN_WIDTH * _gg_bili_header;
                }
                NSString *urlstr2 = [NSString stringWithFormat:@"%@",self.banner_url[@"name0"][@"thumb"]];
                if (urlstr2.length > 0 && [urlstr2 rangeOfString:@"null"].location == NSNotFound) {
                    self.bannerThreeH = SCREEN_WIDTH * _gg_bili_header;
                }
            }
            
            if (self.hotModels.count > 0) {
                self.hotGoodH =  (SCREEN_WIDTH -2 )/3.0 * 7/5.0;
            }
            
            NSString *imageurl = [NSString stringWithFormat:@"%@",self.banner_url[@"name3"][@"thumb"]];
            if (imageurl.length <=0 || [imageurl rangeOfString:@"null"].location != NSNotFound) {
                self.tableView.tableFooterView.height = 0;
                self.footerimage.hidden = YES;
            }else{
                [self.footerimage sd_setImageWithURL:[NSURL URLWithString:self.banner_url[@"name3"][@"thumb"]] placeholderImage:nil];
                self.tableView.tableFooterView.height =  SCREEN_WIDTH * _gg_bili_footer;
                self.footerimage.hidden = NO;
            }
            
        }else{
         [self.view.window makeToast:responseObject[@"message"] duration:2.0 position:CSToastPositionCenter];
        }
        
        [self.tableView reloadData];
     
    } enError:^(NSError *error) {
       [_loadV removeloadview];
        [self endRefresh];
        [self.view.window makeToast:@"请求失败，请检查网络" duration:2.0 position:CSToastPositionCenter];
    }];

}
//商品秒杀
-(void)countDownActivity{
    
    [NetworkManager requestPOSTWithURLStr:@"Active/get_mark_active" paramDic:@{} finish:^(id responseObject) {
    
        if ([responseObject[@"code"] integerValue] == 1){

            self.active_banner = [responseObject[@"active_banner"] floatValue];
            [self.activeArr removeAllObjects];
    
            if ([responseObject[@"data"] count] > 0) {
                
                for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                    LBCountDownmodel *model = [LBCountDownmodel mj_objectWithKeyValues:responseObject[@"data"][i]];
                    [self.activeArr addObject:model];

                }
                 [self.tableView reloadData];
            }
        }
    } enError:^(NSError *error) {
      
    }];
}

#pragma mark ----- 点击轮播图查看详情
-(void)clickScrollViewImage:(NSInteger)index{

    if(self.self.bannerArr.count == 0){
        return;
    }
    
    GLAdModel *model = self.self.bannerArr[index];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([model.type integerValue] == 1) {//内部广告
        
        if([model.jumptype integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = model.jumpid;
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else if([model.jumptype integerValue] == 2){//跳转商品
            
            if ([model.goodstype integerValue] == 1) {//逛逛商品
                
                LBStoreProductDetailInfoViewController *storeVC = [[LBStoreProductDetailInfoViewController alloc] init];
                storeVC.goodId = model.jumpid;
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else{
                
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id = model.jumpid;
                goodsVC.type = 1;
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
            
        }else if([model.jumptype integerValue] == 3){//跳转商品类型
            self.hidesBottomBarWhenPushed = YES;
            GLIntegraClassifyController *vc = [[GLIntegraClassifyController alloc] init];
            vc.jumpindex = 4;
            vc.classifyid = model.jumpid;
            vc.catename = model.cate_name;
            vc.classftyArr = self.modular_cate;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }

    }else if([model.type integerValue] == 2){//外部广告
        
        GLMine_AdController *adVC = [[GLMine_AdController alloc] init];
        adVC.url = model.url;
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

-(void)tapgesturesearch{
    
    self.hidesBottomBarWhenPushed = YES;
    LBmallSearchViewController *searchVC = [[LBmallSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
//跳转客服
- (IBAction)jumpClassifty:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLIntegraClassifyController *vc = [[GLIntegraClassifyController alloc] init];
    vc.jumpindex = 4;
    vc.classftyArr = self.modular_cate;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//跳转商品分类
- (IBAction)jumpservice:(UIButton *)sender {
    
    CGFloat shareVH = SCREEN_HEIGHT /5;
    
    if (_shareV == nil) {
        
        _shareV = [[NSBundle mainBundle] loadNibNamed:@"GLShareView" owner:nil options:nil].lastObject;
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
        [_shareV.weiboShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.weixinShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.friendShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.maskView addSubview:_shareV];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT - shareVH, SCREEN_WIDTH, shareVH);
    }];
    
    
}
- (void)shareClick:(UIButton *)sender {
    
    if (sender == _shareV.weiboShareBtn) {
        [self shareTo:@[UMShareToSina]];
    }else if (sender == _shareV.weixinShareBtn){
        [self shareTo:@[UMShareToWechatSession]];
    }else if (sender == _shareV.friendShareBtn){
        [self shareTo:@[UMShareToWechatTimeline]];
    }
    
}
- (void)shareTo:(NSArray *)type{
    [self.maskView removeFromSuperview];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = DOWNLOAD_URL;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = DOWNLOAD_URL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = DOWNLOAD_URL;
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"大众共享，让每一个有心参与公益事业的人都能参与进来(用safari浏览器打开)%@",@"https://www.51dztg.com/index.php/Home/Regist/xiazai"] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}

-(void)tapgestureMaskSgare{
    [self.maskView removeFromSuperview];

}


-(void)clickJimpGoodsClassify:(NSInteger)section{

    self.hidesBottomBarWhenPushed = YES;
    GLIntegraClassifyController *vc = [[GLIntegraClassifyController alloc] init];
    if (section < 3) {
        vc.jumpindex = section;
    }else{
        vc.jumpindex = 3;
        vc.classftyname = self.beautiful[section - 3][@"chinese_title"];
    }
    
    vc.classftyArr = self.modular_cate;
    
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}
// 点击底部广告
- (IBAction)footerimageTap:(UITapGestureRecognizer *)sender {
    
    [self jumpActivityDetail:@"name3"];
}


-(void)tapActivityimageTwo:(NSIndexPath *)indexpath{

    if (indexpath.section == 0) {
        [self jumpActivityDetail:@"name0"];
    }else if (indexpath.section == 1){
        [self jumpActivityDetail:@"name1"];
    }else if (indexpath.section == 2){
        [self jumpActivityDetail:@"name2"];
    }

}

-(void)jumpActivityDetail:(NSString*)key{

    if (self.banner_url.count <= 0) {
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([self.banner_url[key][@"type"] integerValue] == 1) {//内部广告
        
        if([self.banner_url[key][@"jumptype"] integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = self.banner_url[key][@"jumpid"] ;
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else if([self.banner_url[key][@"jumptype"] integerValue] == 2){//跳转商品
            
            if ([self.banner_url[key][@"goodstype"] integerValue] == 1) {//逛逛商品
                
                LBStoreProductDetailInfoViewController *storeVC = [[LBStoreProductDetailInfoViewController alloc] init];
                storeVC.goodId = self.banner_url[key][@"jumpid"];
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else{
                
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id = self.banner_url[key][@"jumpid"];
                goodsVC.type = 1;
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
            
        }else if([self.banner_url[key][@"jumptype"] integerValue] == 3){//跳转商品类型
            self.hidesBottomBarWhenPushed = YES;
            GLIntegraClassifyController *vc = [[GLIntegraClassifyController alloc] init];
            vc.jumpindex = 4;
            vc.classifyid = self.banner_url[key][@"jumpid"];
            vc.catename = self.banner_url[key][@"cate_name"];
            vc.classftyArr = self.modular_cate;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }else if([self.banner_url[key][@"type"] integerValue] == 2){//外部广告
        
        GLMine_AdController *adVC = [[GLMine_AdController alloc] init];
        if([self.banner_url[key][@"url"] rangeOfString:@"Home/Union/index.html"].location !=NSNotFound)//_roaldSearchText
        {
            if ([UserModel defaultUser].loginstatus == YES) {
                NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"shundaopublic_key.der" ofType:nil];
                NSString *encryptedtoken = [RSAEncryptor encryptString:[UserModel defaultUser].token publicKeyWithContentsOfFile:public_key_path];
                NSString *encrypteduid = [RSAEncryptor encryptString:[UserModel defaultUser].uid publicKeyWithContentsOfFile:public_key_path];
                
                adVC.url = [NSString stringWithFormat:@"%@?token=%@&uid=%@",self.banner_url[key][@"url"],encryptedtoken,encrypteduid];

            }else{
                adVC.url = [NSString stringWithFormat:@"%@?token=@""&uid=@""",self.banner_url[key][@"url"]];

            }
        }else{
             adVC.url =self.banner_url[key][@"url"];
        }
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    self.hidesBottomBarWhenPushed = NO;


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self countDownActivity];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
}

#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + self.beautiful.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2 + self.activeArr.count;
    }else if (section >= 3){
        return 1;
    }
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section >= 3){
//        if(self.beautiful.count >=3 ){
        
            if ([self.beautiful[section - 3][@"goods"]count] <= 0) {
                return 0;
            }
//        }
    }else if (section == 1 || section == 2){
        if (self.goods.count > 0) {
            if ([self.goods[section - 1][@"data"][@"one"] count] <= 0 && [self.goods[section - 1][@"data"][@"two"] count] <= 0) {
                return 0;
            }
        }else{
            return 0;
        }
    
    }
   
    return 65;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        GLIntegralHeaderView *headerVeiw = [[NSBundle mainBundle] loadNibNamed:@"GLIntegralHeaderView" owner:nil options:nil].lastObject;
        headerVeiw.delegate = self;
        headerVeiw.section = section;
        if (section == 1) {
            headerVeiw.subtitleLb.text = @"热 卖 推 荐";
            headerVeiw.titileLb.text = @"HOT SALE";
            if (self.goods.count > 0) {
                if ([self.goods[section - 1][@"data"][@"one"] count] <= 0 && [self.goods[section - 1][@"data"][@"two"] count] <= 0) {
                    return nil;
                }
            }else{
                return nil;
            }
        }else if (section == 2){
            headerVeiw.subtitleLb.text = @"尖 货 热 销";
            headerVeiw.titileLb.text = @"HOT CAKES";
             if (self.goods.count > 0) {
                if ([self.goods[section - 1][@"data"][@"one"] count] <= 0 && [self.goods[section - 1][@"data"][@"two"] count] <= 0) {
                    return nil;
                }
            }else{
                return nil;
            }
        }else if (section >= 3){
            if ([self.beautiful[section - 3][@"goods"]count] <= 0) {
                return nil;
            }
            headerVeiw.subtitleLb.text = [NSString stringWithFormat:@"%@",self.beautiful[section - 3][@"chinese_title"]];
            headerVeiw.titileLb.text = [NSString stringWithFormat:@"%@",self.beautiful[section - 3][@"english_title"]];
        }
        return headerVeiw;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0) {
        
        if (self.activeArr.count > 0) {
            if (indexPath.row < self.activeArr.count) {
                if (indexPath.row % 2 == 0) {
                    LBCountDownActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countDownActivityTableViewCell forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = self.activeArr[indexPath.row];
                    return cell;
                }else{
                    LBCountDownActivityContraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countDownActivityContraryTableViewCell forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = self.activeArr[indexPath.row];
                    return cell;
                }
            }else  if (indexPath.row == self.activeArr.count) {
                GLIntegralMallTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegete = self;
                cell.models = self.hotModels;
                return cell;
            }else  if (indexPath.row == self.activeArr.count + 1) {
                LBintegralGoodsAciticityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsAciticity forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.indexpath = indexPath;
                if (self.banner_url.count > 0) {
                    [cell loadimage:self.banner_url[@"name0"][@"thumb"] isGif:self.banner_url[@"name0"][@"img_type"]];
                }
                return cell;
            }
        }else{
            if (indexPath.row == 0) {
                GLIntegralMallTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegete = self;
                cell.models = self.hotModels;
                return cell;
            }else  if (indexPath.row == 1) {
                LBintegralGoodsAciticityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsAciticity forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.indexpath = indexPath;
                if (self.banner_url.count > 0) {
                    [cell loadimage:self.banner_url[@"name0"][@"thumb"] isGif:self.banner_url[@"name0"][@"img_type"]];
                }
                return cell;
            }
            
        }
        
    }else if(indexPath.section== 1 || indexPath.section== 2) {
        if (indexPath.row == 0) {
            GLIntegralGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.goods.count > 0) {
                   [cell refreshDatasource:self.goods[indexPath.section - 1][@"data"][@"one"] ];
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            cell.delegate  = self;
            if (indexPath.section == 1) {
                self.goodOneH = cell.goodOneH;
            }else if (indexPath.section == 2){
                self.goodTwoH = cell.goodOneH;
            }
        
            return cell;
        }else if (indexPath.row == 1){
            GLIntegralGoodsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsOneCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.goods.count > 0) {
                [cell refreshDataSorce:self.goods[indexPath.section - 1][@"data"][@"two"] ];
            }
            cell.index = indexPath.section;
            cell.delegete = self;
            if (indexPath.section == 1) {
                self.goodThreeH = cell.goodTwoH;
            }else if (indexPath.section == 2){
                self.goodFourH = cell.goodTwoH;
            }
            
            return cell;
        }else if (indexPath.row == 2){
             LBintegralGoodsAciticityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsAciticity forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexpath = indexPath;
            if (indexPath.section== 1) {
                if (self.banner_url.count > 0) {
                   [cell loadimage:self.banner_url[@"name1"][@"thumb"] isGif:self.banner_url[@"name1"][@"img_type"]];
                }
            }else{
                if (self.banner_url.count > 0) {
                    [cell loadimage:self.banner_url[@"name2"][@"thumb"] isGif:self.banner_url[@"name2"][@"img_type"]];
                }
            }
            
            return cell;
        }

    }else{
        GLIntegralGoodsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsTwoCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshdataSource:self.beautiful[indexPath.section - 3][@"goods"]];
        self.beautfHeight = cell.beautfHeight;
        cell.delegate = self;
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (self.activeArr.count > 0) {
            if (indexPath.row < self.activeArr.count) {
                return 140;
            }else  if (indexPath.row == self.activeArr.count) {
                return self.hotGoodH;
            }else  if (indexPath.row == self.activeArr.count + 1) {
                return self.bannerThreeH;
            }
        }else{
            if (indexPath.row == 0) {
                return self.hotGoodH;
            }else  if (indexPath.row == 1) {
                return self.bannerThreeH;
            }
            
        }

        return 0;
        
    }else  if (indexPath.section ==1 || indexPath.section ==2){
        if (indexPath.row == 0) {
            if (indexPath.section == 1) {
                     return self.goodOneH;
            }else{
                    return self.goodThreeH;
            }

        }else if(indexPath.row == 1){
            if (indexPath.section == 1) {
                 return self.goodTwoH;
            }else{
                 return self.goodFourH;
            }

        }else if(indexPath.row == 2){
            
            if (indexPath.section == 1) {
               return self.bannerOneH;
            }else{
                return self.bannerTwoH;
            }
        }
        
        return 0;
    }else{
        return self.beautfHeight;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (self.activeArr.count > 0) {
            if (indexPath.row < self.activeArr.count) {
                self.hidesBottomBarWhenPushed = YES;
                LBCountDownmodel *model = self.activeArr[indexPath.row];
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id =  model.goods_id;
                goodsVC.type = 1;
                [self.navigationController pushViewController:goodsVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else  if (indexPath.row == self.activeArr.count + 1) {
                    [self tapActivityimageTwo:indexPath];
            }
        }else{
            if (indexPath.row == 2) {
                [self tapActivityimageTwo:indexPath];
            }
        }
       
    }else  if (indexPath.section ==1 || indexPath.section ==2){
        
        if(indexPath.row == 2){
            [self tapActivityimageTwo:indexPath];
        }
        
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight =  65;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark -----GLIntegralGoodsCellDelegate
-(void)clickcheckDetail:(NSString *)goodid{

    [self jumpGoodsInfo:goodid];

}
-(void)clickGoodsdetail:(NSString *)goodsid{
    [self jumpGoodsInfo:goodsid];
}
-(void)clickCheckGoodsinfo:(NSString *)goodid{

     [self jumpGoodsInfo:goodid];
}

-(void)jumpGoodsInfo:(NSString *)goodsid{

    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    detailVC.navigationItem.title = @"米券兑换详情";
    detailVC.type = 1;
    detailVC.goods_id = goodsid;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark == GLIntegralMallTopCellDelegete

-(void)tapgestureTag:(NSInteger)Tag{
    if (self.hotModels.count <= 0) {
        return;
    }
    GLMallHotModel *model = self.hotModels[Tag - 1];
   
    self.hidesBottomBarWhenPushed = YES;
    
    if ([model.type integerValue] == 1) {//内部广告
        
        if([model.jumptype integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = model.jumpid ;
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else if([model.jumptype integerValue] == 2){//跳转商品
            
            if ([model.goodstype integerValue] == 1) {//逛逛商品
                
                LBStoreProductDetailInfoViewController *storeVC = [[LBStoreProductDetailInfoViewController alloc] init];
                storeVC.goodId = model.jumpid;
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else{
                
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id =  model.jumpid;
                goodsVC.type = 1;
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
            
        }else if([model.jumptype integerValue] == 3){//跳转商品类型
            self.hidesBottomBarWhenPushed = YES;
            GLIntegraClassifyController *vc = [[GLIntegraClassifyController alloc] init];
            vc.jumpindex = 4;
            vc.classifyid = model.jumpid;
            vc.catename = model.cate_name;
            vc.classftyArr = self.modular_cate;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }else if([ model.type integerValue] == 2){//外部广告
        
        GLMine_AdController *adVC = [[GLMine_AdController alloc] init];
        adVC.url = model.url;
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark ----公告

-(void)initInterDataSorceinfomessage{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isShow"];//展示过就不要展示了，重启App在调
    
    CGFloat contentViewH = SCREEN_HEIGHT / 2;
    CGFloat contentViewW = SCREEN_WIDTH - 40;
    CGFloat contentViewX = 20;
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _maskV.bgView.alpha = 0.3;
    
    _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLHomePageNoticeView" owner:nil options:nil].lastObject;
    _contentView.contentViewW.constant = SCREEN_WIDTH - 40;
    _contentView.contentViewH.constant = SCREEN_HEIGHT / 2 - 30;
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    [_contentView.cancelBt addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //设置webView
    _contentView.webView.scalesPageToFit = YES;
    _contentView.webView.autoresizesSubviews = NO;
    _contentView.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    _contentView.webView.scrollView.bounces = NO;
    
    NSURL *url = [NSURL URLWithString:NOTICE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_contentView.webView loadRequest:request];
    [_maskV showViewWithContentView:_contentView];
    
    _contentView.frame = CGRectMake(contentViewX, (SCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    //缩放
    _contentView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        
        _contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _contentView.alpha = 1;
    }];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _maskV.transform = CGAffineTransformMakeScale(0.07, 0.07);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _maskV.center = CGPointMake(SCREEN_WIDTH - 30,30);
        } completion:^(BOOL finished) {
            [_maskV removeFromSuperview];
        }];
    }];
}


-(NSMutableAttributedString*)setLabelAttribute:(NSString*)Atrrstr text:(NSString*)str{

    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:Atrrstr];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rangel];

    return textColor;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
 
    
}
- (NSMutableArray *)hotModels{
    if (!_hotModels) {
        _hotModels = [NSMutableArray array];
    }
    return _hotModels;
}
- (NSMutableArray *)goods{
    if (!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}
- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
- (NSDictionary *)banner_url{
    if (!_banner_url) {
        _banner_url = [NSDictionary dictionary];
    }
    return _banner_url;
}
- (NSMutableArray *)beautiful{
    if (!_beautiful) {
        _beautiful = [NSMutableArray array];
    }
    return _beautiful;
}
- (NSMutableArray *)modular_cate{
    if (!_modular_cate) {
        _modular_cate = [NSMutableArray array];
    }
    return _modular_cate;
}
- (NSMutableArray *)activeArr{
    if (!_activeArr) {
        _activeArr = [NSMutableArray array];
    }
    return _activeArr;
}
-(LBFrontView*)frontView{

    if (!_frontView) {
        _frontView = [[LBFrontView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 * autoSizeScaleX)];
        _frontView.delegete = self;
    }
    
    return _frontView;

}
-(UIView*)maskView{

    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMaskSgare)];
        [_maskView addGestureRecognizer:tapgesture];
    }
    
    return _maskView;

}

@end
