//
//  LBMerchantSubmissionFourViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMerchantSubmissionFourViewController.h"
#import "MerchantInformationModel.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "LBBaiduMapViewController.h"
#import "LBMineCenterChooseAreaViewController.h"
#import "LBMyBusinessListViewController.h"
#import "LBViewProtocolViewController.h"

@interface LBMerchantSubmissionFourViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIImageView *handImage;
@property (weak, nonatomic) IBOutlet UIImageView *positiveImage;//身份证正面照
@property (weak, nonatomic) IBOutlet UIImageView *otherSideImage;//身份证正面照
@property (weak, nonatomic) IBOutlet UIImageView *licenseImage;//营业执照
@property (weak, nonatomic) IBOutlet UIImageView *undertakingOne;//商家承诺书
@property (weak, nonatomic) IBOutlet UIImageView *undertakingTwo;//推广员承诺书
@property (weak, nonatomic) IBOutlet UIImageView *doorplateImage;//店铺招牌
@property (weak, nonatomic) IBOutlet UIImageView *DoorplateOneimage;//店铺环境照1
@property (weak, nonatomic) IBOutlet UIImageView *InteriorImage;//店铺环境照2
@property (weak, nonatomic) IBOutlet UIImageView *InteriorOneImage;//店铺环境照3
@property (weak, nonatomic) IBOutlet UIView *baseview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@property (assign, nonatomic)NSInteger tapIndex;//判断点击的是那个图片
@property (strong, nonatomic)LoadWaitView *loadV;

@property (weak, nonatomic) IBOutlet UIView *StoreNameV;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *numbersView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *connectNameV;
@property (weak, nonatomic) IBOutlet UIView *connectPhoneV;
@property (weak, nonatomic) IBOutlet UIView *storeTypeV;
@property (weak, nonatomic) IBOutlet UIView *chooseAdressV;

@property (weak, nonatomic) IBOutlet UITextField *storeName;//店名
//营业执照
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
//地图
@property (weak, nonatomic) IBOutlet UILabel *maplb;
//门牌
@property (weak, nonatomic) IBOutlet UITextField *doorNumbersTf;
//法人姓名
@property (weak, nonatomic) IBOutlet UITextField *bossNametf;
//法人电话
@property (weak, nonatomic) IBOutlet UITextField *bossPhoneTf;
//联系人名字
@property (weak, nonatomic) IBOutlet UITextField *connectName;
//联系人电话
@property (weak, nonatomic) IBOutlet UITextField *connectPhoneTf;
//店铺类型一
@property (weak, nonatomic) IBOutlet UILabel *industryOneLb;
//店铺类型二
@property (weak, nonatomic) IBOutlet UILabel *industrySecLb;
//省市区地址
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
//保存省市区
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;
@property (strong, nonatomic)NSString *chooseType;//选择类型
//店铺类别 需要的属性
@property (nonatomic, strong)NSMutableArray *industryArr;
@property (nonatomic, assign)NSInteger isChoseFirstClassify;//记录一级分类的第几行
@property (nonatomic, assign)NSInteger isChoseSecondClassify;//记录二级分类的第几行

//经纬度
@property (nonatomic, copy)NSString *latStr;
@property (nonatomic, copy)NSString *longStr;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (strong, nonatomic)UIButton *buttonedt;
//用来判断是否选了图片
@property (assign, nonatomic)NSInteger oneIndex;
@property (assign, nonatomic)NSInteger twoIndex;
@property (assign, nonatomic)NSInteger threeIndex;
@property (assign, nonatomic)NSInteger fourIndex;
@property (assign, nonatomic)NSInteger fiveIndex;
@property (assign, nonatomic)NSInteger sixIndex;
@property (assign, nonatomic)NSInteger sevenIndex;
@property (assign, nonatomic)NSInteger eightIndex;
@property (assign, nonatomic)NSInteger nineIndex;
@property (assign, nonatomic)NSInteger tenIndex;

@end

