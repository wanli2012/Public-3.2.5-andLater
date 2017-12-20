//
//  LBStoreDetailreplaysTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreDetailreplaysTableViewCell.h"

@implementation LBStoreDetailreplaysTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starView.enabled = NO;
    self.starView.type = LCStarRatingViewCountingTypeFloat;
}



@end
