//
//  GLMerchat_CommentTableController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_CommentTableController.h"
#import "GLMerchat_CommentCell.h"
#import "GLMerchat_CommentModel.h"
#import "SDCycleScrollView.h"
#import "JZAlbumViewController.h"

@interface GLMerchat_CommentTableController ()<SDCycleScrollViewDelegate,GLMerchat_CommentCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    LoadWaitView *_loadV;
    NSInteger _index;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)UIView *commentView;
@property (nonatomic, strong)UITextField *commentTF;

@end

static NSString *ID = @"GLMerchat_CommentCell";
@implementation GLMerchat_CommentTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品评价";
    self.navigationController.navigationBar.hidden = NO;
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
    dict[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    dict[@"pre_id"] = [NSString stringWithFormat:@"goods_%@",self.dic[@"goods_id"]];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getShopOrGoodsCommentList" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMerchat_CommentModel *model = [GLMerchat_CommentModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
                self.dataDic = responseObject[@"data"];
            
                if (self.models.count <= 0 ) {
                    self.nodataV.hidden = NO;
                }else{
                    self.nodataV.hidden = YES;
                }

            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
        [self setupHeaderView];
        self.tableView.tableHeaderView = self.headerView;

        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
         [self.tableView reloadData];
    }];
    
}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}
- (void)setupHeaderView {
    
    [self.headerView addSubview:self.cycleScrollView];
    
    //商品名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = YYSRGBColor(95, 104, 115, 1);
    nameLabel.numberOfLines = 0; // 需要把显示行数设置成无限制
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = self.dic[@"name"];
    CGSize nameSize =  [self sizeWithStr:nameLabel.text font:nameLabel.font];
    nameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.cycleScrollView.frame) + 10, SCREEN_WIDTH - 20, nameSize.height);

    //价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.numberOfLines = 0; // 需要把显示行数设置成无限制
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.dic[@"price"]];
    priceLabel.frame = CGRectMake(10, CGRectGetMaxY(nameLabel.frame) + 10, SCREEN_WIDTH/2 - 10,20);

    //评价数
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.textColor = YYSRGBColor(95, 104, 115, 1);
    commentLabel.numberOfLines = 0; // 需要把显示行数设置成无限制
    commentLabel.font = [UIFont systemFontOfSize:12];
    commentLabel.textAlignment = NSTextAlignmentRight;
    commentLabel.text = [NSString stringWithFormat:@"评论:%@",self.dic[@"pl_count"]];
    commentLabel.frame = CGRectMake(SCREEN_WIDTH/2, priceLabel.yy_y, SCREEN_WIDTH/2 - 10,20);
    
    
    //描述
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = YYSRGBColor(95, 104, 115, 1);
    detailLabel.numberOfLines = 0; // 需要把显示行数设置成无限制
    detailLabel.font = [UIFont systemFontOfSize:11];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.text = [NSString stringWithFormat:@"描述:%@",self.dic[@"goods_info"]];
    //    detailLabel.text = @"这是一款宇宙最爆款的东西,虽然我也不知道这是个什么玩意儿我也不知道这是个什么玩意儿";
    CGSize detailSize =  [self sizeWithStr:detailLabel.text font:detailLabel.font];
    detailLabel.frame = CGRectMake(10, CGRectGetMaxY(priceLabel.frame) + 10, SCREEN_WIDTH - 20, detailSize.height);
    //计算headerView 高度
    CGFloat height = nameSize.height + detailSize.height + priceLabel.yy_height + self.cycleScrollView.yy_height + 40;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.yy_height - 1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.2;
    
    [self.headerView addSubview:nameLabel];
    [self.headerView addSubview:detailLabel];
    [self.headerView addSubview:priceLabel];
    [self.headerView addSubview:commentLabel];
    [self.headerView addSubview:lineView];
    
}
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithStr:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName:font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    }
    return _headerView;
}
- (UIView *)commentView{
    if (!_commentView) {
        _commentView = [[UIView alloc] init];
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_HEIGHT, 80);
        //    view.backgroundColor = YYSRGBColor(170, 170, 170, 0.1);
        _commentView.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        topView.backgroundColor = YYSRGBColor(170, 170, 170, 0.1);
        
        
        _commentTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
        _commentTF.backgroundColor = [UIColor whiteColor];
        _commentTF.returnKeyType = UIReturnKeySend;
        _commentTF.layer.cornerRadius = 5.f;
        _commentTF.layer.borderWidth = 1;
        _commentTF.layer.borderColor = YYSRGBColor(170, 170, 170, 0.2).CGColor;
        _commentTF.clipsToBounds = YES;
        _commentTF.font = [UIFont systemFontOfSize:12];
        _commentTF.placeholder = @" 请输入内容";
        [_commentTF becomeFirstResponder];
        _commentTF.delegate = self;
        
        [topView addSubview:_commentTF];
        [_commentView addSubview:topView];
    }
    return _commentView;
}
-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.imageURLStringsGroup = @[_dic[@"thumb"]];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _cycleScrollView;
    
}
#pragma mark 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}


- (void)comment:(NSInteger)index{
    _index = index;
    self.commentView.alpha = 1;
    [self.view addSubview:self.commentView];
    [_commentTF becomeFirstResponder];
}
#pragma mark uitextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"点击了搜索");
    GLMerchat_CommentModel *model = self.models[_index];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"comment_id"] = model.comment_id;
    
    NSString *inputText = [_commentTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dict[@"content"] = inputText;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/ShopSetReplyComment" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];

        [MBProgressHUD showError:responseObject[@"message"]];
        if ([responseObject[@"code"] integerValue] == 1) {
            [self updateData:YES];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

    self.commentView.alpha = 0;
    [self.commentTF resignFirstResponder];
    
    
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.estimatedRowHeight = 22;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLMerchat_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = 0;
    cell.delegate = self;
    cell.index = indexPath.row;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.commentView removeFromSuperview];
    self.commentView.alpha = 0;
    [self.commentTF resignFirstResponder];
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];

    }
    return _models;
}
- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
        
    }
    return _dataDic;
}
@end
