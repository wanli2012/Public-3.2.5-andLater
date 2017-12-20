//
//  LBStoreProductDetailInfoTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBStoreProductDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *storelb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *infolb;
@property (weak, nonatomic) IBOutlet UILabel *yuanjiLb;
@property (weak, nonatomic) IBOutlet UILabel *rebateTypeLb;
@property (weak, nonatomic) IBOutlet UIImageView *circleimage1;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage2;
@property (weak, nonatomic) IBOutlet UILabel *ricelb;

@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UILabel *catalbel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstrait;

@end
