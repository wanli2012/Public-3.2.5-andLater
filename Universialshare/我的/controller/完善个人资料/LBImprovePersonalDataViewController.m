//
//  LBImprovePersonalDataViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/18.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBImprovePersonalDataViewController.h"
#import "GLLoginController.h"
#import "BaseNavigationViewController.h"


@interface LBImprovePersonalDataViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;

@property (weak, nonatomic) IBOutlet UITextField *sixSecretTf;
@property (weak, nonatomic) IBOutlet UITextField *sixSecretTf1;
@property (weak, nonatomic) IBOutlet UIButton *surebutton;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIButton *exitbt;

@property (strong, nonatomic)NSString *status;//判断登录是否过期

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@property (weak, nonatomic) IBOutlet UIImageView *positiveImage;//身份证正面

@property (weak, nonatomic) IBOutlet UIImageView *otherImage;//身份证反面
@property (weak, nonatomic) IBOutlet UIImageView *saleImage;//消费承诺书
@property (strong, nonatomic)NSString *sexstr;//性别
@property (weak, nonatomic) IBOutlet UIImageView *manImage;
@property (weak, nonatomic) IBOutlet UIImageView *womanimage;
@property (weak, nonatomic) IBOutlet UITextField *adresstf;
@property (weak, nonatomic) IBOutlet UILabel *saletile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleimageConstrait;
@property (weak, nonatomic) IBOutlet UILabel *chengluoshu;

@property (assign, nonatomic)NSInteger tapIndex;//判断点击的是那个图片

@end

@implementation LBImprovePersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"实名认证";
    self.status = @"0";
    self.sexstr = @"0";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)exitButton:(UIButton *)sender {
    
//    [UserModel defaultUser].loginstatus = NO;
//    [UserModel defaultUser].headPic = @"";
//    [UserModel defaultUser].usrtype = @"0";
//    [usermodelachivar achive];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];

}

//选择正面
- (IBAction)tapgesturepositiveImage:(UITapGestureRecognizer *)sender {
    _tapIndex = 1;
    [self tapgesturephotoOrCamera];
}
//选择反面
- (IBAction)tapgestureotherimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 2;
    [self tapgesturephotoOrCamera];
}
//消费承诺书
- (IBAction)tapgesturepromiseImage:(UITapGestureRecognizer *)sender {
    _tapIndex = 3;
    [self tapgesturephotoOrCamera];
}

- (IBAction)tapgesturewoman:(UITapGestureRecognizer *)sender {
    
    self.sexstr = @"1";
    self.manImage.image = [UIImage imageNamed:@"location_off"];
    self.womanimage.image = [UIImage imageNamed:@"location_on"];
    
}

- (IBAction)tapgestureMan:(UITapGestureRecognizer *)sender {
    
    self.sexstr = @"0";
    self.manImage.image = [UIImage imageNamed:@"location_on"];
    self.womanimage.image = [UIImage imageNamed:@"location_off"];
    
}


