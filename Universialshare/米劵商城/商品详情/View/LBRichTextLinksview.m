//
//  LBRichTextLinksview.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRichTextLinksview.h"
#import <Masonry/Masonry.h>

@implementation LBRichTextLinksview

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self initerface];
    }
    
    return self;

}

-(void)initerface{
    [self addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        
    }];

}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.backgroundColor =[UIColor whiteColor];
        _webView.userInteractionEnabled = NO;
    }
    return _webView;
}

@end
