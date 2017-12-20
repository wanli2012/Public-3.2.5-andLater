//
//  LBNybusinessListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBNybusinessListTableViewCell.h"

@implementation LBNybusinessListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.GoBt.layer.cornerRadius = 3;
    self.GoBt.clipsToBounds = YES;
    
    self.imagev.layer.cornerRadius = 3;
    self.imagev.clipsToBounds = YES;
    
    self.GoBt.layer.borderWidth = 1;
    self.GoBt.layer.borderColor = YYSRGBColor(55, 159, 72, 1).CGColor;
    
    
    
}

- (IBAction)GoPayEvent:(UIButton *)sender {
    
    if (self.returnGowhere) {
        self.returnGowhere(self.index);
    }
}

@end
