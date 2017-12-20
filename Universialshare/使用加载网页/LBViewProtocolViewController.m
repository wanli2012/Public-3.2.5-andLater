//
//  LBViewProtocolViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBViewProtocolViewController.h"

@interface LBViewProtocolViewController ()<UIWebViewDelegate>
/**详情页*/
@property(nonatomic,strong)UIWebView                      *webView;
@property (strong, nonatomic)LoadWaitView *loadV;
-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation LBViewProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.hidden = NO;
}

-(void)initializeDataSource{
    
}

-(void)initializeUserInterface{
    self.navigationItem.title = self.navTitle;
    [self.view addSubview:self.webView];
    
    if (self.loadLocalBool == YES) {//加载本地
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:self.webUrl baseURL:baseURL];
    }else{
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    }
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
