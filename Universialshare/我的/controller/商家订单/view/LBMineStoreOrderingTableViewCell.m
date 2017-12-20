//
//  LBMineStoreOrderingTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineStoreOrderingTableViewCell.h"

@implementation LBMineStoreOrderingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.checkbutton.layer.borderWidth = 1;
    self.checkbutton.layer.borderColor = YYSRGBColor(181, 180, 180, 1).CGColor;
    
    self.checkbutton.layer.cornerRadius =3;
    self.checkbutton.clipsToBounds=YES;
}

- (IBAction)chechbutton:(UIButton *)sender {
    
    if (self.returncheckbutton) {
        self.returncheckbutton(self.index);
    }
    
}


@end
