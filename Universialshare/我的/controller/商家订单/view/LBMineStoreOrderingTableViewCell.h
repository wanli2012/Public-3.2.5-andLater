//
//  LBMineStoreOrderingTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineStoreOrderingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *productname;
@property (weak, nonatomic) IBOutlet UILabel *productDescreb;
@property (weak, nonatomic) IBOutlet UILabel *moneylb;
@property (weak, nonatomic) IBOutlet UILabel *numlb;

@property (weak, nonatomic) IBOutlet UILabel *paylb;
@property (weak, nonatomic) IBOutlet UIButton *checkbutton;

@property (assign , nonatomic)NSInteger index;
@property (copy , nonatomic)void(^returncheckbutton)(NSInteger index);

@end
