//
//  GLMine_InfoController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_InfoController.h"
#import "GLMine_InfoCell.h"
#import "LBBaiduMapViewController.h"
#import "NTESLogManager.h"
#import "NSString+NTES.h"
#import "NTESService.h"
#import "UIView+Toast.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"
#import "LBPayCodeView.h"
#import "GLMine_headimageCell.h"
#import <Masonry/Masonry.h>
#import "JZAlbumViewController.h"
#import "QBImagePickerController.h"

@interface GLMine_InfoController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,QBImagePickerControllerDelegate>
{
    NSArray *_titlesArr;
    NSMutableArray *_valuesArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageInfoO;
@property (weak, nonatomic) IBOutlet UIImageView *payImage;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *payView;

@property (strong, nonatomic)UIButton *buttonedt;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIView *pickerViewMask;
@property (strong, nonatomic)NSArray *usertypeArr;
@property (strong, nonatomic)LoadWaitView *loadV;

@property (strong, nonatomic)LBPayCodeView *payCodeView;
@property (strong, nonatomic)UIView *maskView;

@property (weak, nonatomic) IBOutlet UIView *doorView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (strong, nonatomic)  NSMutableArray *imagearr;
@property (strong, nonatomic)  NSMutableArray *imagearrone;
@property (assign, nonatomic)  NSInteger  typeimage;//判断图片类型

@end

static NSString *ID = @"GLMine_InfoCell";
static NSString *ID2 = @"GLMine_headimageCell";

@implementation GLMine_InfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"个人资料";
    self.typeimage = 0;
    self.imageInfo.image=[self logoQrCode:[UserModel defaultUser].name];
    self.imageInfoO.image=[self logoQrCode:[UserModel defaultUser].name];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_InfoCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_headimageCell" bundle:nil] forCellReuseIdentifier:ID2];
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        self.infoView.hidden = NO;
        self.payView.hidden = NO;
        
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 410);
        self.tableView.tableFooterView.hidden = NO;
        //生成支付二维码
        [self generatePayDimensionalCode];
        [self setupimageview];
        [self setupimageviewone];
        [self getDoorAndInnerPics];
    }else{
        self.tableView.tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.tableView.tableFooterView.hidden = YES;
    }
    
    [self updateInfo];

}

-(void)getDoorAndInnerPics{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getDoorAndInnerPics" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token,@"app_version":APP_VERSION,@"version":@"3"} finish:^(id responseObject) {
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue]==1) {
            
            NSString *store_pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_pic"]];
            NSString *store_one = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_one"]];
            NSString *store_two = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_two"]];
            NSString *store_three = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_three"]];
            
            if ([store_pic length] > 0 && [store_pic rangeOfString:@"null"].location == NSNotFound) {
                [self.imagearr insertObject:store_pic atIndex:0];
            }
            if ([store_three length] > 0 && [store_three rangeOfString:@"null"].location == NSNotFound) {
                [self.imagearrone insertObject:store_three atIndex:0];
            }
            if ([store_two length] > 0 && [store_two rangeOfString:@"null"].location == NSNotFound) {
                [self.imagearrone insertObject:store_two atIndex:0];
            }
            if ([store_one length] > 0 && [store_one rangeOfString:@"null"].location == NSNotFound) {
                [self.imagearrone insertObject:store_one atIndex:0];
            }
            
            [self setupimageview];
            [self setupimageviewone];
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}

-(void)generatePayDimensionalCode{
    
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
  
    NSString *securityText =[UserModel defaultUser].name;
    
    NSString *encryptedString = [RSAEncryptor encryptString:securityText publicKeyWithContentsOfFile:public_key_path];
    
    self.payImage.image = [self logoQrCode:encryptedString];

}

