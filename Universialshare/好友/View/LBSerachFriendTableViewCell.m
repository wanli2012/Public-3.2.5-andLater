//
//  LBSerachFriendTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/9/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSerachFriendTableViewCell.h"

@implementation LBSerachFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.imagev.layer.cornerRadius = 15;
    self.imagev.clipsToBounds = YES;
}



@end
