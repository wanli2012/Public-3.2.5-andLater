//
//  GLMine_headimageCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_headimageCell.h"

@implementation GLMine_headimageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.haedimage.layer.cornerRadius = 25;
    self.haedimage.clipsToBounds = YES;
}


@end