- (void)updateInfo{
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer] && [[UserModel defaultUser].AudiThrough isEqualToString:@"1"]) {
        
        _titlesArr = @[@"头像",@"用户名",@"联系电话",@"ID",@"店铺地址",@"商家类型",@"证件号",@"推荐人ID",@"推荐人姓名"];
        _valuesArr = [NSMutableArray arrayWithObjects:[UserModel defaultUser].headPic,[UserModel defaultUser].truename,[UserModel defaultUser].phone,[UserModel defaultUser].name,[UserModel defaultUser].shop_address,[UserModel defaultUser].shop_type,[UserModel defaultUser].idcard,[UserModel defaultUser].tjr,[UserModel defaultUser].tjrname, nil];
        
    }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        
        _titlesArr = @[@"头像",@"用户名",@"联系电话",@"ID",@"证件号",@"推荐人ID",@"推荐人姓名"];
        _valuesArr = [NSMutableArray arrayWithObjects:[UserModel defaultUser].headPic,[UserModel defaultUser].truename,[UserModel defaultUser].phone,[UserModel defaultUser].name,[UserModel defaultUser].idcard,[UserModel defaultUser].tjr,[UserModel defaultUser].tjrname, nil];
    }
    
}

// 初始化
- (void)setupimageview
{
    if (self.doorView.subviews > 0) {
        [self.doorView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    int index;
    
    if (self.imagearr.count>1) {
        index = 1;
    }else{
        index = (int)self.imagearr.count;
    }
    
    for (int i =0 ; i< index; i++) {
        
        int h = i % 3;
        UIImageView *imagev=[[UIImageView alloc]init];
        UIButton *button=[[UIButton alloc]init];
        button.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [button setImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        imagev.tag = 10 + i;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(removeimage:) forControlEvents:UIControlEventTouchUpInside];
        imagev.userInteractionEnabled = YES;
        if ([self.imagearr[i] isKindOfClass:[NSString class]]) {
            [imagev sd_setImageWithURL:[NSURL URLWithString:self.imagearr[i]]];
        }else{
            imagev.image = self.imagearr[i];
        }
        imagev.frame = CGRectMake(10 + 100 * h, 5 , 90, 90);
        [self.doorView addSubview:imagev];
        if (i == self.imagearr.count - 1) {
            imagev.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *tappicture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePictures)];
            [imagev addGestureRecognizer:tappicture];
        }else{
            imagev.contentMode = UIViewContentModeScaleAspectFill;
            imagev.clipsToBounds = YES;
            UITapGestureRecognizer *tappicture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturePicture:)];
            [imagev addGestureRecognizer:tappicture];
            [imagev addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.trailing.equalTo(imagev).offset(0);
                make.top.equalTo(imagev).offset(0);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                
            }];
            
        }
    }
}

// 初始化
- (void)setupimageviewone
{
    if (self.innerView.subviews > 0) {
        [self.innerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    int index;
    if (self.imagearrone.count>3) {
        index = 3;
    }else{
        index = (int)self.imagearrone.count;
    }
    for (int i =0 ; i< index; i++) {
        
        //int v = i / 3;
        int h = i % 3;
        UIImageView *imagev=[[UIImageView alloc]init];
        UIButton *button=[[UIButton alloc]init];
        button.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [button setImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        imagev.tag = 20 + i;
        button.tag = 200 + i;
        [button addTarget:self action:@selector(removeimageone:) forControlEvents:UIControlEventTouchUpInside];
        imagev.userInteractionEnabled = YES;
        if ([self.imagearrone[i] isKindOfClass:[NSString class]]) {
            [imagev sd_setImageWithURL:[NSURL URLWithString:self.imagearrone[i]]];
        }else{
           imagev.image = self.imagearrone[i];
        }
        imagev.frame = CGRectMake(10 + 100 * h, 5 , 90, 90);
        [self.innerView addSubview:imagev];
        if (i == self.imagearrone.count - 1) {
            imagev.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *tappicture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePicturesone)];
            [imagev addGestureRecognizer:tappicture];
        }else{
            imagev.contentMode = UIViewContentModeScaleAspectFill;
            imagev.clipsToBounds = YES;
            UITapGestureRecognizer *tappicture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturePictureone:)];
            [imagev addGestureRecognizer:tappicture];
            [imagev addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.trailing.equalTo(imagev).offset(0);
                make.top.equalTo(imagev).offset(0);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                
            }];
            
        }
        
    }
    
}
-(void)removeimage:(UIButton*)sender{
    
    [self.imagearr removeObjectAtIndex:sender.tag - 100];
    
    [self setupimageview];
    
}

