//
//  LBBillOfLadingHeaderView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBillOfLadingHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *modellb;
@property (weak, nonatomic) IBOutlet UILabel *moneylb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIButton *select;
@property (weak, nonatomic) IBOutlet UIButton *upImageBt;
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
@property (weak, nonatomic) IBOutlet UILabel *userType;

@end
