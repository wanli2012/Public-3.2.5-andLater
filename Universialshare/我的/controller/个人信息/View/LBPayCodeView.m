//
//  LBPayCodeView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBPayCodeView.h"

@implementation LBPayCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self initInterFace];
    }
    
    return self;
}

-(void)initInterFace{
    
    _imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 64 - self.frame.size.width)/2.0, self.frame.size.width, self.frame.size.width)];
    [self addSubview:_imagev];
    
}

@end
