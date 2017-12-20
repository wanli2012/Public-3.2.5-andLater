//
//  GLRecommendController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendController.h"
#import "GLRecommendRecordController.h"
#import "GLShareView.h"
#import "UMSocial.h"
#import <Social/Social.h>
#import "GLSet_MaskVeiw.h"

@interface GLRecommendController ()
{
    GLShareView *_shareV;
    GLSet_MaskVeiw *_maskV;
}
@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *versionLb;
@property (weak, nonatomic) IBOutlet UILabel *NewVersionLb;
@property (strong, nonatomic) NSString *recommendUrl;

@end

@implementation GLRecommendController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.title = @"推荐";

    self.contentV.layer.cornerRadius = 5.f;
    self.contentV.clipsToBounds = YES;
    
    self.recommendUrl = [NSString stringWithFormat:@"%@%@",RECOMMEND_REGISTER_URL,[UserModel defaultUser].name];
    //自定义导航栏右键
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 14, 60, 30);
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightBtn setTitle:@"推荐记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addTarget:self  action:@selector(recommendRecord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self logoQrCode];
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
    [self.codeImageV addGestureRecognizer:ges];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLb.text = [NSString stringWithFormat:@"当前版本: v%@",app_Version];
    
     [self Postpath:GET_VERSION];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.NewVersionLb.text = [NSString stringWithFormat:@"最新版本: v%@",sender[@"version"]];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    CGFloat shareVH = SCREEN_HEIGHT /5;
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareVH);
//        
//    }completion:^(BOOL finished) {
//        [_shareV removeFromSuperview];
//        _shareV = nil;
//    }];
//}
//分享页面消失
- (void)dismiss{
    CGFloat shareVH = SCREEN_HEIGHT /5;
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareVH);
        
    } completion:^(BOOL finished) {
        
        [_maskV removeFromSuperview];
    }];
}
//分享到社交圈
- (void)share:(UILongPressGestureRecognizer*)longesture{
    
    if (longesture.state == UIGestureRecognizerStateBegan) {
        
        CGFloat shareVH = SCREEN_HEIGHT /5;
        
        if (_maskV == nil) {
            
            _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            _maskV.bgView.alpha = 0.4;
            
            _shareV = [[NSBundle mainBundle] loadNibNamed:@"GLShareView" owner:nil options:nil].lastObject;
            _shareV.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
            [_shareV.weiboShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
            [_shareV.weixinShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
            [_shareV.friendShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
            //        [self.view addSubview:_maskV];
        }
        [_maskV showViewWithContentView:_shareV];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _shareV.frame = CGRectMake(0, SCREEN_HEIGHT - shareVH, SCREEN_WIDTH, shareVH);
        }];
        
    }
}

- (void)shareClick:(UIButton *)sender {
    [self dismiss];
    if (sender == _shareV.weiboShareBtn) {
        [self shareTo:@[UMShareToSina]];
    }else if (sender == _shareV.weixinShareBtn){
        [self shareTo:@[UMShareToWechatSession]];
    }else if (sender == _shareV.friendShareBtn){
        [self shareTo:@[UMShareToWechatTimeline]];
    }
    
}

- (void)shareTo:(NSArray *)type{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",self.recommendUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众团购";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",self.recommendUrl];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众团购";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@",self.recommendUrl];
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"大众团购，团购欢乐齐分享!(用safari浏览器打开)%@",[NSString stringWithFormat:@"%@",self.recommendUrl]] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
          
        }
    }];
}
//跳转到推荐记录
- (void)recommendRecord {
    self.hidesBottomBarWhenPushed = YES;
    GLRecommendRecordController *recordVC = [[GLRecommendRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

//设置导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

}
//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSString *contentStr = [NSString stringWithFormat:@"%@",self.recommendUrl];
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
