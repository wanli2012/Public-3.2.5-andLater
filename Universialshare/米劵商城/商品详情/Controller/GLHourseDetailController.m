                    //
//  GLHourseDetailController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailController.h"
#import "SDCycleScrollView.h"
#import "GLHourseDetailFirstCell.h"

#import "GLHourseDetailThirdCell.h"
#import "GLTwoButtonCell.h"
#import "GLImage_textDetailCell.h"
#import "GLHourseOptionCell.h"
#import "GLHourseChangeNumCell.h"

#import "GLEvaluateCell.h"
#import "GLConfirmOrderController.h"

#import "GLHourseOptionModel.h"
#import "GLShoppingCartController.h"

#import "GLGoodsDetailModel.h"
#import "GLShoppingCartController.h"
#import "JZAlbumViewController.h"
#import "NTESSessionViewController.h"
#import "LBRichTextLinksview.h"
#import "WYWebController.h"
#import "LBintegralGoodsTelTableViewCell.h"
#import "LBRiceShopTagTableViewCell.h"
#import "LBriceshopwebviewTableViewCell.h"
#import "LBGoodsDetailOtherRecommendCell.h"
#import "LBGoodsDetailRecommendListCell.h"
#import "LBGoodsDetailPromotionTableViewCell.h"

@interface GLHourseDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GLTwoButtonCellDelegate,GLHourseChangeNumCellDelegate,UIWebViewDelegate,LBRiceShopTagViewDelegate,LBGoodsDetailRecommendListDelegate,LBriceshopwebviewTableViewdelegete>
{
    NSMutableArray *_visableCells;
    //status:??
    int _status;
    LoadWaitView * _loadV;
    NSInteger _sum;
    NSIndexPath *_indexPath;//加减cell的IndexPath
}

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)LBRichTextLinksview *richTextLinksview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *cellArr;
@property (nonatomic, strong)GLGoodsDetailModel *model;
@property (assign, nonatomic) NSInteger is_collection;//是否收藏

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic, copy)NSString *goods_spec;//规格项名字 如果是两个就用+拼接  例子:紫色+m
@property (nonatomic, copy)NSString *option_promotion_content;//促销描述
@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏
@property(assign , nonatomic)CGPoint offset;//记录偏移

@property(assign , nonatomic)CGFloat loadweb;//判断是否加载完成链接

@property(strong , nonatomic)NSArray *titleArr;//属性数组
@property(strong , nonatomic)NSString *NewPrice;//现价
@property(strong , nonatomic)NSString *coupoes;//代米券
@property(strong , nonatomic)NSString *attributeId;//属性id

@property (nonatomic ,assign) CGFloat tagViewHeight;
@property (nonatomic ,assign) CGFloat webHeight;
@property (nonatomic ,assign) CGFloat shiftGoodsH;

@end

static NSString *firstCell = @"GLHourseDetailFirstCell";
static NSString *thirdCell = @"GLHourseDetailThirdCell";
static NSString *twoButtonCell = @"GLTwoButtonCell";
static NSString *image_textCell = @"GLImage_textDetailCell";
static NSString *bottomCell = @"GLBottomCell";
static NSString *evaluateCell = @"GLEvaluateCell";
static NSString *optionCell = @"GLHourseOptionCell";
static NSString *changeNumCell = @"GLHourseChangeNumCell";
static NSString *integralGoodsTelTableViewCell = @"LBintegralGoodsTelTableViewCell";
static NSString *riceShopTagTableViewCell = @"LBRiceShopTagTableViewCell";
static NSString *riceshopwebviewTableViewCell = @"LBriceshopwebviewTableViewCell";
static NSString *goodsDetailOtherRecommendCell = @"LBGoodsDetailOtherRecommendCell";
static NSString *goodsDetailRecommendListCell = @"LBGoodsDetailRecommendListCell";
static NSString *goodsDetailPromotionTableViewCell = @"LBGoodsDetailPromotionTableViewCell";

@implementation GLHourseDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self registerCells];
    self.webHeight = 40;
    _sum = 1;
    self.navigationItem.title = @"详情";
    _option_promotion_content = @"";
    self.NewPrice = [NSString stringWithFormat:@"价格:¥0"];
    self.coupoes = @"";
    _loadweb = 0;
    _status = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.goods_spec = @"";
    _sum = 1;
//    self.navigationItem.title = @"房子详情";
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180 *autoSizeScaleY)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
    
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.clipsToBounds = YES;
    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    
    self.tableView.tableHeaderView = _cycleScrollView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;

    _visableCells = [NSMutableArray array];
    [self postRequest];
   [self initSpecificationsDataSoruce];

}

