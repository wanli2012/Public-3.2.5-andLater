//
//  GLDonationRecordController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationRecordController.h"
#import "GLDonationToOthersRecordController.h"
#import "GLDonationMyPresentRecordController.h"

@interface GLDonationRecordController()

@end

@implementation GLDonationRecordController

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
    
    self.title = @"转赠记录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
}
-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 2, 50);
    
    NSArray *titleArray = @[
                            @"转赠他人",
                            @"我的转赠",
                            
                            ];
    
    NSArray *classNames = @[
                            [GLDonationToOthersRecordController class],
                            [GLDonationMyPresentRecordController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor blackColor];
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

@end