//单击图片
-(void)tapgesturePicture:(UITapGestureRecognizer*)gesture{
    
    UIImageView *imagev=(UIImageView*)gesture.view;
    NSMutableArray *arr = [self.imagearr mutableCopy];
    [arr removeLastObject];
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = imagev.tag - 10;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = arr;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}

-(void)takePictures{
    self.typeimage = 1;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
}

-(void)removeimageone:(UIButton*)sender{
    
    [self.imagearrone removeObjectAtIndex:sender.tag - 200];
    
    [self setupimageviewone];
    
}

//单击图片
-(void)tapgesturePictureone:(UITapGestureRecognizer*)gesture{
    
    UIImageView *imagev=(UIImageView*)gesture.view;
    NSMutableArray *arr = [self.imagearrone mutableCopy];
    [arr removeLastObject];
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex = imagev.tag - 20;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = arr;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}

-(void)takePicturesone{
    self.typeimage = 2;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - Private
- (void)uploadImage:(UIImage *)image{
    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 0.2);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    __weak typeof(self) wself = self;
    if (success) {
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error && wself) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    if (!error) {
                        [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                    }else{
                        //                        [wself.view makeToast:@"设置头像失败，请重试"
                        //                                     duration:2
                        //                                     position:CSToastPositionCenter];
                    }
                }];
            }else{
                //                [wself.view makeToast:@"图片上传失败，请重试"
                //                             duration:2
                //                             position:CSToastPositionCenter];
            }
        }];
    }else{
        //        [self.view makeToast:@"图片保存失败，请重试"
        //                    duration:2
        //                    position:CSToastPositionCenter];
    }
}
// 修改头像
-(void)reviseHeadImage:(NSData*)data{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 10;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/userAndShopInfoBq",URL_Base] parameters:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"app_version":APP_VERSION,@"version":@"3"}  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
 
    }progress:^(NSProgress *uploadProgress){
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            [self uploadImage:[UIImage imageWithData:data]];
            [MBProgressHUD showError:dic[@"message"]];
            
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
        [_loadV removeloadview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:@"上传失败，请检查网络是否连接"];
        
    }];
    
}
#pragma mark ------- 修改用户资料
-(void)reviseUsrInfo:(NSDictionary*)dic{

    NSMutableDictionary *mutdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    mutdic[@"token"] = [UserModel defaultUser].token;
    mutdic[@"uid"] = [UserModel defaultUser].uid;
    mutdic[@"app_version"] = APP_VERSION;
    mutdic[@"version"] = @"3";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 10;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/userAndShopInfoBq",URL_Base] parameters:mutdic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        

    }progress:^(NSProgress *uploadProgress){
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
            
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
        [_loadV removeloadview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:@"修改失败，请检查网络是否连接"];
        
    }];

}

