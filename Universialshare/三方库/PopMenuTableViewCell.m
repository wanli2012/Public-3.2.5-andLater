//
//  PopMenuTableViewCell.m
//  QQPopMenuView
//
//  Created by ec on 2016/11/15.
//  Copyright © 2016年 Code Geass. All rights reserved.
//

#import "PopMenuTableViewCell.h"

@implementation PopMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = YYSRGBColor(102, 139, 255, 1);
    self.titleLabel.textColor = [UIColor whiteColor];
}


@end
