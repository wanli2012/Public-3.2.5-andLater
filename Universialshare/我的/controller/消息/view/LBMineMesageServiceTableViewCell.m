//
//  LBMineMesageServiceTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineMesageServiceTableViewCell.h"

@implementation LBMineMesageServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.smallImage.layer.cornerRadius = 3;
    self.smallImage.clipsToBounds = YES;

}



@end
