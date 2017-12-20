//
//  LBStoreProductDetailAddNumTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreProductDetailAddNumTableViewCell.h"

@implementation LBStoreProductDetailAddNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseview.layer.cornerRadius = 3;
    self.baseview.clipsToBounds = YES;
    
    self.baseview.layer.borderWidth = 1;
    self.baseview.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.numLb.text = @"1";
    
}

- (IBAction)reduceButtonEvent:(UIButton *)sender {
    
    if ([self.numLb.text isEqualToString:@"1"]) {
        return;
    }
    self.numLb.text = [NSString stringWithFormat:@"%ld",[self.numLb.text integerValue] - 1];
    
    if (self.retureNum) {
        self.retureNum([self.numLb.text integerValue]);
    }
}

- (IBAction)addButtonevent:(UIButton *)sender {
    
    self.numLb.text = [NSString stringWithFormat:@"%ld",[self.numLb.text integerValue] + 1];
    
    if (self.retureNum) {
        self.retureNum([self.numLb.text integerValue]);
    }
}

@end