-(void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseDetailFirstCell" bundle:nil] forCellReuseIdentifier:firstCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseDetailThirdCell" bundle:nil] forCellReuseIdentifier:thirdCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLTwoButtonCell" bundle:nil] forCellReuseIdentifier:twoButtonCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLImage_textDetailCell" bundle:nil] forCellReuseIdentifier:image_textCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLImage_textDetailCell" bundle:nil] forCellReuseIdentifier:image_textCell];
    [self.tableView registerNib:[UINib nibWithNibName:integralGoodsTelTableViewCell bundle:nil] forCellReuseIdentifier:integralGoodsTelTableViewCell];
     [self.tableView registerNib:[UINib nibWithNibName:riceShopTagTableViewCell bundle:nil] forCellReuseIdentifier:riceShopTagTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLEvaluateCell" bundle:nil] forCellReuseIdentifier:evaluateCell];
    [self.tableView registerClass:[GLHourseOptionCell class] forCellReuseIdentifier:optionCell];
    [self.tableView registerNib:[UINib nibWithNibName:changeNumCell bundle:nil] forCellReuseIdentifier:changeNumCell];
     [self.tableView registerNib:[UINib nibWithNibName:riceshopwebviewTableViewCell bundle:nil] forCellReuseIdentifier:riceshopwebviewTableViewCell];
     [self.tableView registerNib:[UINib nibWithNibName:goodsDetailOtherRecommendCell bundle:nil] forCellReuseIdentifier:goodsDetailOtherRecommendCell];
    [self.tableView registerNib:[UINib nibWithNibName:goodsDetailRecommendListCell bundle:nil] forCellReuseIdentifier:goodsDetailRecommendListCell];
     [self.tableView registerNib:[UINib nibWithNibName:goodsDetailPromotionTableViewCell bundle:nil] forCellReuseIdentifier:goodsDetailPromotionTableViewCell];
}

- (void)postRequest{

    NSDictionary *dict;
    if ([UserModel defaultUser].loginstatus == YES) {
        dict =@{@"goods_id":self.goods_id,@"uid":[UserModel defaultUser].uid,@"token":[UserModel defaultUser].token};
    }else{
        dict =@{@"goods_id":self.goods_id};
    }
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    _loadV.isTap = YES;
    [NetworkManager requestPOSTWithURLStr:@"Shop/goodsDetail" paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                self.model = [GLGoodsDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                self.cycleScrollView.imageURLStringsGroup = responseObject[@"data"][@"details_banner"];
                
            }
        }
        
        [self.tableView reloadData];
        [_loadV removeloadview];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView reloadData];
    }];
    
}
//联系客服
- (IBAction)ContactCustomerService:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    WYWebController *vc=[[WYWebController alloc]init];
    vc.url = [[NSUserDefaults standardUserDefaults]objectForKey:@"kf_url"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//收藏
- (IBAction)collection:(id)sender {

    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if (self.is_collection  == 0) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goods_id;
        dict[@"type"] = @(self.type);
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                
                [self.collectionBtn setImage:[UIImage imageNamed:@"collect_select_icon"] forState:UIControlStateNormal];
                self.is_collection = 1;
                [MBProgressHUD showSuccess:@"收藏成功"];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
        
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goods_id;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
    
                [self.collectionBtn setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];
                self.is_collection = 0;
                if (self.is_notice == YES) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"GLMyCollectionController" object:nil];
                }
                
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
    }
}


#pragma mark -- 去结算
//去结算 订单确认
- (IBAction)confirmOrder:(id)sender {
    self.hidesBottomBarWhenPushed = YES;

    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if ([UserModel defaultUser].isSetTwoPwd == 0) {
        [MBProgressHUD showError:@"请先在设置中设置支付密码"];
        return;
    }
    
    if (_sum <= 0) {
        [MBProgressHUD showError:@"数量不能为0"];
        return;
    }
    if (self.goods_spec.length <= 0) {
        [MBProgressHUD showError:@"还未选择规格"];
        return;
    }
    
    [self getOrderRequest];

}

- (void)getOrderRequest {

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"token"] = [UserModel defaultUser].token;
    dict1[@"uid"] = [UserModel defaultUser].uid;
    dict1[@"goods_id"] = self.goods_id;
    dict1[@"goods_count"] = @(_sum);
    dict1[@"goods_spec"] = self.attributeId;
    
    //请求商品信息
    [NetworkManager requestPOSTWithURLStr:@"Shop/placeOrderBefore" paramDic:dict1 finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            self.hidesBottomBarWhenPushed= YES;
            GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
            vc.orderType = 2; //订单类型
            vc.dataDic = responseObject[@"data"];
            vc.goods_id = self.goods_id;
            vc.goods_spec = self.attributeId;
            vc.goods_count = [NSString stringWithFormat:@"%ld",_sum];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
}


- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
        
    }
    return _cellArr;
}

