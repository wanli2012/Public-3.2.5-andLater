//
//  LBStoreDetailAdressTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreDetailAdressTableViewCell.h"

@implementation LBStoreDetailAdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Bobt.layer.cornerRadius = 4;
    self.Bobt.clipsToBounds = YES;

}
//打电话
- (IBAction)phonebuttonEvent:(UIButton *)sender {
    
    [self.delegete takePhne];
}
//去这里
- (IBAction)gowhereButtonEvent:(UIButton *)sender {
    
    [self.delegete gotheremap];
    
}
- (IBAction)ContactMerchant:(UIButton *)sender {
    [self.delegete contactMerchant];
}

@end
