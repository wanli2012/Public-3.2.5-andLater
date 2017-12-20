//
//  LBMineMessageHotPickTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBMineCenterHotPickModelF;

@interface LBMineMessageHotPickTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timelb;

@property (weak, nonatomic) IBOutlet UIView *baseview;

@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UIView *lineview;

@property (weak, nonatomic)LBMineCenterHotPickModelF *MineCenterHotPickModelF;

@end