@implementation LBMerchantSubmissionFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交商户";
     self.navigationController.navigationBar.hidden = NO;
    [self getPickerData];
    
    self.provinceStrId = @"";
    self.cityStrId = @"";
    self.countryStrId = @"";
    
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"列表" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(merchantList) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
}
//跳转商家列表
-(void)merchantList{

    self.hidesBottomBarWhenPushed = YES;
    LBMyBusinessListViewController *vc=[[LBMyBusinessListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - get data
- (void)getPickerData {
    //行业列表
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"User/getHylist" paramDic:dict finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue]==1) {
            self.industryArr = responseObject[@"data"];
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
//        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    [NetworkManager requestPOSTWithURLStr:@"User/getCityList" paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.dataArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

    
}
//点击地图
- (IBAction)tapgestureMap:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
    mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
        //        self.adress = strposition;
        //        self.sprovince = pro;
        //        self.scity =city;
        //        self.saera = area;
        if(strposition != nil ){
            
            self.latStr = [NSString stringWithFormat:@"%f",coors.latitude];
            self.longStr = [NSString stringWithFormat:@"%f",coors.longitude];
            self.maplb.text = [NSString stringWithFormat:@"%@",strposition];
        }
    };
    [self.navigationController pushViewController:mapVC animated:YES];

}
//选择一类行业
- (IBAction)chooseIndustryFirst:(UITapGestureRecognizer *)sender {
    
    self.chooseType = @"industry";
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    
    if (self.industryArr.count > 0) {
        
        vc.provinceArr = self.industryArr;
        vc.titlestr = @"请选择一级行业分类";
        vc.returnreslut = ^(NSInteger index){
            _isChoseFirstClassify = index;
            _industryOneLb.text = _industryArr[index][@"trade_name"];
            _industryOneLb.textColor = [UIColor blackColor];
            _industrySecLb.text = @"请选择";
            
        };
        vc.transitioningDelegate = self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"一级分类暂无数据"];
    }

}
//选择二类行业
- (IBAction)chooseIndustrySecond:(UITapGestureRecognizer *)sender {
    self.chooseType = @"industry";
    if ([self.industryOneLb.text isEqualToString:@"请选择一级行业分类"]) {
        [MBProgressHUD showError:@"请选择一级行业分类"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
        NSArray *arr = self.industryArr[_isChoseFirstClassify][@"son"];
        if(arr.count != 0){
            
            vc.provinceArr = self.industryArr[_isChoseFirstClassify][@"son"];
            vc.titlestr = @"请选择二级行业分类";
            vc.returnreslut = ^(NSInteger index){
                _isChoseSecondClassify = index;
                NSArray *son = _industryArr[_isChoseFirstClassify][@"son"];
                if (son.count == 0) {
                    _industrySecLb.text = @"";
                }else{
                    
                    _industrySecLb.text = _industryArr[_isChoseFirstClassify][@"son"][_isChoseSecondClassify][@"trade_name"];
                }
                _industrySecLb.textColor = [UIColor blackColor];
                
            };
            
            vc.transitioningDelegate=self;
            vc.modalPresentationStyle=UIModalPresentationCustom;
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"二级分类暂无数据"];
        }
}

//选择省市区
- (IBAction)chooseAdressEvent:(UITapGestureRecognizer *)sender {
    self.chooseType = @"adress";
    LBMineCenterChooseAreaViewController *vc=[[LBMineCenterChooseAreaViewController alloc]init];
    vc.dataArr = self.dataArr;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.adressLb.text = str;
        weakself.provinceStrId = provinceid;
        weakself.cityStrId = cityd;
        weakself.countryStrId = areaid;
    };
}

//手持身份证
- (IBAction)tapgesturehandimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 1;
    
    [self tapgesturephotoOrCamera];
    
}
// 身份证正面照
- (IBAction)tapgesturepositiveimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 2;
    [self tapgesturephotoOrCamera];
    
}
//身份证反面照
- (IBAction)tapgestureothersideimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 3;
    [self tapgesturephotoOrCamera];
    
}

