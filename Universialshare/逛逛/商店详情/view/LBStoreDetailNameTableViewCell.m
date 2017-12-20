//
//  LBStoreDetailNameTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreDetailNameTableViewCell.h"

@implementation LBStoreDetailNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buyBt.layer.cornerRadius = 4;
    self.buyBt.clipsToBounds = YES;
    self.starView.enabled = NO;
    self.starView.type = LCStarRatingViewCountingTypeFloat;
}
//我要购买
- (IBAction)buyEvent:(UIButton *)sender {
    
    [self.delegete payTheBill];
}


@end
