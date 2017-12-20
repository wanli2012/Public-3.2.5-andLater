//
//  LBOnlineConsultationChildsViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBOnlineConsultationChildsViewController.h"

@interface LBOnlineConsultationChildsViewController ()<UIWebViewDelegate>
/**详情页*/
@property(nonatomic,strong)UIWebView                      *webView;
@property (strong, nonatomic)LoadWaitView *loadV;
-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation LBOnlineConsultationChildsViewController

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
    self.navigationItem.title = @"客服";
    [self.view addSubview:self.webView];
    
   [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    
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
    
    if ([request.URL.absoluteString isEqualToString: self.webUrl]) {
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
