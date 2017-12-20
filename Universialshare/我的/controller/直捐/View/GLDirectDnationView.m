//
//  GLDirectDnationView.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDirectDnationView.h"

@implementation GLDirectDnationView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.normalBtn setTitle:NormalMoney forState:UIControlStateNormal];
    [self.taxBtn setTitle:SpecialMoney forState:UIControlStateNormal];
}

@end
