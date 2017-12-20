//
//  LBMineCenterRegionQueryTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterRegionQueryTableViewCell.h"

@implementation LBMineCenterRegionQueryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.agenceView.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4.0f, 4.0f)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.agenceView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.agenceView.layer.mask = maskLayer;
    
}



@end
