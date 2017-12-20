//
//  GLNoticeView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/6/2.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHomePageNoticeView.h"

@implementation GLHomePageNoticeView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}

@end
