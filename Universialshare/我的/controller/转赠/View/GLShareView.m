//
//  GLShareView.m
//  PovertyAlleviation
//
//  Created by 龚磊 on 2017/3/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLShareView.h"
#import "UIButton+SetEdgeInsets.h"
@interface GLShareView()



@end

@implementation GLShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.weiboShareBtn verticalCenterImageAndTitle:10];
    [self.weixinShareBtn verticalCenterImageAndTitle:10];
    [self.friendShareBtn verticalCenterImageAndTitle:10];
    
}

- (IBAction)share:(id)sender {
    
    
}


@end