//点击营业执照
- (IBAction)tapgestureBusinesslicense:(UITapGestureRecognizer *)sender {
    _tapIndex = 4;
    [self tapgesturephotoOrCamera];
    
    
}
//商家承诺书
- (IBAction)tapgestureBusinessUndertaking:(UITapGestureRecognizer *)sender {
    _tapIndex = 5;
    [self tapgesturephotoOrCamera];
    
    
    
}
- (IBAction)tapgestureBusinessUndertakingOne:(UITapGestureRecognizer *)sender {
    _tapIndex = 6;
    [self tapgesturephotoOrCamera];
}
//点击门牌照
- (IBAction)tapgestureDoorPlate:(UITapGestureRecognizer *)sender {
    _tapIndex = 7;
    [self tapgesturephotoOrCamera];
    
    
}

- (IBAction)tapgestureDoorPlateOne:(UITapGestureRecognizer *)sender {
    _tapIndex = 8;
    [self tapgesturephotoOrCamera];
    
    
}
//门店内景图
- (IBAction)tapgestureStoreInterior:(UITapGestureRecognizer *)sender {
    _tapIndex = 9;
    [self tapgesturephotoOrCamera];
    
    
}

- (IBAction)tapgestureStoreInteriorOne:(UITapGestureRecognizer *)sender {
    _tapIndex = 10;
    
    [self tapgesturephotoOrCamera];
    
}
//查看承诺书
- (IBAction)isReadPromise:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.submit.userInteractionEnabled = YES;
         self.submit.backgroundColor = TABBARTITLE_COLOR;
        
    }else{
        self.submit.userInteractionEnabled = NO;
        self.submit.backgroundColor = [UIColor lightGrayColor];
    }
    
}
//阅读承诺书
- (IBAction)tapgesturePromise:(UITapGestureRecognizer *)sender {
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"promiseFile"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    

    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.loadLocalBool = YES;
    vc.webUrl = htmlCont;
    vc.navTitle = @"承诺书详情";
    [self.navigationController pushViewController:vc animated:YES];
    
}

//选择图片来源
-(void)tapgesturephotoOrCamera{

    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];


}


