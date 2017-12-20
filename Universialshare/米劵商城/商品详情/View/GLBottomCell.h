//
//  GLBottomCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *secondImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageH;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageVH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;

@end