-(void)reviseUserInfo:(NSString*)str index:(NSInteger)index{

    if ([_valuesArr[index] isEqualToString:str]) {
        return;
    }
    
    if (str.length <= 0) {
         [MBProgressHUD showError:@"不能为空"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([_titlesArr[index]  isEqualToString:@"用户名"]) {
        dic[@"truename"] = str;
    }else if ([_titlesArr[index]  isEqualToString:@"联系电话"]) {
        if (![predicateModel valiMobile:str]) {
            [MBProgressHUD showError:@"电话格式错误"];
            return;
        }
        dic[@"shop_phone"] = str;
    }
    
    [self reviseUsrInfo:dic];

}

//MARK: 二维码中间内置图片,可以是公司logo
-(UIImage*)logoQrCode:(NSString*)str{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [str dataUsingEncoding:NSUTF8StringEncoding];
 
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@""];
    
    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();

    //设置图片
    return  finalyImage;
}

#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titlesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        GLMine_headimageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_valuesArr[indexPath.row] isKindOfClass:[NSString class]]) {
            [cell.haedimage sd_setImageWithURL:[NSURL URLWithString:_valuesArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
        }else{
            cell.haedimage.image = _valuesArr[indexPath.row];
        }
        return cell;
    }else{
        GLMine_InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refrshdataSource:_titlesArr[indexPath.row] vaule:_valuesArr[indexPath.row]];
        cell.index = indexPath.row;
        __weak typeof(self) wself = self;
        cell.returnEditing = ^(NSString *content,NSInteger index){
            
            [wself reviseUserInfo:content index:index];
            
        };
        
         return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return 60;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        self.typeimage = 0;
            UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
            [actionSheet showInView:self.view];
    }
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer] && [[UserModel defaultUser].AudiThrough isEqualToString:@"1"]) {
        
            if ([_titlesArr[indexPath.row] isEqualToString:@"店铺地址"]) {//选择地址
                self.hidesBottomBarWhenPushed = YES;
                LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
                mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
                    [_valuesArr replaceObjectAtIndex:indexPath.row withObject:strposition];
                     [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                     NSMutableDictionary *dic =[NSMutableDictionary dictionary] ;
                     dic[@"sprovince"] = pro;
                     dic[@"scity"] = city;
                     dic[@"saera"] = area;
                     dic[@"saddress"] = strposition;
                    
                    [self reviseUsrInfo:dic];
                };
                [self.navigationController pushViewController:mapVC animated:YES];
            }
        }

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            if (self.typeimage != 0 ) {
                QBImagePickerController *imagePickerController = [QBImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.mediaType = QBImagePickerMediaTypeImage;
                imagePickerController.minimumNumberOfSelection = 1;
                if (self.typeimage == 1) {
                    imagePickerController.maximumNumberOfSelection = 1;
                }else{
                    imagePickerController.maximumNumberOfSelection = 4-self.imagearrone.count;
                }
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.showsNumberOfSelectedAssets = YES;
                [self presentViewController:imagePickerController animated:YES completion:NULL];
            }else{
                 [self getpicture];//获取相册
            }
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

        if (self.typeimage == 1) {
            //设置图片
            [self.imagearr insertObject:[UIImage imageWithData:data] atIndex:0];
            [self setupimageview];
        }else if(self.typeimage == 2) {
            //设置图片
            [self.imagearrone insertObject:[UIImage imageWithData:data] atIndex:0];
            [self setupimageviewone];
        }else if(self.typeimage == 0) {
            [_valuesArr replaceObjectAtIndex:0 withObject:[UIImage imageWithData:data]];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self reviseHeadImage:data];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark ---- 相册多选
#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    for (PHAsset *asset in assets) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        __weak typeof(self) weakself = self;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 400) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if (weakself.typeimage == 1) {
                //设置图片
                if (result != nil) {
                    [weakself.imagearr insertObject:result atIndex:0];
                    [weakself setupimageview];
                }
            }else{
                //设置图片
                if (result != nil) {
                    [weakself.imagearrone insertObject:result atIndex:0];
                    [weakself setupimageviewone];
                }
            }
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.usertypeArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    
    return SCREEN_WIDTH -20;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 50;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    [self.tableView reloadData];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
    return self.usertypeArr[row];
}

////重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20 , 50)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//点击pickerViewMask
-(void)tapgestureMask{

    [self.pickerView removeFromSuperview];
    [self.pickerViewMask removeFromSuperview];

}

