//
//  LBBillOfLadingSendViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingSendViewController.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "LBBillOfLadingViewController.h"

@interface LBBillOfLadingSendViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,NTESVerifyCodeManagerDelegate>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UIButton *submitbt;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UIButton *codebt;
@property (weak, nonatomic) IBOutlet UITextField *textf;
@property (strong, nonatomic)NSString *validate;
@property (assign, nonatomic)NSInteger index;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *totallb;
@property (weak, nonatomic) IBOutlet UILabel *bankInfoLb;

@end

@implementation LBBillOfLadingSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"提单";
    self.index = 0;
    NSString  *stringRandom =  [[NSUserDefaults standardUserDefaults]objectForKey:@"BillNumber"];
    
    if (stringRandom == nil || [stringRandom isEqualToString:@""]) {
        
        NSString *randomNumber = [self getRandomStringWithNum:5];
        
        self.textf.text = randomNumber;
        
        [[NSUserDefaults standardUserDefaults] setObject:randomNumber forKey:@"BillNumber"];//保存
    }else{
        
        self.textf.text = stringRandom;
    }
    
    _totallb.text = [NSString stringWithFormat:@"¥%.2f",_toatlMoney];
    
    self.bankInfoLb.text = [NSString stringWithFormat:@" 公司名称: %@\n 开  户  行: %@\n 账       号:%@",[UserModel defaultUser].congig_ads,[UserModel defaultUser].open_bank,[UserModel defaultUser].card_num];
    
}
//预留信息
- (IBAction)getCode:(UIButton *)sender {
    
    NSString *randomNumber = [self getRandomStringWithNum:5];
    
    self.textf.text = randomNumber;
}


- (IBAction)submitEvnt:(UIButton *)sender {
    
    if (self.index == 0) {
        [self.view makeToast:@"请上传打款凭证" duration:2.0 position:CSToastPositionCenter];
        return ;
        
    }
    
    self.manager = [NTESVerifyCodeManager sharedInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaid = CAPTCHAID;
        [self.manager configureVerifyCode:captchaid timeout:10.0];
        
        // 设置透明度
        self.manager.alpha = 0.7;
        
        // 设置frame
        self.manager.frame = CGRectNull;
        
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
    
}

-(void)sureSubmint{
    
    self.submitbt.enabled = NO;
    self.submitbt.backgroundColor = [UIColor lightGrayColor];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    NSDictionary  * dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"code":self.textf.text , @"order_id":self.idstr,@"validate":self.validate,@"app_version":APP_VERSION,@"version":@"3"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/orderLineSubmit",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@two.png",str];
        NSData   *data = UIImageJPEGRepresentation(self.imagev.image, 0.2);
        [formData appendPartWithFileData:data name:@"dkpz" fileName:fileName mimeType:@"image/png"];
        
        
        for (int i = 0; i < self.imageArr.count ; i++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@two.png",str];
            UIImage *image = (UIImage*)self.imageArr[i][@"value"];
            NSData   *data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:self.imageArr[i][@"key"] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_loadV removeloadview];
        self.submitbt.enabled = YES;
        self.submitbt.backgroundColor = TABBARTITLE_COLOR;
        if ([dic[@"code"]integerValue]==1) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshBillListData" object:nil];
            [MBProgressHUD showError:dic[@"message"]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"BillNumber"];//清除
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LBBillOfLadingViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            
        }else{
            self.submitbt.enabled = YES;
            [MBProgressHUD showError:dic[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.submitbt.enabled = YES;
        self.submitbt.backgroundColor = TABBARTITLE_COLOR;
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
    
}
- (IBAction)tapgestruePhoto:(UITapGestureRecognizer *)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    [MBProgressHUD showError:message];
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    
    if (result == YES) {
        self.validate = validate;
        [self sureSubmint];
    }
    
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    self.submitbt.enabled = YES;
    self.submitbt.backgroundColor = TABBARTITLE_COLOR;
    
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    [MBProgressHUD showError:error.localizedDescription];
    self.submitbt.enabled = YES;
    self.submitbt.backgroundColor = TABBARTITLE_COLOR;
    
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
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        
        self.imagev.image = image;
        self.index = 1;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
- (NSString *)getRandomStringWithNum:(NSInteger)num
{
    
    NSString *string = [[NSString alloc]init];
    
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
            
        }else{//大写字母
            
            int figure = (arc4random() % 26) + 65;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.codebt.layer.cornerRadius = 4;
    self.codebt.clipsToBounds = YES;
    
    self.submitbt.layer.cornerRadius = 4;
    self.submitbt.clipsToBounds = YES;
    
    
}
@end
