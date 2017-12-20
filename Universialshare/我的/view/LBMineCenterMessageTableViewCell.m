//
//  LBMineCenterMessageTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMessageTableViewCell.h"

@implementation LBMineCenterMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.image.layer.cornerRadius = 4;
    self.image.clipsToBounds = YES;
}


@end