//提交
- (IBAction)submitinfo:(UIButton *)sender {
    
//    if (!self.handImage.image || self.handImage.image == [UIImage imageNamed:@"手持身份证"]) {
//        [MBProgressHUD showError:@"请上传法人手持证件照"];
//        return;
//    }
    
    if (self.storeName.text.length <= 0) {
        [MBProgressHUD showError:@"请输入店名"];
        return;
    }
    if (self.codeTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入营业执照号码"];
        return;
    }
    if (self.maplb.text.length <= 0 || [self.maplb.text isEqualToString:@"选择地图"]) {
        [MBProgressHUD showError:@"还没有地图选点"];
        return;
    }
    if (self.adressLb.text.length <= 0) {
        [MBProgressHUD showError:@"请选择省市区"];
        return;
    }
    if (self.doorNumbersTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入街道和门牌号"];
        return;
    }
    if (self.bossNametf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入法人姓名"];
        return;
    }
    if (self.bossPhoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入法人电话"];
        return;
    }else if (![predicateModel valiMobile:self.bossPhoneTf.text]){
        [MBProgressHUD showError:@"法人手机号不合法"];
        return;
    }
    if (self.connectName.text.length <= 0) {
        [MBProgressHUD showError:@"请输入联系人姓名"];
        return;
    }
    if (self.connectPhoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入联系人电话"];
        return;
    }else if (![predicateModel valiMobile:self.connectPhoneTf.text]){
        [MBProgressHUD showError:@"联系人手机号不合法"];
        return;
    }
    if ([self.industrySecLb.text isEqualToString:@"请选择"] ) {
        [MBProgressHUD showError:@"请选择店铺总类别"];
        return;
    }
    if ([self.industrySecLb.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"请选择店铺具体类别"];
        return;
    }
    
    if (self.twoIndex != 1 || self.threeIndex != 1) {
        [MBProgressHUD showError:@"请上传身份证正反面照"];
        return;
    }
    
    if (self.fourIndex != 1) {
        [MBProgressHUD showError:@"请上传营业执照"];
        return;
    }
    if (self.sevenIndex != 1) {
        [MBProgressHUD showError:@"请上传店铺招牌"];
        return;
    }
    
    if (self.eightIndex != 1 && self.nineIndex != 1 && self.tenIndex != 1) {
        [MBProgressHUD showError:@"请上传店铺环境照"];
        return;
    }
    
    self.submit.userInteractionEnabled = NO;
    self.submit.backgroundColor = [UIColor lightGrayColor];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"shop_name"] = self.storeName.text;//店名license_num
    dict[@"license_num"] = self.codeTf.text;//营业执照号
    dict[@"s_province"] = self.provinceStrId;//省
    dict[@"s_city"] = self.cityStrId;//市
    dict[@"s_area"] = self.countryStrId;//区
    dict[@"s_address"] = [NSString stringWithFormat:@"%@%@",self.adressLb.text,self.doorNumbersTf.text];//门牌号(详细地址)
    dict[@"corporation_name"] = self.bossNametf.text;//法人姓名
    dict[@"corporation_phone"] = self.bossPhoneTf.text;//法人电话
    dict[@"truename"] = self.connectName.text;//联系人姓名
    dict[@"email"] = self.connectPhoneTf.text;//联系人电话
    dict[@"truename"] = self.connectName.text;//登录手机号
    dict[@"phone"] = self.connectPhoneTf.text;//真实姓名
    dict[@"trade_id"] = _industryArr[_isChoseFirstClassify][@"trade_id"];
    dict[@"two_trade_id"] = _industryArr[_isChoseFirstClassify][@"son"][_isChoseSecondClassify][@"trade_id"];

    dict[@"lat"] = self.latStr;//纬度
    dict[@"lng"] = self.longStr;//经度
     dict[@"reg_port"] = @"3";
    dict[@"app_version"] = APP_VERSION;
    dict[@"version"] = @"3";
     NSMutableArray *imageViewArr = [NSMutableArray arrayWithObjects:UIImagePNGRepresentation(self.positiveImage.image),UIImagePNGRepresentation(self.otherSideImage.image),UIImagePNGRepresentation(self.licenseImage.image),UIImagePNGRepresentation(self.doorplateImage.image) ,nil];
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"face_pic",@"con_pic",@"license_pic",@"store_pic", nil];
    
    if (self.nineIndex == 1) {
        [imageViewArr addObject:UIImagePNGRepresentation(self.InteriorImage.image)];
        [titleArr addObject:@"store_one"];
    }
    
    if (self.tenIndex == 1) {
        [imageViewArr addObject:UIImagePNGRepresentation(self.InteriorOneImage.image)];
        [titleArr addObject:@"store_two"];
    }
    
    if (self.eightIndex == 1) {
        [imageViewArr addObject:UIImagePNGRepresentation(self.DoorplateOneimage.image)];
        [titleArr addObject:@"store_three"];
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/openOne",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传

        for (int i = 0; i < imageViewArr.count; i ++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            [formData appendPartWithFileData:imageViewArr[i] name:titleArr[i] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
        
        if (uploadProgress.fractionCompleted == 1.0) {
            [SVProgressHUD dismiss];
//            self.submit.userInteractionEnabled = YES;
        }
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
           [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dic[@"message"]];
            self.submit.userInteractionEnabled = YES;
            self.submit.backgroundColor = TABBARTITLE_COLOR;
        }
        
        [_loadV removeloadview];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.submit.userInteractionEnabled = YES;
        self.submit.backgroundColor = TABBARTITLE_COLOR;
        [MBProgressHUD showError:error.localizedDescription];

    }];
    
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
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
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
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        switch (self.tapIndex) {
            case 1:
            {
                self.handImage.image = [UIImage imageWithData:data];
                self.oneIndex = 1;
            }
                break;
            case 2:
            {
                self.positiveImage.image = [UIImage imageWithData:data];
                self.twoIndex = 1;
            }
                break;
            case 3:
            {
                self.otherSideImage.image = [UIImage imageWithData:data];
                 self.threeIndex = 1;
            }
                break;
            case 4:
            {
                self.licenseImage.image = [UIImage imageWithData:data];
                 self.fourIndex = 1;
            }
                break;
            case 5:
            {
                self.undertakingOne.image = [UIImage imageWithData:data];
                 self.fiveIndex = 1;
            }
                break;
            case 6:
            {
                self.undertakingTwo.image = [UIImage imageWithData:data];
                 self.sixIndex = 1;
            }
                break;
            case 7:
            {
                self.doorplateImage.image = [UIImage imageWithData:data];
                 self.sevenIndex = 1;
            }
                break;
            case 8:
            {
                self.DoorplateOneimage.image = [UIImage imageWithData:data];
                 self.eightIndex = 1;
            }
                break;
            case 9:
            {
                self.InteriorImage.image = [UIImage imageWithData:data];
                 self.nineIndex = 1;
            }
                break;
            case 10:
            {
                self.InteriorOneImage.image = [UIImage imageWithData:data];
                self.tenIndex = 1;
            }
                break;
                
            default:
                break;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
#pragma mark -- textfileddelegete
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.storeName && [string isEqualToString:@"\n"]) {
        [self.codeTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.codeTf && [string isEqualToString:@"\n"]){
        
        [self.doorNumbersTf becomeFirstResponder];
        return NO;
    }else if (textField == self.doorNumbersTf && [string isEqualToString:@"\n"]){
        [self.bossNametf becomeFirstResponder];
        return NO;
    }else if (textField == self.bossNametf && [string isEqualToString:@"\n"]){
        [self.bossPhoneTf becomeFirstResponder];
        
        return NO;
    }else if (textField == self.bossPhoneTf && [string isEqualToString:@"\n"]){
        
        [self.connectNameV becomeFirstResponder];
        return NO;
    }else if (textField == self.connectName && [string isEqualToString:@"\n"]){
        
        [self.connectPhoneTf becomeFirstResponder];
        return NO;
    }else if (textField == self.connectPhoneTf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.codeTf) {
        
       return [self validateNumber:string];
      
    }
    
    if (textField == _bossNametf || textField == _connectName) {
        
        NSString *regex = @"[➋➌➍➎➏➐➑➒a-zA-Z\u4e00-\u9fa5]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([string isEqualToString:@""]) {
            return YES;
        }else{
           return [pred evaluateWithObject:string];
        }
    }
    
    return YES;
}