- (IBAction)surebutton:(UIButton *)sender {
    
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if (self.codeTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入身份证"];
        return;
    }else{
        if (![predicateModel validateIdentityCard:self.codeTf.text]) {
            [MBProgressHUD showError:@"请输入正确的身份证"];
            return;
        }
    }
    
    if (self.sixSecretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (self.sixSecretTf1.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (self.sixSecretTf1.text.length != 6) {
        [MBProgressHUD showError:@"请输入6位密码"];
        return;
    }
    
    if (![self.sixSecretTf1.text isEqualToString:self.sixSecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    
    
    if (!self.positiveImage.image || [UIImagePNGRepresentation(self.positiveImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"样板-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证正面照"];
        return;
    }
    
    if (!self.otherImage.image || [UIImagePNGRepresentation(self.otherImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证反面照"];
        return;
    }
    
    if (self.adresstf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入地址"];
        return;
    }
    
     NSString *encryptsecret = [RSAEncryptor encryptString:self.sixSecretTf.text publicKey:public_RSA];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"token"]=[UserModel defaultUser].token;
    dict[@"uid"]=[UserModel defaultUser].uid;
    dict[@"truename"]=self.nameTf.text;
    dict[@"idcard"]=self.codeTf.text;
    dict[@"sexer"]=self.sexstr;
    dict[@"twopwd"]=encryptsecret;
    dict[@"address"]=self.adresstf.text;
    dict[@"app_version"] = APP_VERSION;
    dict[@"version"] = @"3";
    NSArray *imageViewArr = @[];;
    NSArray *titleArr = @[];
    
    imageViewArr = [NSArray arrayWithObjects:self.positiveImage,self.otherImage, nil];
    
    titleArr = [NSArray arrayWithObjects:@"face_pic",@"con_pic", nil];
    
    
    self.surebutton.userInteractionEnabled = NO;
    self.surebutton.backgroundColor = [UIColor grayColor];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/userInfoBq",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        for (int i = 0; i < imageViewArr.count; i++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            UIImageView *imaev = (UIImageView*)imageViewArr[i];
            NSData *data = UIImagePNGRepresentation(imaev.image);
            [formData appendPartWithFileData:data name:titleArr[i] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD setCornerRadius:8.0];
        if (uploadProgress.fractionCompleted == 1.0) {
             [SVProgressHUD dismiss];
        }

    }success:^(NSURLSessionDataTask *task, id responseObject) {
        self.surebutton.userInteractionEnabled = YES;
        self.surebutton.backgroundColor = TABBARTITLE_COLOR;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:@"资料认证中..."];
            [self.navigationController  popViewControllerAnimated:YES];
            [UserModel defaultUser].truename = self.nameTf.text;
            [UserModel defaultUser].idcard = self.codeTf.text;
            [UserModel defaultUser].rzstatus = @"1";
            
            [usermodelachivar achive];
            
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.surebutton.userInteractionEnabled = YES;
        self.surebutton.backgroundColor = TABBARTITLE_COLOR;
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

//选择图片来源
-(void)tapgesturephotoOrCamera{
    
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
                self.positiveImage.image = [UIImage imageWithData:data];
            }
                break;
            case 2:
            {
                self.otherImage.image = [UIImage imageWithData:data];
            }
                break;
            case 3:
            {
                self.saleImage.image = [UIImage imageWithData:data];
            }
                break;
           
                
            default:
                break;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.nameTf && [string isEqualToString:@"\n"]) {
        [self.codeTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.codeTf && [string isEqualToString:@"\n"]){
        
        [self.sixSecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.sixSecretTf && [string isEqualToString:@"\n"]){
        
        [self.sixSecretTf1 becomeFirstResponder];
        return NO;
    }else if (textField == self.sixSecretTf1 && [string isEqualToString:@"\n"]){
        
        [self.adresstf becomeFirstResponder];
        return NO;
    }else if (textField == self.adresstf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.codeTf ) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    if (textField == self.nameTf && ![string isEqualToString:@""]) {
        //只能输入英文或中文
        NSCharacterSet * charact;
        charact = [[NSCharacterSet characterSetWithCharactersInString:NMUBERS]invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:charact]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if(canChange) {
            [MBProgressHUD showError:@"只能输入英文或中文"];
            return NO;
        }
    }
    
    if (textField == self.sixSecretTf || textField == self.sixSecretTf1) {
        //字符串删除时触发
        if ([string isEqualToString:@""] && range.length >0) {
            return YES;
            //字符串写入时触发
        }else {//限制6位
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            if (existedLength - selectedLength + replaceLength > 6) {
                return NO;
            }
        }
    }
    
    return YES;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentW.constant =SCREEN_WIDTH;
    
    self.surebutton.layer.cornerRadius = 4;
    self.surebutton.clipsToBounds = YES;
    
    self.exitbt.layer.cornerRadius = 4;
    self.exitbt.clipsToBounds = YES;
    
    self.saletile.hidden = NO;
    self.saleImage.hidden = NO;
    self.saleimageConstrait.constant = 110;
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
        
        self.chengluoshu.text = @"消费承诺书";
        self.chengluoshu.hidden = YES;
        self.saleImage.hidden = YES;
         self.contentH.constant =650;
        
    }else if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        self.chengluoshu.text = @"商户承诺书";
        self.chengluoshu.hidden = YES;
        self.saleImage.hidden = YES;
         self.contentH.constant =650;
    }else{
        self.chengluoshu.text = @"创客承诺书";
        self.chengluoshu.hidden = YES;
        self.saleImage.hidden = YES;
         self.contentH.constant =650;
    }

}
- (IBAction)connectPhoneTf:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


@end
