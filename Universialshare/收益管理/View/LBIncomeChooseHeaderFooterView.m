//
//  LBIncomeChooseHeaderFooterView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//
#import "LBIncomeChooseHeaderFooterView.h"
#import <Masonry/Masonry.h>

@interface LBIncomeChooseHeaderFooterView ()

@property (strong , nonatomic)UIButton *currenbt;
@property (strong , nonatomic)UIImageView *imageannimation;

@end
@implementation LBIncomeChooseHeaderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initerface];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)initerface{
    
    self.currenbt = self.onLineBt;
    [self addSubview:self.lineview];
    [self addSubview:self.onLineBt];
    [self addSubview:self.underLineBt];
    [self insertSubview:self.imageannimation belowSubview:self.currenbt];

    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
    
    [self.onLineBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self).offset((SCREEN_WIDTH - 100*2)/4);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
    }];
    
    
    [self.underLineBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(-(SCREEN_WIDTH - 100*2)/4);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
    }];
    
    
    [self.imageannimation mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self).offset((SCREEN_WIDTH - 100*2)/4);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
    }];
}

-(void)onlineBtbtton{

    if (self.currenbt == self.onLineBt) {
        return;
    }
    self.currenbt.backgroundColor = [UIColor lightGrayColor];
    self.currenbt = self.onLineBt;
    [self addannimation];

}

-(void)underlineBtbtton{
    if (self.currenbt == self.underLineBt) {
        return;
    }
    self.currenbt.backgroundColor = [UIColor lightGrayColor];
    self.currenbt = self.underLineBt;
    
    [self addannimation];

}


-(void)addannimation{

    //缩小
    CABasicAnimation *scaoleAnimation  = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaoleAnimation.duration = 0.2;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaoleAnimation.toValue = [NSNumber numberWithFloat:0.2];
    
    //移动位置
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.imageannimation.layer.position];
    CGPoint toPoint = self.imageannimation.layer.position;
    toPoint.x = self.currenbt.frame.origin.x+self.imageannimation.frame.size.width/2;
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.4;
    group.animations = [NSArray arrayWithObjects:animation,scaoleAnimation, nil];
    group.repeatCount = 1;
    group.delegate = self;
    /* 动画的开始与结束的快慢*/
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.imageannimation.layer addAnimation:group forKey:@"move"];

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
 
    self.imageannimation.frame = CGRectMake(self.currenbt.frame.origin.x, self.imageannimation.frame.origin.y, self.imageannimation.frame.size.width, self.imageannimation.frame.size.height);
    
    self.currenbt.backgroundColor = TABBARTITLE_COLOR;
    
    [self.imageannimation.layer removeAnimationForKey:@"move"];
    
    if (self.currenbt == self.onLineBt) {
        [self.delegete clickonlinebutton];
    }else if (self.currenbt == self.underLineBt){
        [self.delegete clickunderlinebutton];
    }

}

-(UIView*)lineview{
    
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _lineview;
    
}

-(UIButton*)onLineBt{
    
    if (!_onLineBt) {
        _onLineBt=[[UIButton alloc]init];
        _onLineBt.backgroundColor=TABBARTITLE_COLOR;
        [_onLineBt setTitle:@"待发货" forState:UIControlStateNormal];
        _onLineBt.titleLabel.font=[UIFont systemFontOfSize:14];
        [_onLineBt addTarget:self action:@selector(onlineBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_onLineBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _onLineBt.layer.cornerRadius =15;
        _onLineBt.clipsToBounds =YES;
    }
    
    return _onLineBt;
    
}

-(UIButton*)underLineBt{
    
    if (!_underLineBt) {
        _underLineBt=[[UIButton alloc]init];
        _underLineBt.backgroundColor=[UIColor lightGrayColor];
        [_underLineBt setTitle:@"已发货" forState:UIControlStateNormal];
        _underLineBt.titleLabel.font=[UIFont systemFontOfSize:14];
        [_underLineBt addTarget:self action:@selector(underlineBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_underLineBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _underLineBt.layer.cornerRadius =15;
        _underLineBt.clipsToBounds =YES;
    }
    
    return _underLineBt;
    
}

-(UIImageView*)imageannimation{
    if (!_imageannimation) {
        _imageannimation = [[UIImageView alloc]init];
        _imageannimation.backgroundColor = TABBARTITLE_COLOR;
        _imageannimation.layer.cornerRadius =15;
        _imageannimation.clipsToBounds =YES;
    }

    return _imageannimation;
}

@end
