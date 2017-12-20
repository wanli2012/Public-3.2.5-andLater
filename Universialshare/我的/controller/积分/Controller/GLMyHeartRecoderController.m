//
//  GLMyHeartRecoderController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyHeartRecoderController.h"
#import "GLMyHeartOnLineRecoderController.h"
#import "GLMyHeartUnderLineRecoderController.h"

@interface GLMyHeartRecoderController ()

@end

@implementation GLMyHeartRecoderController

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:50])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"米分记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
}
-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 2, 50);
    
    NSArray *titleArray = @[
                            @"线上",
                            @"线下",
                            
                            ];
    
    NSArray *classNames = @[
                            [GLMyHeartOnLineRecoderController class],
                            [GLMyHeartUnderLineRecoderController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor blackColor];
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
