//
//  GLSetup_VersionInfoController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLSetup_VersionInfoController.h"
#import "GLShareView.h"
#import "UMSocial.h"
#import <Social/Social.h>

@interface GLSetup_VersionInfoController ()<UIAlertViewDelegate>
{
    GLShareView *_shareV;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (strong, nonatomic)  NSString *app_Version;

@end

@implementation GLSetup_VersionInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.noticeLabel.text = @"扫描二维码你的朋友也可以下载大众共享客户端";
    
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 30)];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 5, 0)];
    self.imageWidth.constant = 150 * autoSizeScaleX;
    [self logoQrCode];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    _app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本: v%@",_app_Version];
    
     [self Postpath:GET_VERSION];
    
    
}

-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
    
}

-(void)receiveData:(id)sender
{
    NSString  *Newversion = [NSString stringWithFormat:@"%@",sender[@"version"]];
    
    if (![_app_Version isEqualToString:Newversion]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                            message:@"发现新版本,是否更新 ?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"立即更新", nil];
        
        [alertView show];
    }
    
}

#pragma mark ----- uialertviewdelegete
//下载
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGFloat shareVH = SCREEN_HEIGHT /5;
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareVH);
        
    }completion:^(BOOL finished) {
        [_shareV removeFromSuperview];
        _shareV = nil;
    }];
}
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (IBAction)share:(id)sender {
    
    CGFloat shareVH = SCREEN_HEIGHT /5;
    
    if (_shareV == nil) {
        
        _shareV = [[NSBundle mainBundle] loadNibNamed:@"GLShareView" owner:nil options:nil].lastObject;
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
        [_shareV.weiboShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.weixinShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.friendShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shareV];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT - shareVH, SCREEN_WIDTH, shareVH);
    }];

}
- (void)shareClick:(UIButton *)sender {
    
    if (sender == _shareV.weiboShareBtn) {
        [self shareTo:@[UMShareToSina]];
    }else if (sender == _shareV.weixinShareBtn){
        [self shareTo:@[UMShareToWechatSession]];
    }else if (sender == _shareV.friendShareBtn){
        [self shareTo:@[UMShareToWechatTimeline]];
    }
    
}
- (void)shareTo:(NSArray *)type{
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = DOWNLOAD_URL;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = DOWNLOAD_URL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = DOWNLOAD_URL;
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"大众共享，让每一个有心参与公益事业的人都能参与进来(用safari浏览器打开)%@",DOWNLOAD_URL] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}

//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSString *contentStr = DOWNLOAD_URL;
    //    NSString *contentStr = @"";
    NSData *qrImageData = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    
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
    UIImage *sImage = [UIImage imageNamed:@"mine_logo"];
    
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
    self.codeImageV.image = finalyImage;
}
@end
