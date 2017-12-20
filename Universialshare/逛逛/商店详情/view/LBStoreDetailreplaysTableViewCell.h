//
//  LBStoreDetailreplaysTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"

@interface LBStoreDetailreplaysTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *replyLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constaritH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraitTop;

@end
