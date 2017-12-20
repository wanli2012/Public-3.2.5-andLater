//
//  GLAddStoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddStoreController.h"
#import "LBMineCenterChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "LBBaiduMapViewController.h"

@interface GLAddStoreController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
     BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (weak, nonatomic) IBOutlet UITextField *licenseTF;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *legalPersonNameTF;
@property (weak, nonatomic) IBOutlet UITextField *legalPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;

@property (weak, nonatomic) IBOutlet UIImageView *IDImageV;
@property (weak, nonatomic) IBOutlet UIImageView *IDImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV3;

@property (weak, nonatomic) IBOutlet UIImageView *licenseImageV;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (strong, nonatomic)NSString *adressID;
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

//地图
@property (nonatomic, copy)NSString *latStr;
@property (nonatomic, copy)NSString *longStr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger tapIndex;//判断点击的是那个图片

@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation GLAddStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增门店";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
 
    self.submitBtn.layer.cornerRadius = 5.f;
    
    self.codeBtn.layer.cornerRadius = 5.f;
    
    self.contentViewWidth.constant = SCREEN_WIDTH;

    self.cityLabel.text = @"请选择省市区";
    self.cityLabel.textColor = [UIColor lightGrayColor];
    
    self.mapAddressLabel.text = @"请选择地址";
    self.mapAddressLabel.textColor = [UIColor lightGrayColor];
    
    [self getPickerData];
}
#pragma mark - get data
- (void)getPickerData {
    //行业列表
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
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
//获取验证码
- (IBAction)getCode:(id)sender {
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":self.phoneTF.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    

}
//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
                self.codeBtn.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
                self.codeBtn.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
//提交
- (IBAction)submit:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }

    if (self.codeTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if (self.shopNameTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入店名"];
        return;
    }
    
    if (self.legalPhoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if (self.cityLabel.text.length <=0 ) {
        [MBProgressHUD showError:@"请选择省市区"];
        return;
    }
    if (self.mapAddressLabel.text.length <=0 ) {
        [MBProgressHUD showError:@"请地图选址"];
        return;
    }
    if (self.legalPersonNameTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入法人姓名"];
        return;
    }
    if (self.legalPhoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入法人号码"];
        return;
    }
    if (self.passwordTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (self.ensurePwdTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请确认密码"];
        return;
    }

//    NSLog(@"提交");
    [self postRequest];
}
- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;

    dict[@"phone"] = self.phoneTF.text;
    dict[@"password"] = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    dict[@"yzm"] = self.codeTF.text;
    dict[@"corporation_name"] = self.legalPersonNameTF.text;
    dict[@"corporation_phone"] = self.legalPhoneTF.text;
    dict[@"shop_name"] = self.shopNameTF.text;
    dict[@"license_num"] = self.licenseTF.text;
    dict[@"s_province"] = self.provinceStrId;
    dict[@"s_city"] = self.cityStrId;
    dict[@"s_area"] = self.countryStrId;
    dict[@"s_address"] = self.detailAddressTF.text;
    dict[@"lat"] = self.latStr;
    dict[@"lng"] = self.longStr;
    dict[@"app_version"] = APP_VERSION;
    dict[@"version"] = @"3";
    
    NSArray *imageViewArr = [NSArray arrayWithObjects:self.IDImageV,self.IDImageV2,self.signImageV,self.picImageV,self.picImageV2,self.picImageV3,self.licenseImageV,nil];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"face_pic",@"con_pic",@"store_pic",@"store_one",@"store_two",@"store_three",@"license_pic", nil];
    
//    NSLog(@"%@",dict);
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@Shop/addSonStore",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        NSLog(@"dict = %@",dict);
        for (int i = 0; i < imageViewArr.count; i ++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            UIImageView *imaev = (UIImageView*)imageViewArr[i];
            NSData *data = UIImagePNGRepresentation(imaev.image);
            [formData appendPartWithFileData:data name:titleArr[i] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
//        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
//
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
        [_loadV removeloadview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
//省市区选择
- (IBAction)locationChoose:(id)sender {
    
    LBMineCenterChooseAreaViewController *vc=[[LBMineCenterChooseAreaViewController alloc]init];
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    vc.dataArr = self.dataArr;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.cityLabel.textColor = [UIColor blackColor];
        weakself.adressID = strid;
        weakself.cityLabel.text = str;
        weakself.provinceStrId = provinceid;
        weakself.cityStrId = cityd;
        weakself.countryStrId = areaid;
    };
}
- (IBAction)mapAddressChoose:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
     __weak typeof(self) weakself = self;
    mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
        //        self.adress = strposition;
        //        self.sprovince = pro;
        //        self.scity =city;
        //        self.saera = area;
        weakself.mapAddressLabel.textColor = [UIColor blackColor];
        weakself.latStr = [NSString stringWithFormat:@"%f",coors.latitude];
        weakself.longStr = [NSString stringWithFormat:@"%f",coors.longitude];
        weakself.mapAddressLabel.text = [NSString stringWithFormat:@"%@",strposition];
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (IBAction)pictureProcessing:(UITapGestureRecognizer *)sender {
    if (sender.view == self.IDImageV) {
        _tapIndex = 1;
        
    }else if(sender.view == self.IDImageV2){
        _tapIndex = 2;
        
    }else if(sender.view == self.signImageV){
        _tapIndex = 3;
        
    }else if(sender.view == self.picImageV){
        _tapIndex = 4;
        
    }else if(sender.view == self.picImageV2){
        _tapIndex = 5;
        
    }else if(sender.view == self.picImageV3){
        _tapIndex = 6;
        
    }else if(sender.view == self.licenseImageV){
        _tapIndex = 7;
        
    }
    [self tapgesturephotoOrCamera];
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
            
            data = UIImageJPEGRepresentation(image, 0.1);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        switch (self.tapIndex) {
            case 1:
            {
                self.IDImageV.image = [UIImage imageWithData:data];
            }
                break;
            case 2:
            {
                self.IDImageV2.image = [UIImage imageWithData:data];
            }
                break;
            case 3:
            {
                self.signImageV.image = [UIImage imageWithData:data];
            }
                break;
            case 4:
            {
                self.picImageV.image = [UIImage imageWithData:data];
            }
                break;
            case 5:
            {
                self.picImageV2.image = [UIImage imageWithData:data];
            }
                break;
            case 6:
            {
                self.picImageV3.image = [UIImage imageWithData:data];
            }
                break;
            case 7:
            {
                self.licenseImageV.image = [UIImage imageWithData:data];
            }
                break;
                
            default:
                break;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF && [string isEqualToString:@"\n"]) {
        [self.codeTF becomeFirstResponder];
        return NO;
    }else if (textField == self.codeTF && [string isEqualToString:@"\n"]) {
        [self.shopNameTF becomeFirstResponder];
        return NO;
    }else if (textField == self.shopNameTF && [string isEqualToString:@"\n"]) {
        [self.licenseTF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.licenseTF && [string isEqualToString:@"\n"]){
        [self.detailAddressTF becomeFirstResponder];
        return NO;
    }
    else if (textField == self.detailAddressTF && [string isEqualToString:@"\n"]){
        [self.legalPersonNameTF becomeFirstResponder];
        return NO;
    }else if (textField == self.legalPersonNameTF && [string isEqualToString:@"\n"]){
        
        [self.legalPhoneTF becomeFirstResponder];
        return NO;
    }else if (textField == self.legalPhoneTF && [string isEqualToString:@"\n"]){
        
       [self.passwordTF becomeFirstResponder];
        return NO;
    }else if (textField == self.passwordTF && [string isEqualToString:@"\n"]){
        
        [self.ensurePwdTF becomeFirstResponder];
        return NO;
    }else if (textField == self.ensurePwdTF && [string isEqualToString:@"\n"]){
        
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
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

@end
