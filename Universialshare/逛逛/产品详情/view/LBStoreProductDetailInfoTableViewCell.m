//
//  LBStoreProductDetailInfoTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreProductDetailInfoTableViewCell.h"

@implementation LBStoreProductDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.circleImage.layer.cornerRadius = 3;
    self.circleImage.clipsToBounds = YES;
    
    self.circleimage1.layer.cornerRadius = 3;
    self.circleimage1.clipsToBounds = YES;
}

@end
