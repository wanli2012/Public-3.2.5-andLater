//
//  LBBillOfLadingViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingViewController.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBBillOfLadingTableViewCell.h"
#import "LBBillOfLadingModel.h"
#import "UIView+TYAlertView.h"
#import "LBBillOfLadingSendViewController.h"
#import "LBBillOfLadingDetailViewController.h"
#import "LBBillOfLadingRecoderViewController.h"
#import "LBBillOfLadingHeaderFooterView.h"
#import "LBBillOfLadingHeaderphotoView.h"

@interface LBBillOfLadingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    LoadWaitView *_loadV;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *submitBt;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NSMutableArray *IDArr;//选中的提单id
@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic)LBBillOfLadingHeaderphotoView *headerphotoView;
@property (strong, nonatomic)UIView *maskVew;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (assign, nonatomic)NSInteger indexImage;//记录图片上传
@property (assign, nonatomic)CGFloat totalMoeny;//选择总价格
@property (strong, nonatomic)UIButton *buttonedt;

@end

static NSString *ID = @"LBBillOfLadingTableViewCell";

@implementation LBBillOfLadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"提单";
    self.view.backgroundColor = [UIColor whiteColor];
    _totalMoeny = 0;
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    self.tableview.tableFooterView = [UIView new];
    [self.tableview addSubview:self.nodataV];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
    [self.tableview.mj_header beginRefreshing];
    //当提单成功之后，刷新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBillListData) name:@"refreshBillListData" object:nil];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"记录" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
}
//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self postRequest];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self postRequest];
}

- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"page"] = @(_page);
    dict[@"type"] = @(2);
    
    [NetworkManager requestPOSTWithURLStr:@"User/getShopOrderLineList" paramDic:dict finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *dic in responseObject[@"data"]) {
                LBBillOfLadingModel *model = [LBBillOfLadingModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.models removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
            
        }
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    } enError:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:@"请求数据失败"];
    }];
}

