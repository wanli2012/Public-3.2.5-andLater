//
//  GLMine_AdController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_AdController.h"

@interface GLMine_AdController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSString *str;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tapconstrait;

@end

@implementation GLMine_AdController

- (void)viewDidLoad {
    [super viewDidLoad];

    _str = @"";
    self.navigationItem.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL *url = [NSURL URLWithString:self.url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [self.webView loadRequest:request];//加载
    
}

#pragma mark –webViewDelegate
-(BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType
{
    //网页加载之前会调用此方法
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    _str =request.URL.absoluteString;

    if ([_str rangeOfString:@"Union/blank.html"].location != NSNotFound || [_str rangeOfString:@"union/blank.html"].location != NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
     if ([_str rangeOfString:@"Union/blank.html"].location != NSNotFound || [_str rangeOfString:@"union/blank.html"].location != NSNotFound) {
        if (!_loadV) {
            _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        }
        //开始加载网页调用此方法
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
    [_loadV removeloadview];

}

-(void)webView:(UIWebView* )webView didFailLoadWithError:(NSError* )error
{
    
    if ([_str rangeOfString:@"Union/blank.html"].location != NSNotFound || [_str rangeOfString:@"union/blank.html"].location != NSNotFound) {
        //网页加载失败 调用此方法
        [_loadV removeloadview];
        [MBProgressHUD showError:@"加载失败..."];
        
        if ([_str isEqualToString:self.url]) {
            self.tapconstrait.constant = 64;
            self.navigationController.navigationBar.hidden = NO;
        }
    }

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([_url rangeOfString:@"Union/index.html"].location !=NSNotFound || [_url rangeOfString:@"Union/index.html"].location != NSNotFound)//_roaldSearchText
    {
        self.tapconstrait.constant = 0;
         self.navigationController.navigationBar.hidden = YES;
    }
    else
    {
        self.tapconstrait.constant = 64;
        self.navigationController.navigationBar.hidden = NO;

    }

}


@end
