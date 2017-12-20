//
//  LBOnlineConsultationViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBOnlineConsultationViewController.h"
#import "LBOnlineConsultationChildsViewController.h"

@interface LBOnlineConsultationViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)IBOutlet UIWebView                      *webView;
@property (strong, nonatomic)LoadWaitView *loadV;
-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@property (assign , nonatomic)NSInteger isload;//是否加过完成
@property(nonatomic,strong)NSString     *urlStr;

@end

@implementation LBOnlineConsultationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.urlStr = @"";
    [self initializeDataSource];
    [self initializeUserInterface];
    self.automaticallyAdjustsScrollViewInsets=NO;

}

-(void)initializeDataSource{
    
}

-(void)initializeUserInterface{
    self.navigationItem.title = @"客服";
    [self.view addSubview:self.webView];
    
}


#pragma mark –webViewDelegate
-(BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType
{
    //网页加载之前会调用此方法
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    if ([request.URL.absoluteString isEqualToString: self.urlStr]) {
        return YES;
    }else{
        self.hidesBottomBarWhenPushed = YES;
        LBOnlineConsultationChildsViewController *vc =[[LBOnlineConsultationChildsViewController alloc]init];
        vc.webUrl = request.URL.absoluteString;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

    return NO;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!_loadV) {
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    }
    //开始加载网页调用此方法
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
    [_loadV removeloadview];
    _isload = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSString  *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"kf_url"];
    
    if (str.length <= 0 || [str rangeOfString:@"null"].location != NSNotFound) {
        return;
    }
    if (_isload != 1 ) {
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    }else{
        if (![self.urlStr isEqualToString:str]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        }
    }

    self.urlStr = str;
    
}

-(void)webView:(UIWebView* )webView didFailLoadWithError:(NSError* )error
{
    //网页加载失败 调用此方法
    [_loadV removeloadview];
    [MBProgressHUD showError:@"加载失败..."];
}





@end
