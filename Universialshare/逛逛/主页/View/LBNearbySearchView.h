//
//  LBNearbySearchView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"

@interface LBNearbySearchView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *adresslb;
@property (weak, nonatomic) IBOutlet UILabel *limitlb;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;

@end