#pragma mark -- SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma UITableviewDelegate UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return 9;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *GLcell;
    
    if (indexPath.row == 0) {
       
        GLHourseDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHourseDetailFirstCell" forIndexPath:indexPath];
        cell.model = self.model;
        cell.fanliLabel.text =  _NewPrice;
        cell.coupoesLb.text = _coupoes;

        GLcell = cell;
      
    }else if(indexPath.row == 1){
        
        LBGoodsDetailPromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsDetailPromotionTableViewCell forIndexPath:indexPath];
        if ( (self.option_promotion_content.length <= 0 || [self.option_promotion_content rangeOfString:@"null"].location != NSNotFound  )) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
            cell.discountInfo.text = [NSString stringWithFormat:@"%@",self.option_promotion_content];
        }
        GLcell = cell;
        
    }else if(indexPath.row == 2){
        
        LBintegralGoodsTelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integralGoodsTelTableViewCell forIndexPath:indexPath];
        if (self.model.shop_phone.length <= 0 || [self.model.shop_phone rangeOfString:@"null"].location != NSNotFound) {
            cell.hidden = YES;
        }else{
           cell.hidden = NO;
            cell.phone = _model.shop_phone;
            [cell.telBt setTitle:_model.shop_phone forState:UIControlStateNormal];
        }
        GLcell = cell;
        
    }else if(indexPath.row == 3){
        
        GLHourseChangeNumCell *cell = [tableView dequeueReusableCellWithIdentifier:changeNumCell forIndexPath:indexPath];
        cell.indexPath = indexPath;
        _indexPath = indexPath;
        cell.delegate = self;
        
        cell.sumLabel.text = [NSString stringWithFormat:@"%zd",_sum];
       
        GLcell = cell;
        
    }else if(indexPath.row == 4){
        
        LBRiceShopTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:riceShopTagTableViewCell forIndexPath:indexPath];
        cell.dwqTagV.delegate = self;
        /** 将通过数组计算出的tagV的高度存储 */
        cell.hotSearchArr = self.titleArr;
        self.tagViewHeight = cell.dwqTagV.frame.size.height;
        if (self.titleArr.count <= 0) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        GLcell = cell;
        
    }else if(indexPath.row == 5){

        GLHourseDetailThirdCell *cell = [[GLHourseDetailThirdCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) andDatasource:@[] :@"更多商品信息" ];
        if (self.model.goods_details.length > 0 && [self.model.goods_details rangeOfString:@"null"].location == NSNotFound) {
           cell.hidden = NO;
        }else{
           cell.hidden = YES;
        }
    
        GLcell = cell;

    }
    else if(indexPath.row == 6){
        
        LBriceshopwebviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:riceshopwebviewTableViewCell forIndexPath:indexPath];
        if (cell.isload == NO) {
            if (self.model.goods_details.length > 0 && [self.model.goods_details rangeOfString:@"null"].location == NSNotFound) {
                [cell.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.goods_details]]];
                cell.isload =YES;
            }
        }
        //cell.delegate = self;
        cell.webview.delegate = self;
        GLcell = cell;
        
    }
    else if(indexPath.row == 7){
        
        LBGoodsDetailOtherRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsDetailOtherRecommendCell forIndexPath:indexPath];
        if (self.model.shift_goods.count <= 0) {
            cell.hidden = YES;
        }

        GLcell = cell;
    }
    else if(indexPath.row == 8){
        
        LBGoodsDetailRecommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsDetailRecommendListCell forIndexPath:indexPath];
        [cell refreshDataSorce:self.model.shift_goods];
        self.shiftGoodsH = cell.shiftGoodsH;
        cell.delegate = self;
        GLcell = cell;
        
    }
    
    GLcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return GLcell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        tableView.estimatedRowHeight = 44;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return tableView.rowHeight;
        
    }else if (indexPath.row == 1 ){
        if ( (self.option_promotion_content.length <= 0 || [self.option_promotion_content rangeOfString:@"null"].location != NSNotFound )) {
              return 0;
        }else{
            tableView.estimatedRowHeight = 30;
            tableView.rowHeight = UITableViewAutomaticDimension;
            return tableView.rowHeight;
        }
        
    }else if (indexPath.row == 2 ){
        
        if (self.model.shop_phone.length <= 0 || [self.model.shop_phone rangeOfString:@"null"].location != NSNotFound) {
            return 0;
        }
        return 90;
        
    }else if (indexPath.row == 3 ){

        return 70;
        
    }else if (indexPath.row == 4 ){
        if (self.titleArr.count > 0) {
            return self.tagViewHeight + 20;
        }
        
    }else if (indexPath.row ==5 ){
        
        if (self.model.goods_details.length > 0 && [self.model.goods_details rangeOfString:@"null"].location == NSNotFound) {
            return 35;
        }
        
    }else if (indexPath.row ==6 ){
        
        return self.webHeight;
        
    }else if (indexPath.row ==7 ){
        
        if (self.model.shift_goods.count > 0) {
            return 40;
        }
        
    }else if (indexPath.row ==8 ){
        

    return self.shiftGoodsH;

    }
    return 0;
    
}

