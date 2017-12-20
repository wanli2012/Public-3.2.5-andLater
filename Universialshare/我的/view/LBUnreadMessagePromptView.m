//
//  LBUnreadMessagePromptView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBUnreadMessagePromptView.h"

@interface LBUnreadMessagePromptView ()

@property(nonatomic , strong) UILabel *namelebel;//提示消息

@end

@implementation LBUnreadMessagePromptView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];
        
        self.backgroundColor=[UIColor redColor];
    }
    return self;
    
}

-(void)loadUI{

    [self addSubview:self.namelebel];

}

-(UILabel*)namelebel{
    
    if (!_namelebel) {
        _namelebel=[[UILabel alloc]initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, self.frame.size.height - 22)];
        _namelebel.backgroundColor=[UIColor clearColor];
        _namelebel.textColor=[UIColor whiteColor];
        _namelebel.font=[UIFont systemFontOfSize:14];
        _namelebel.textAlignment=NSTextAlignmentCenter;
      _namelebel.text = @"您有新消息啦!!! 快去消息列表查看";
    }
    return _namelebel;
    
}

@end
