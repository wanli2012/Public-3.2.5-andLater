//
//  LBNybusinessListTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBNybusinessListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *name1Lb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;

@property (weak, nonatomic) IBOutlet UIButton *GoBt;

@property (assign, nonatomic)NSInteger index;

@property (copy , nonatomic)void(^returnGowhere)(NSInteger index);
@property (weak, nonatomic) IBOutlet UILabel *moenyLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@end
