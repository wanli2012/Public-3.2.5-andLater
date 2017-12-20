//
//  LBMineCenterRegionQueryTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterRegionQueryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *agenceView;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UILabel *adreesLb;
@property (weak, nonatomic) IBOutlet UILabel *agenceLb;

@property (weak, nonatomic) IBOutlet UILabel *serviceNumLb;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *industryNumLb;
@property (weak, nonatomic) IBOutlet UILabel *industryMoneyLb;


@property (weak, nonatomic) IBOutlet UIImageView *industryImage;
@property (weak, nonatomic) IBOutlet UILabel *industryAgenclb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstrait;


@end
