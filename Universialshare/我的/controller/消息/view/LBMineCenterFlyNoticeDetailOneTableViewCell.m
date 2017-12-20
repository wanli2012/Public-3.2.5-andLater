//
//  LBMineCenterFlyNoticeDetailOneTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeDetailOneTableViewCell.h"

@implementation LBMineCenterFlyNoticeDetailOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.image.layer.cornerRadius = 3;
    self.image.clipsToBounds = YES;
}



@end
