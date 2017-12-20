//
//  GLLoginIdentityCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLLoginIdentityCell.h"

@interface GLLoginIdentityCell ()



@end

@implementation GLLoginIdentityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//
- (void)setIsSelec:(BOOL)isSelec{
    _isSelec = isSelec;
    
    if (_isSelec) {
        self.imageV.image = [UIImage imageNamed:@"登录选中"];
        
    }else{
        self.imageV.image = [UIImage imageNamed:@"登录未选中"];
    }
}

@end
