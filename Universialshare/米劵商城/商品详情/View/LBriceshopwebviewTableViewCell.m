//
//  LBriceshopwebviewTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBriceshopwebviewTableViewCell.h"

@implementation LBriceshopwebviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.webview.delegate = self;
}

-(void)setUrlstr:(NSString *)urlstr{
    _urlstr = urlstr;
    if (_urlstr.length > 0 && [_urlstr rangeOfString:@"null"].location == NSNotFound) {
         [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
        self.isload = YES;
    }

}

#pragma mark ----- uiwebviewdelegete
-(void)webViewDidFinishLoad:(UIWebView *)webView{

     self.webH=[webView.scrollView contentSize].height;
    [self.delegate refreshWebHeigt:self.webH];
    
}


@end
