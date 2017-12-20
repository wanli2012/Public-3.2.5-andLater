//
//  LBBelowTheLineViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBelowTheLineViewController.h"
#import "IncentiveModel.h"
#import "LBBelowTheLineListViewController.h"
#import "SelectUserTypeView.h"
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface LBBelowTheLineViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,NTESVerifyCodeManagerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIView *baseView1;
@property (weak, nonatomic) IBOutlet UIView *baseView2;
@property (weak, nonatomic) IBOutlet UIView *baseview3;
@property (weak, nonatomic) IBOutlet UIView *baseView4;
@property (weak, nonatomic) IBOutlet UIView *baseView5;
@property (weak, nonatomic) IBOutlet UIButton *comitbt;

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *modeltf;
@property (weak, nonatomic) IBOutlet UITextField *moneyTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *numTf;

@property (weak, nonatomic) IBOutlet UIView *contentView;//内容View

@property (strong, nonatomic)IncentiveModel *incentiveModelV;
@property (strong, nonatomic)UIView *incentiveModelMaskV;
@property (nonatomic, assign) NSInteger userytpe; // 让利类型 1 20% 2 10% 3 5%

@property (nonatomic, assign) NSInteger documentType; // 1为打款凭证，2为消费凭证
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIImageView *TriangleImage;

@property (strong, nonatomic)NSString *phoneNum;//保存电话号码

@property (nonatomic, strong)SelectUserTypeView *selectUserTypeView;
@property (strong, nonatomic)NSString *usertype;
@property (weak, nonatomic) IBOutlet UITextField *usertypeTf;
@property (weak, nonatomic) IBOutlet UIView *userTypeView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLb;
@property (strong, nonatomic)NSString *validate;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@end

@implementation LBBelowTheLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"线下下单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.phoneNum = @"";
    UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
    [self.incentiveModelMaskV addGestureRecognizer:incentiveModelMaskVgesture];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"记录"] style:UIBarButtonItemStylePlain target:self action:@selector(checkrecorderEvent)];
    item.imageInsets = UIEdgeInsetsMake(5, -5, 0, 5);
    self.navigationItem.rightBarButtonItem = item;
    
    self.usertype = Retailer;
    self.usertypeTf.text=@"商家";
    self.noticeLb.text = [NSString stringWithFormat:@" 公司名称: %@\n 开  户  行: %@\n 账       号:%@",[UserModel defaultUser].congig_ads,[UserModel defaultUser].open_bank,[UserModel defaultUser].card_num];
}