//只能输入整数
- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.submit.layer.cornerRadius = 4;
    self.submit.clipsToBounds = YES;
    
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;
    
    self.StoreNameV.layer.cornerRadius = 4;
    self.StoreNameV.clipsToBounds = YES;
    
    self.codeView.layer.cornerRadius = 4;
    self.codeView.clipsToBounds = YES;
    
    self.mapView.layer.cornerRadius = 4;
    self.mapView.clipsToBounds = YES;
    
    self.numbersView.layer.cornerRadius = 4;
    self.numbersView.clipsToBounds = YES;
    
    self.nameView.layer.cornerRadius = 4;
    self.nameView.clipsToBounds = YES;
    
    self.phoneView.layer.cornerRadius = 4;
    self.phoneView.clipsToBounds = YES;
    
    self.connectNameV.layer.cornerRadius = 4;
    self.connectNameV.clipsToBounds = YES;
    
    self.connectPhoneV.layer.cornerRadius = 4;
    self.connectPhoneV.clipsToBounds = YES;
    
    self.storeTypeV.layer.cornerRadius = 4;
    self.storeTypeV.clipsToBounds = YES;
    
    self.chooseAdressV.layer.cornerRadius = 4;
    self.chooseAdressV.clipsToBounds = YES;
    
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 1350;

}

//动画
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
    
    if ([self.chooseType isEqualToString:@"adress"]) {
        
        [self chooseAddress:transitionContext];
        
    }else if ([self.chooseType isEqualToString:@"industry"]){
    
        [self chooseindustry:transitionContext];
    }
    
}
//选择行业
-(void)chooseindustry:(id <UIViewControllerContextTransitioning>)transitionContext{

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

//选择省市区
-(void)chooseAddress:(id <UIViewControllerContextTransitioning>)transitionContext{

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

- (IBAction)closeKeybord:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
