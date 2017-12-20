//
//  LBStoreDetailNameTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"

@protocol LBStoreDetailNameDelegete <NSObject>
-(void)payTheBill;
@end
@interface LBStoreDetailNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buyBt;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLb;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;
@property (assign, nonatomic)id<LBStoreDetailNameDelegete> delegete;

@end