-(void)checkrecorderEvent{
    
    self.hidesBottomBarWhenPushed = YES;
    LBBelowTheLineListViewController *vc = [[LBBelowTheLineListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

//帐户类型选择
- (IBAction)accountTypeChoose:(id)sender {
//    __weak typeof(self) weakSelf = self;
//    
//    self.selectUserTypeView.block = ^(NSInteger index){
//        
//        switch (index) {
//            case 0://会员
//            {
//                weakSelf.usertype = OrdinaryUser;
//                weakSelf.usertypeTf.text=@"会员";
//            }
//                break;
//            case 1://商家
//            {
//                weakSelf.usertype = Retailer;
//                weakSelf.usertypeTf.text=@"商家";
//            }
//                break;
//            case 2://创客
//            {
//                weakSelf.usertype = THREESALER;
//                weakSelf.usertypeTf.text=@"创客";
//            }
//                break;
//            case 3://城市创客
//            {
//                weakSelf.usertype = TWOSALER;
//                weakSelf.usertypeTf.text=@"城市创客";
//            }
//                break;
//            case 4://大区创客
//            {
//                weakSelf.usertype = ONESALER;
//                weakSelf.usertypeTf.text=@"大区创客";
//            }
//                break;
//            case 5://省级服务中心
//            {
//                weakSelf.usertype = PROVINCE;
//                weakSelf.usertypeTf.text=@"省级服务中心";
//            }
//                break;
//            case 6://市级服务中心
//            {
//                weakSelf.usertype = CITY;
//                weakSelf.usertypeTf.text=@"市级服务中心";
//            }
//                break;
//            case 7://区级服务中心
//            {
//                weakSelf.usertype = DISTRICT;
//                weakSelf.usertypeTf.text=@"区级服务中心";
//            }
//                break;
//            case 8://省级行业服务中心
//            {
//                weakSelf.usertype = PROVINCE_INDUSTRY;
//                weakSelf.usertypeTf.text=@"省级行业服务中心";
//            }
//                break;
//            case 9://市级行业服务中心
//            {
//                weakSelf.usertype = CITY_INDUSTRY;
//                weakSelf.usertypeTf.text=@"市级行业服务中心";
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        [weakSelf incentiveModelMaskVtapgestureLb];
//        
//    };
//    
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//    
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect rect=[self.usertypeTf convertRect:self.usertypeTf.bounds toView:window];
//    
//    [self.view addSubview:self.incentiveModelMaskV];
//    
//    [self.view addSubview:self.selectUserTypeView];
//    
//    _selectUserTypeView.frame = CGRectMake(90, rect.origin.y + 45, rect.size.width, 0);
//    
//        [UIView animateWithDuration:0.3 animations:^{
//
//        _selectUserTypeView.alpha = 1;
//        _selectUserTypeView.frame = CGRectMake(90, rect.origin.y + 45, rect.size.width, 180);
//            
//    } completion:^(BOOL finished) {
//        
//    }];

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

//选择激励模式
- (IBAction)choseJiliModel:(UITapGestureRecognizer *)sender {
   

    self.TriangleImage.transform = CGAffineTransformMakeRotation(M_PI);

    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.baseView2 convertRect: self.baseView2.bounds toView:window];
    
    self.incentiveModelV.frame=CGRectMake(SCREEN_WIDTH-130, rect.origin.y+20, 120, 150);
    
    [self.view addSubview:self.incentiveModelMaskV];
    [self.incentiveModelMaskV addSubview:self.incentiveModelV];
}
//打款凭证
- (IBAction)choseimageone:(UITapGestureRecognizer *)sender {
    self.documentType = 1;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}
//消费凭证
- (IBAction)choseimageTwo:(UITapGestureRecognizer *)sender {
    self.documentType = 2;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}
//提交
- (IBAction)submitInfoEvent:(UIButton *)sender {
    
    if (self.phoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写购买会员"];
        return;
    }
    if (self.modeltf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择奖励模式"];
        return;
    }
    if (self.moneyTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写消费金额"];
        return;
    }else{
        if ([self.moneyTf.text hasPrefix:@"."] || [self.moneyTf.text hasSuffix:@"."]) {
            [MBProgressHUD showError:@"消费金额格式错误"];
            return;
        }
    }
    
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商品名称"];
        return;
    }
    if (self.numTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商品数量"];
        return;
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
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"User/getTrueName" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"username" :self.phoneTf.text,@"group_id" :self.usertype} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                NSString *str=[NSString stringWithFormat:@"确定向%@下单吗?",responseObject[@"data"][@"truename"]];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else if ([responseObject[@"code"] integerValue]==3){

            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{

            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];

        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        self.comitbt.enabled = NO;
        self.comitbt.backgroundColor = [UIColor lightGrayColor];
        
        NSDictionary  * dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"phone":self.phoneTf.text , @"rlmodel_type":[NSNumber numberWithInteger:self.userytpe],@"money":self.moneyTf.text,@"shopname":self.nameTf.text,@"shopnum":self.numTf.text,@"validate":self.validate,@"app_version":APP_VERSION,@"version":@"3"};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 20;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@User/placeOrderLineByUser",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            
        }progress:^(NSProgress *uploadProgress){
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
            
            if (uploadProgress.fractionCompleted == 1.0) {
                 [SVProgressHUD dismiss];
            }
            
        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           
             self.comitbt.enabled = YES;
             self.comitbt.backgroundColor = TABBARTITLE_COLOR;
            if ([dic[@"code"]integerValue]==1) {
                
                [MBProgressHUD showError:dic[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"randomNumber"];//清除
                
            }else{
                [MBProgressHUD showError:dic[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self.comitbt.enabled = YES;
            self.comitbt.backgroundColor = TABBARTITLE_COLOR;
            [MBProgressHUD showError:error.localizedDescription];
        }];
                
    }else{
        self.comitbt.enabled = YES;
        self.comitbt.backgroundColor = TABBARTITLE_COLOR;
    }
    
}
//结束编辑
- (IBAction)endeditEvent:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
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
      
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTf && [string isEqualToString:@"\n"]) {
        [self.moneyTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.moneyTf && [string isEqualToString:@"\n"]){
        
        [self.nameTf becomeFirstResponder];
        return NO;
    }else if (textField == self.nameTf && [string isEqualToString:@"\n"]){
        
        [self.numTf becomeFirstResponder];
        return NO;
    }else if (textField == self.numTf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.phoneTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    BOOL isHaveDian = NO;
    
    if (textField == self.moneyTf || textField == self.numTf) {
        /*
         * 不能输入.0-9以外的字符。
         * 设置输入框输入的内容格式
         * 只能有一个小数点
         * 小数点后最多能输入两位
         * 如果第一位是.则前面加上0.
         * 如果第一位是0则后面必须输入点，否则不能输入。
         */
        
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            isHaveDian = YES;
        }else{
            isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                [MBProgressHUD showError:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (isHaveDian && single == '.') {
                [MBProgressHUD showError:@"最多只能输入一个小数点"];
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        [MBProgressHUD showError:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
            
        }
    }
    
    return YES;
    
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
    self.comitbt.enabled = YES;
    self.comitbt.backgroundColor = TABBARTITLE_COLOR;

}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    [MBProgressHUD showError:error.localizedDescription];
    self.comitbt.enabled = YES;
    self.comitbt.backgroundColor = TABBARTITLE_COLOR;

}




#pragma mark - 点击激励模式选择
-(void)threeButtonE{
    self.userytpe = [KThreePersent integerValue];
    self.modeltf.text = @"3%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}

-(void)sixbuttonE{
    self.userytpe=3;
    self.modeltf.text=@"5%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
-(void)twenteenButtonE{
    self.userytpe=2;
    self.modeltf.text=@"10%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
-(void)twentyFbuttonE{
    self.userytpe=1;
    self.modeltf.text=@"20%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
//        self.selectUserTypeView.transform=CGAffineTransformMakeScale(1.0f, 0.00001f);
//        self.selectUserTypeView.height = 0;
        self.selectUserTypeView.alpha = 0;
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[self.usertypeTf convertRect:self.usertypeTf.bounds toView:window];
        
        _selectUserTypeView.tableView.frame = CGRectMake(0, 0, rect.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        [self.selectUserTypeView removeFromSuperview];
        [self.incentiveModelMaskV removeFromSuperview];
    }];
    
    [self.incentiveModelV removeFromSuperview];

    self.TriangleImage.transform = CGAffineTransformIdentity;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.baseView1.layer.cornerRadius = 4;
    self.baseView1.clipsToBounds = YES;
    self.baseView2.layer.cornerRadius = 4;
    self.baseView2.clipsToBounds = YES;
    self.baseview3.layer.cornerRadius = 4;
    self.baseview3.clipsToBounds = YES;
    self.baseView4.layer.cornerRadius = 4;
    self.baseView4.clipsToBounds = YES;
    self.baseView5.layer.cornerRadius = 4;
    self.baseView5.clipsToBounds = YES;
  
    self.comitbt.layer.cornerRadius = 4;
    self.comitbt.clipsToBounds = YES;
    
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 600;

}

-(IncentiveModel*)incentiveModelV{
    
    if (!_incentiveModelV) {
        _incentiveModelV=[[NSBundle mainBundle]loadNibNamed:@"IncentiveModel" owner:self options:nil].firstObject;
        [_incentiveModelV.threeButton addTarget:self action:@selector(threeButtonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.sixButton addTarget:self action:@selector(sixbuttonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twenteenButton addTarget:self action:@selector(twenteenButtonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twentyFBt addTarget:self action:@selector(twentyFbuttonE) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _incentiveModelV;
    
}
-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
    }
    
    return _incentiveModelMaskV;
    
}

-(SelectUserTypeView*)selectUserTypeView{
    
    if (!_selectUserTypeView) {
        _selectUserTypeView=[[NSBundle mainBundle]loadNibNamed:@"SelectUserTypeView" owner:self options:nil].firstObject;
        
        _selectUserTypeView.layer.cornerRadius = 10.f;
        _selectUserTypeView.clipsToBounds = YES;

        _selectUserTypeView.dataSoure  = @[@"会员",@"商家",@"创客",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心",@"省级行业服务中心",@"市级行业服务中心"];

    }
    
    return _selectUserTypeView;
    
}
@end
