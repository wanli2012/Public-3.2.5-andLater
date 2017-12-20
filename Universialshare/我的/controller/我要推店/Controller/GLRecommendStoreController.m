//
//  GLRecommendStoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStoreController.h"
#import "GLRecommendStroe_RecordController.h"
#import "QBImagePickerController.h"
#import <Masonry/Masonry.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "JZAlbumViewController.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"

@interface GLRecommendStoreController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
    NSURLSessionDataTask *_dataTask;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typelabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *SNlabel;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIView *imageview;
@property (weak, nonatomic) IBOutlet UIView *imageviewt;

@property (strong, nonatomic)LoadWaitView *loadV;
/**
 *imagearr  商品图片数组 imagearrone  环境图片数组
 */
@property (strong, nonatomic)  NSMutableArray *imagearr;
@property (strong, nonatomic)  NSMutableArray *imagearrone;
@property (strong, nonatomic)  NSMutableArray *industryArr;
@property (assign, nonatomic)  NSInteger  typeimage;//判断是加入商品还是环境图片
@property (assign, nonatomic)  NSInteger  selectOne;//商户类型一级
@property (assign, nonatomic)  NSInteger  selectTwo;//商户类型二级

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation GLRecommendStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我要推店";
    
    self.firstView.layer.cornerRadius = 5.f;
    self.secondView.layer.cornerRadius = 5.f;
    self.thirdView.layer.cornerRadius = 5.f;
 
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 44);
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [rightBtn setTitle:@"推荐记录" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    int num = (arc4random() % 1000000);
    self.SNlabel.text = [NSString stringWithFormat:@"%.6d", num];
    
    [self setupimageview];
    [self setupimageviewone];
    [self getshoptype];//获取商户类别

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_dataTask cancel];
    
}
-(void)getshoptype{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getHylist" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token } finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.industryArr addObjectsFromArray:responseObject[@"data"]];
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

// 初始化
- (void)setupimageview
{
    if (self.imageview.subviews > 0) {
        [self.imageview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    int index;
    
    if (self.imagearr.count>3) {
        index = 3;
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
        imagev.image = self.imagearr[i];
        imagev.frame = CGRectMake(10 + 90 * h, 10 , 80, 80);
        [self.imageview addSubview:imagev];
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
    if (self.imageviewt.subviews > 0) {
        [self.imageviewt.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
        imagev.image = self.imagearrone[i];
        imagev.frame = CGRectMake(10 + 90 * h, 10 , 80, 80);
        [self.imageviewt addSubview:imagev];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)record {
    self.hidesBottomBarWhenPushed = YES;
    GLRecommendStroe_RecordController *record = [[GLRecommendStroe_RecordController alloc] init];
    [self.navigationController pushViewController:record animated:YES];
}
//选择商户一级
- (IBAction)typeChoose:(id)sender {
   
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    if (self.industryArr.count != 0) {
        
        vc.provinceArr = self.industryArr;
        vc.titlestr = @"请选择一级商户";
        vc.returnreslut = ^(NSInteger index){
            self.selectOne = index;
            self.typeLabel.text = _industryArr[index][@"trade_name"];
            self.typelabelTwo.text = @"请选择";
            
        };
        vc.transitioningDelegate=self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"一级分类暂无数据"];
    }
    
}
//选择商户二级
- (IBAction)typechooseTwo:(UITapGestureRecognizer *)sender {
    
    if ([self.typeLabel.text isEqualToString:@"请选择"] || self.typeLabel.text.length <= 0) {
        [MBProgressHUD showError:@"请选择一级商户"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    if(self.industryArr.count != 0){
        NSArray *arr = self.industryArr[self.selectOne][@"son"];
        if(arr.count != 0){
            
            vc.provinceArr = [NSMutableArray arrayWithArray:arr];
            vc.titlestr = @"请选择二级商户";
            vc.returnreslut = ^(NSInteger index){
                self.selectTwo = index;
                self.typelabelTwo.text = [NSString stringWithFormat:@"%@",arr[index][@"trade_name"]];
                
            };
            
            vc.transitioningDelegate=self;
            vc.modalPresentationStyle=UIModalPresentationCustom;
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"二级分类暂无数据"];
        }
    }

    
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



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //[self getpicture];//获取相册
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.mediaType = QBImagePickerMediaTypeImage;
            imagePickerController.minimumNumberOfSelection = 1;
            if (self.typeimage == 1) {
                imagePickerController.maximumNumberOfSelection = 4-self.imagearr.count;
            }else{
                imagePickerController.maximumNumberOfSelection = 4-self.imagearrone.count;
            }
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.showsNumberOfSelectedAssets = YES;
            [self presentViewController:imagePickerController animated:YES completion:NULL];
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
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        if (self.typeimage == 1) {
            //设置图片
            [self.imagearr insertObject:[UIImage imageWithData:data] atIndex:0];
            [self setupimageview];
        }else{
            //设置图片
            [self.imagearrone insertObject:[UIImage imageWithData:data] atIndex:0];
            [self setupimageviewone];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//提交
- (IBAction)ensure:(id)sender {
    
    if (self.nameTF.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商户姓名"];
        return;
    }
    if (self.addressTF.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商户详细地址"];
        return;
    }
    if (self.phoneNumTF.text.length <= 0) {
        [MBProgressHUD showError:@"请填写联系电话"];
        return;
    }
    if (![predicateModel valiMobile:self.phoneNumTF.text]) {
        [MBProgressHUD showError:@"手机格式不对"];
        return;
    }
    if (self.typeLabel.text.length <= 0 || [self.typeLabel.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"选择一级商户类型"];
        return;
    }
    if (self.typelabelTwo.text.length <= 0 || [self.typelabelTwo.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"选择二级商户类型"];
        return;
    }
    if (self.imagearr.count <= 1) {
        [MBProgressHUD showError:@"请至少上传一张商品图"];
        return;
    }
    if (self.imagearrone.count <= 1) {
        [MBProgressHUD showError:@"请至少上传一张环境图"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"truename"] = self.nameTF.text;
    dict[@"address"] = self.addressTF.text;
    dict[@"phone"] = self.phoneNumTF.text;
    dict[@"trade_id"] = self.industryArr[self.selectOne][@"trade_id"];
    dict[@"two_trade_id"] = self.industryArr[self.selectOne][@"son"][self.selectTwo][@"trade_id"];
    dict[@"sn_code"] = self.SNlabel.text;
    dict[@"app_version"] = APP_VERSION;
    dict[@"version"] = @"3";
    NSArray *titleArr = @[@"goodsone",@"goodstwo",@"goodsthree"];
    NSArray *titleArrone = @[@"evnone",@"evntwo",@"evnthree"];
    
    self.ensureBtn.userInteractionEnabled = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    _dataTask = [manager POST:[NSString stringWithFormat:@"%@Shop/push_store",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        for (int i = 0; i < self.imagearr.count - 1; i++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            NSData *data = UIImagePNGRepresentation(self.imagearr[i]);
            [formData appendPartWithFileData:data name:titleArr[i] fileName:fileName mimeType:@"image/png"];
        }
        for (int i = 0; i < self.imagearrone.count - 1; i++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            NSData *data = UIImagePNGRepresentation(self.imagearrone[i]);
            [formData appendPartWithFileData:data name:titleArrone[i] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//            [SVProgressHUD setCornerRadius:8.0];

        if (uploadProgress.fractionCompleted == 1.0) {
            [SVProgressHUD dismiss];
             self.ensureBtn.userInteractionEnabled = YES;
        }
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
  
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"code"]integerValue]==1) {
            int num = (arc4random() % 1000000);
            self.SNlabel.text = [NSString stringWithFormat:@"%.6d", num];
            self.nameTF.text = @"";
            self.addressTF.text = @"";
            self.phoneNumTF.text = @"";
            self.nameTF.placeholder = @"请输入姓名";
            self.addressTF.placeholder = @"请输入地址";
            self.phoneNumTF.placeholder = @"请输入电话号码";
            self.typeLabel.text = @"请选择";
            self.typelabelTwo.text = @"请选择";
            [self.imagearrone removeAllObjects];
            [self.imagearr removeAllObjects];
            [self.imagearrone addObject:[UIImage imageNamed:@"照片框-拷贝-9"]];
            [self.imagearr addObject:[UIImage imageNamed:@"照片框-拷贝-9"]];
            [self setupimageview];
            [self setupimageviewone];
            [MBProgressHUD showError:dic[@"message"]];
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         self.ensureBtn.userInteractionEnabled = YES;
        [MBProgressHUD showError:error.localizedDescription];
    }];

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.nameTF && [string isEqualToString:@"\n"]) {
        [self.addressTF becomeFirstResponder];
        return NO;
    }else if (textField == self.addressTF && [string isEqualToString:@"\n"]) {
        [self.phoneNumTF becomeFirstResponder];
        return NO;
    }
    
    return YES;
}
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

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 660;

}

- (IBAction)closeKeyBoard:(UITapGestureRecognizer *)sender {
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

-(NSMutableArray*)industryArr{
    if (!_industryArr) {
        _industryArr = [NSMutableArray array];
    }
    return _industryArr;
}

@end
