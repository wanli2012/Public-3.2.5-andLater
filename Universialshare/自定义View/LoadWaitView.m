//
//  LoadWaitView.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LoadWaitView.h"
#import "ShapeLoadingView.h"

@interface LoadWaitView  ()
{
    
    UIView *_loadingView;
    ShapeLoadingView *_shapeView;
    
}

@end

@implementation LoadWaitView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadWaitView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        self.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestrue)];
        [self addGestureRecognizer:tap];
        
        [self initinterface];
        
        self.isTap = NO;
        
    }
    return self;

}

+(LoadWaitView*)addloadview:(CGRect)rect tagert:(id)tagert{
    
    LoadWaitView *loadview=[[LoadWaitView alloc] initWithFrame:rect];
    [tagert addSubview:loadview];
    
    return loadview;

}

-(void)removeloadview{

    [self removeFromSuperview];
    _loadingView.alpha=0;
    [_shapeView stopAnimating];


}

-(void)initinterface{
 
    _loadingView=[[UIView alloc] init];
    _loadingView.frame=CGRectMake(SCREEN_WIDTH/2-100/2, SCREEN_HEIGHT/2-120/2, 100, 120);
    _loadingView.backgroundColor=[UIColor clearColor];
    [self addSubview:_loadingView];
    
    _shapeView=[[ShapeLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 120) title:@"加载中..."];
    _shapeView.backgroundColor=[UIColor clearColor];
    [_loadingView addSubview:_shapeView];
    
    _loadingView.alpha=1;
    [_shapeView startAnimating];

    
}

-(void)tapgestrue{

    if (self.isTap == NO) {
        [self removeFromSuperview];
    }else{
        return;
    }
}



@end
