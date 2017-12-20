//
//  LBAnnouncementViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBAnnouncementViewController.h"
#import "LBViewProtocolViewController.h"

@interface LBAnnouncementViewController ()<UIWebViewDelegate>
/**详情页*/
@property(nonatomic,strong)UIWebView                      *webView;
@property (strong, nonatomic)LoadWaitView *loadV;
-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

#define ANNOUNURL @"https://www.51dztg.com/index.php/Home/Share/hisNews"

@implementation LBAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"公告";
}

-(void)initializeDataSource{
    
}

-(void)initializeUserInterface{

    [self.view addSubview:self.webView];
    
   
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ANNOUNURL]]];
    
}

#pragma mark - ******* Getters *******

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.backgroundColor =[UIColor whiteColor];
        _webView.delegate=self;
        _webView.scrollView.contentSize = CGSizeMake(0, _webView.scrollView.contentSize.height);
    }
    return _webView;
}

#pragma mark –webViewDelegate
-(BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType
{
    //网页加载之前会调用此方法
    //_loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    
     NSString *url1=request.URL.absoluteString;
    if (![url1 isEqualToString:ANNOUNURL]) {
        self.hidesBottomBarWhenPushed = YES;
        LBViewProtocolViewController *vc =[[LBViewProtocolViewController alloc]init];
        vc.webUrl = url1;
        vc.navTitle = @"详情";
        vc.loadLocalBool = NO;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
       return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载网页调用此方法
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
    [_loadV removeloadview];
}



-(void)webView:(UIWebView* )webView didFailLoadWithError:(NSError* )error
{
    //网页加载失败 调用此方法
    [_loadV removeloadview];
    [MBProgressHUD showError:@"加载失败..."];
}


@end
