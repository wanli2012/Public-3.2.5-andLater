//
//  LBSaleManPersonInfoViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSaleManPersonInfoViewController.h"
#import "LBSaleManPersonInfoTableViewCell.h"

#import "GLMine_PersonInfoCodeView.h"
#import "NTESLogManager.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "UIView+Toast.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"

@interface LBSaleManPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *scanImage;

@property (nonatomic, strong)UIView *maskV;

@property (nonatomic, strong)GLMine_PersonInfoCodeView *contentV;
@end

@implementation LBSaleManPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBSaleManPersonInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBSaleManPersonInfoTableViewCell"];
    
    self.headimage.layer.cornerRadius = 45;
    self.headimage.clipsToBounds = YES;
    
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].headPic] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
    
    self.namelb.text = [UserModel defaultUser].truename;
    
    [self logoQrCode];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LBSaleManPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBSaleManPersonInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.typelb.text = @"ID";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].name];
    }else if (indexPath.row == 1) {
        cell.typelb.text = @"类别";
        if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER]) {
            cell.infolb.text = @"大区创客";
        }else if ([[UserModel defaultUser].usrtype isEqualToString:TWOSALER]) {
            cell.infolb.text = @"城市创客";
        }else if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
            cell.infolb.text = @"创客";
        }
        
    }else if (indexPath.row == 2) {
        cell.typelb.text = @"推荐人姓名";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].tjrname];
        if (cell.infolb.text.length <= 0) {
            cell.infolb.text=@"无";
        }
    }else if (indexPath.row == 3) {
        cell.typelb.text = @"推荐人ID";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].tjr];
        if (cell.infolb.text.length <= 0) {
            cell.infolb.text=@"无";
        }
    }else if (indexPath.row == 4) {
        cell.typelb.text = @"证件号码";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].idcard];
        if (cell.infolb.text.length <= 0 || [[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
            cell.infolb.text=@"无";
        }
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
            data=    UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        self.headimage.image = [UIImage imageWithData:data];
     
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self changeHeadImage];//更换头像
        [self uploadImage:self.headimage.image];
        
    }
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

//更换头像
-(void)changeHeadImage{

    NSDictionary  *dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid ,@"app_version" : APP_VERSION,
                         @"version"  : @"3"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/userAndShopInfoBq",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        if (self.headimage.image) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            NSData *data = UIImagePNGRepresentation(self.headimage.image);
            [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setCornerRadius:8.0];
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            [MBProgressHUD showError:dic[@"message"]];
            
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}

-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [[UserModel defaultUser].name dataUsingEncoding:NSUTF8StringEncoding];
    
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
    self.scanImage.image = finalyImage;
}
//点击二维码
- (IBAction)tapgestureScanImage:(UITapGestureRecognizer *)sender {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskV];
    [self.maskV addSubview:self.contentV];
    self.contentV.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.contentV.transform=CGAffineTransformMakeScale(1, 1);
    }];
}


- (IBAction)tapgestureheadimage:(UITapGestureRecognizer *)sender {
   
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
}
- (void)maskViewTap {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentV.transform=CGAffineTransformMakeScale(0.1, 0.00001);
        
    } completion:^(BOOL finished) {
        
        [self.maskV removeFromSuperview];
    }];
}

- (IBAction)backevent:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskV.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *maskViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [_maskV addGestureRecognizer:maskViewTap];
    }
    return _maskV;
}

- (GLMine_PersonInfoCodeView *)contentV{
    if (!_contentV) {
        _contentV = [[NSBundle mainBundle] loadNibNamed:@"GLMine_PersonInfoCodeView" owner:nil options:nil].lastObject;
        
        _contentV.layer.cornerRadius = 5.f;
        
        _contentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 40, 200);
        _contentV.codeImageV.image = self.scanImage.image;
        
    }
    return _contentV;
}

@end