- (IBAction)tapgestureBigimage:(UITapGestureRecognizer *)sender {
    
    UIImageView *imagev = (UIImageView*)sender.view;
    
    self.payCodeView.imagev.image = imagev.image;
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.payCodeView];
    self.payCodeView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.payCodeView.transform=CGAffineTransformMakeScale(1, 1);
    }];
    
}
#pragma mark ---- 提交图片修改
- (IBAction)submitReviseDoorImage:(UIButton *)sender {
    
    if (self.imagearr.count <= 1) {
        [MBProgressHUD showError:@"请上传门店照"];
        return;
    }
    if (self.imagearrone.count <= 1) {
        [MBProgressHUD showError:@"请上传内景照"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"app_version"] = APP_VERSION;
    dict[@"version"] = @"3";
    
    BOOL ismodifyOne = NO;//判断门店照修改
    BOOL ismodifyTwo = NO;//判断内景照修改
    
    for (int i = 0; i < self.imagearr.count - 1; i++) {
        if ([self.imagearr[i] isKindOfClass:[NSString class]]) {
            dict[@"store_pic"] = self.imagearr[i];
        }else{
            ismodifyOne = YES;
        }
    }
    
    NSMutableArray *imageurl = [NSMutableArray array];
    for (int i = 0; i < self.imagearrone.count - 1; i++) {
        if ([self.imagearrone[i] isKindOfClass:[NSString class]]) {
            [imageurl addObject:self.imagearrone[i]];
        }else{
            ismodifyTwo = YES;
        }
    }
    
    if (imageurl.count > 0) {
        dict[@"store_pics"] = [imageurl componentsJoinedByString:@","];
    }
    
    if (ismodifyOne == NO && ismodifyTwo == NO) {
        [MBProgressHUD showError:@"没有做任何修改"];
        return;
    }
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"store_one",@"store_two",@"store_three", nil];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/setStorePic",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < self.imagearr.count - 1; i++) {
            if (![self.imagearr[i] isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
                NSData *data = UIImagePNGRepresentation(self.imagearr[i]);
                [formData appendPartWithFileData:data name:@"store_pic" fileName:fileName mimeType:@"image/png"];
            }
        }
        for (int i = 0; i < self.imagearrone.count - 1; i++) {
            if (![self.imagearrone[i] isKindOfClass:[NSString class]]) {
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
                NSData *data = UIImagePNGRepresentation(self.imagearrone[i]);
                [formData appendPartWithFileData:data name:titleArr[i] fileName:fileName mimeType:@"image/png"];
            }
        }

        
    }progress:^(NSProgress *uploadProgress){
        
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];

        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
        [_loadV removeloadview];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
}

-(UIPickerView*)pickerView{

    if (!_pickerView) {
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 150, SCREEN_WIDTH - 20, 150)];
        _pickerView.dataSource=self;
        _pickerView.delegate=self;
        _pickerView.backgroundColor=[UIColor whiteColor];
    }
    return _pickerView;

}

-(UIView*)pickerViewMask{

    if (!_pickerViewMask) {
        _pickerViewMask=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _pickerViewMask.backgroundColor= YYSRGBColor(0, 0, 0, 0.2);
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMask)];
        [_pickerViewMask addGestureRecognizer:tap];
    }

    return _pickerViewMask;
}

-(NSArray*)usertypeArr{
    if (!_usertypeArr) {
        _usertypeArr=[NSArray array];
    }
    return _usertypeArr;
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [_maskView addGestureRecognizer:tapg];
        
    }
    return _maskView;
    
}
//取消
-(void)maskViewTap{
   
        [UIView animateWithDuration:0.3 animations:^{
            self.payCodeView.transform=CGAffineTransformMakeScale(0.1, 0.00001);
            
        } completion:^(BOOL finished) {
            
            [self.maskView removeFromSuperview];
            [self.payCodeView removeFromSuperview];
        }];

}
-(LBPayCodeView*)payCodeView{
    
    if (!_payCodeView) {
        _payCodeView = [[LBPayCodeView alloc]initWithFrame:CGRectMake(10, 65 , SCREEN_WIDTH - 20, SCREEN_WIDTH - 20)];
    }
    
    return _payCodeView;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(NSMutableArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"照片框-拷贝-9"], nil];
    }
    return _imagearr;
}

-(NSMutableArray*)imagearrone{
    
    if (!_imagearrone) {
        _imagearrone = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"照片框-拷贝-9"], nil];
    }
    return _imagearrone;
}

@end
