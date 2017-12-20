//
//  GLSet_MaskVeiw.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLSet_MaskVeiw.h"

@interface GLSet_MaskVeiw()

@end

@implementation GLSet_MaskVeiw

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.yy_width, self.yy_height)];
    self.bgView.alpha = 0.3;
    self.bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bgView];
    
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    [self.bgView addGestureRecognizer:tapGesture];

    
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"maskView_dismiss" object:nil];
  
}


-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, 0, weakSelf.yy_width, 0);
    } completion:^(BOOL finished) {
        weakSelf.alpha = 0;
        
    }];
    
}

// 这里加载在了window上
-(void)showViewWithContentView:(UIView *)contentView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [self addSubview:contentView];
   
    [window addSubview:self];
}
- (void)show {
    
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    
    [window addSubview:self];
}

@end
