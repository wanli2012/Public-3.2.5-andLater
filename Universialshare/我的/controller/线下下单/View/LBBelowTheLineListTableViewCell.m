//
//  LBBelowTheLineListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBelowTheLineListTableViewCell.h"

@implementation LBBelowTheLineListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseView.layer.cornerRadius = 4;
    self.baseView.clipsToBounds = YES;
}

@end