-(void)refreshBillListData{
    
    _totalMoeny = 0;
    [self.IDArr removeAllObjects];
    [self.tableview.mj_header beginRefreshing];
    
}
#pragma  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.models.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count == 0 ? 0:self.models.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBBillOfLadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 170;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *viewIdentfier = @"LBBillOfLadingHeaderFooterView";
    
    LBBillOfLadingHeaderFooterView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[LBBillOfLadingHeaderFooterView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    __weak typeof(self) wseaf = self;
    sectionHeadView.model = self.models[section];
    
    sectionHeadView.refreshData = ^(BOOL iselect,NSString *linid,NSString *money){
        
        if (iselect) {
            [self.IDArr addObject:linid];
            _totalMoeny = _totalMoeny+[money floatValue];
        }else{
            [self.IDArr removeObject:linid];
            _totalMoeny = _totalMoeny-[money floatValue];
        }
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    sectionHeadView.refreshShow = ^(NSString *titile , UIImage *image){
        
        wseaf.headerphotoView.imagev.image = image;
        [wseaf.headerphotoView.uploadBt setTitle:titile forState:UIControlStateNormal];
        
        wseaf.indexImage = section;
        [self.view addSubview:self.maskVew];
        [self.maskVew addSubview:self.headerphotoView];
        
    };
    
    
    sectionHeadView.jumpBilldetail = ^(){
        wseaf.hidesBottomBarWhenPushed = YES;
        LBBillOfLadingDetailViewController *vc=[[LBBillOfLadingDetailViewController alloc]init];
        vc.model = wseaf.models[section];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    sectionHeadView.detateBill = ^(){
        
        [wseaf deleteBill:section];
    };
    
    return sectionHeadView;
    
}


-(void)deleteBill:(NSInteger)indexPath{
    
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:[NSString stringWithFormat:@"温馨提示"] message:[NSString stringWithFormat:@"请说明拒绝理由"]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
    }]];
    
    // 弱引用alertView 否则 会循环引用
    __typeof (alertView) __weak weakAlertView = alertView;
    __typeof (self) __weak weakself = self;
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        if (weakAlertView.textFieldArray.count > 0) {
            for (UITextField *textField in weakAlertView.textFieldArray) {
                if (textField.text.length <= 0) {
                    [self.view makeToast:@"请填写原因" duration:2.0 position:CSToastPositionCenter];
                    return ;
                }
                [weakself RefusalOfBill:indexPath codestr:textField.text];
            }
        }
        
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入原因";
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    // first way to show
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//拒绝
-(void)RefusalOfBill:(NSInteger)indexpath codestr:(NSString*)str{
    
    LBBillOfLadingModel *model = self.models[indexpath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"order_id"] = model.line_id;
    dict[@"reason"] = str;
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"User/shopRefuseOrder" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.models removeObjectAtIndex:indexpath];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"拒绝";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)edtingInfo{
    
    self.hidesBottomBarWhenPushed = YES;
    LBBillOfLadingRecoderViewController *vc=[[LBBillOfLadingRecoderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//提交
- (IBAction)submitEvent:(UIButton *)sender {
    
    if (self.IDArr.count <= 0) {
        [self.view makeToast:@"请选择提单" duration:2.0 position:CSToastPositionCenter];
        return ;
    }
    if (self.IDArr.count > 10) {
        [self.view makeToast:@"一次性最多只能提交10个订单" duration:2.0 position:CSToastPositionCenter];
        return ;
    }
    
    self.submitBt.userInteractionEnabled = NO;
    NSString *idstr = [self.IDArr componentsJoinedByString:@","];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    BOOL iscan = NO;//判断是否有大于1000的没有上传图片
    
    for (int i = 0; i < self.models.count; i++) {
        LBBillOfLadingModel *model  = self.models[i];
        
        if (model.isSelect) {
            if (model.isImage) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"key"] = model.line_id;
                dic[@"value"] = model.imagev;
                [imageArr addObject:dic];
            }else{
                if ([model.line_money floatValue] > [[UserModel defaultUser].line_money floatValue]) {
                    iscan = YES;
                }
            }
            
        }
        
    }
    
    
    if (iscan == YES) {
        
        [self.view makeToast:@"您有订单没有上传凭证" duration:2.0 position:CSToastPositionCenter];
        self.submitBt.userInteractionEnabled = YES;
        return ;
        
    }
    
    self.submitBt.userInteractionEnabled = YES;
    self.hidesBottomBarWhenPushed = YES;
    LBBillOfLadingSendViewController *vc=[[LBBillOfLadingSendViewController alloc]init];
    vc.idstr = idstr;
    vc.imageArr = imageArr;
    vc.toatlMoney = _totalMoeny;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tapCamera{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self getpicture];//获取相册
        }break;
            
        case 1:{
            [self getcamera];//获取照相机
        }break;
        default:
            break;
    }
}

-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    // 设置选择后的图片可以被编辑
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.1);
        }else {
            data = UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        self.headerphotoView.imagev.image = [UIImage imageWithData:data];
        [self.headerphotoView.uploadBt setTitle:@"修 改 图 片" forState:UIControlStateNormal];
        
        LBBillOfLadingModel  *model = self.models[self.indexImage];
        model.isImage = YES;
        model.imagev = [UIImage imageWithData:data];
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:self.indexImage] withRowAnimation:UITableViewRowAnimationNone];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}


-(void)removeMaskView{
    
    [self.maskVew removeFromSuperview];
    [self.headerphotoView removeFromSuperview];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    
    return YES;
}


-(LBBillOfLadingHeaderphotoView*)headerphotoView{
    
    if (!_headerphotoView) {
        _headerphotoView = [[NSBundle mainBundle] loadNibNamed:@"LBBillOfLadingHeaderphotoView" owner:nil options:nil].lastObject;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCamera)];
        _headerphotoView.center =  self.maskVew.center;
        [_headerphotoView.imagev addGestureRecognizer:tap];
        [_headerphotoView.uploadBt addTarget:self action:@selector(tapCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerphotoView;
    
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}

-(UIView*)maskVew{
    
    if (!_maskVew) {
        _maskVew=[[UIView alloc]init];
        _maskVew.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        _maskVew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeMaskView)];
        [_maskVew addGestureRecognizer:tap];
    }
    return _maskVew;
    
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
- (NSMutableArray *)IDArr{
    if (!_IDArr) {
        _IDArr = [NSMutableArray array];
    }
    return _IDArr;
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    
    //     self.navagationH.constant = SafeAreaTopHeight;
    //    self.bottomConstrait.constant = SafeAreaBottomHeight;
}

@end