#pragma mark ----- uiwebviewdelegete
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    

    CGFloat webViewHeight=[webView.scrollView contentSize].height;
   
    self.webHeight = webViewHeight + 10;

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];  //你需要更新的组数中的cell
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma  mark ----- LBriceshopwebviewTableViewdelegete
-(void)refreshWebHeigt:(CGFloat)webheight{

    if (self.webHeight == webheight) {
        return;
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];  //你需要更新的组数中的cell
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}
#pragma mark ------LBRiceShopTagViewDelegate
-(void)LBRiceShopTagView:(UIView *)dwq fetchWordToTextFiled:(NSDictionary *)dic{

    self.NewPrice = [NSString stringWithFormat:@"价格:¥%@",dic[@"marketprice"] ];
    self.attributeId = [NSString stringWithFormat:@"%@",dic[@"id"] ];
    self.option_promotion_content = [NSString stringWithFormat:@"%@",dic[@"option_promotion_content"] ];
      self.coupoes = [NSString stringWithFormat:@"(米券:%@,米子:%@)",dic[@"coupons"],dic[@"rice"] ];
    [self.tableView reloadData];

}
- (float)jisuangaodu:(NSArray *)arr{
    float upX = 10;
    float upY = 40;

    for (int i = 0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i] ;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];
        
        if ( upX > (SCREEN_WIDTH-20 -size.width-35)) {
            
            upX = 10;
            upY += 30;
        }
        
        upX+= SCREEN_WIDTH * 0.4;
    
    }
    return upY + 30;
}
- (float)jisuanjincou:(NSArray *)arr{
    float upX = 10;
    float upY = 40;
    //    NSArray *arr = [[NSArray alloc] initWithObjects:@"级别",@"级别",@"级别",@"级别",nil];
    for (int i = 0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i] ;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];
        
        if ( upX > (SCREEN_WIDTH-20 -size.width-35)) {
            
            upX = 10;
            upY += 30;
        }
        
        upX+= size.width + 35;
    }
    return upY + 30;
}

- (void)changeNum:(NSString *)text{
    _sum = [text  integerValue];
}
//请求规格
-(void)initSpecificationsDataSoruce{

    [NetworkManager requestPOSTWithURLStr:@"Shop/getGoodsSpec" paramDic:@{@"goods_id":self.goods_id} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                 [self.standardList addObject:@"商品规格" ];
                self.titleArr = responseObject[@"data"];
                if (self.titleArr.count >0) {
                    self.NewPrice = [NSString stringWithFormat:@"价格:¥%@",responseObject[@"data"][0][@"marketprice"] ];
                    self.coupoes = [NSString stringWithFormat:@"(米券:%@,米子:%@)",responseObject[@"data"][0][@"coupons"],responseObject[@"data"][0][@"rice"] ];
                    self.attributeId = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"id"] ];
                    self.goods_spec = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"title"] ];
                    self.option_promotion_content = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"option_promotion_content"] ];
                }
               
                [self.tableView reloadData];
            }
        }
    } enError:^(NSError *error) {

    }];
    
}

-(void)clickcheckDetail:(NSString *)goodid{
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    detailVC.navigationItem.title = @"详情";
    detailVC.type = 1;
    detailVC.goods_id = goodid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)changeView:(NSInteger )tag{

    if (tag == 11) {
        _status = 1;
    }else{
        _status = 0;
    }
    
    [self.tableView reloadData];
    
}

-(NSMutableArray*)standardList{
    if (!_standardList) {
        _standardList = [NSMutableArray array];
    }
    
    return _standardList;

}

-(NSMutableArray*)standardValueList{
    if (!_standardValueList) {
        _standardValueList = [NSMutableArray array];
    
    }
    
    return _standardValueList;
    
}

-(NSMutableArray *)rankArray{
    
    if (_rankArray == nil) {
        
        _rankArray = [[NSMutableArray alloc] init];
    }
    return _rankArray;
}

-(LBRichTextLinksview*)richTextLinksview{
    if (!_richTextLinksview) {
        _richTextLinksview = [[LBRichTextLinksview alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _richTextLinksview.webView.delegate = self;
        
    }
    
    return _richTextLinksview;
}

-(NSArray *)titleArr{
    
    if (_titleArr == nil) {
        
        _titleArr = [[NSArray alloc] init];
    }
    return _titleArr;
}

@end
