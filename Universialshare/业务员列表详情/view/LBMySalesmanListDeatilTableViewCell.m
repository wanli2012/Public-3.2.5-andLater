//
//  LBMySalesmanListDeatilTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListDeatilTableViewCell.h"

@implementation LBMySalesmanListDeatilTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    self.imagev.layer.cornerRadius = 40;
    self.imagev.clipsToBounds = YES;
    
    self.saleBt.layer.cornerRadius = 3;
    self.saleBt.clipsToBounds = YES;
    
    self.businessBt.layer.cornerRadius = 3;
    self.businessBt.clipsToBounds = YES;
}

- (IBAction)businessevent:(UIButton *)sender {
    
    if (self.returnbusiness) {
        self.returnbusiness(self.index);
    }
    
}
- (IBAction)selamanevent:(UIButton *)sender {
    
    if (self.returnsaleman) {
        self.returnsaleman(self.index);
    }
    
}

@end
