//
//  LBMineCenterHeaderView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *riceqLb;
@property (weak, nonatomic) IBOutlet UILabel *ricezLb;
@property (weak, nonatomic) IBOutlet UILabel *ricefLb;
@property (weak, nonatomic) IBOutlet UILabel *riceAlb;
@property (weak, nonatomic) IBOutlet UIButton *moreBt;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *usernameLb;

@end
