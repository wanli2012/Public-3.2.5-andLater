//
//  LBMySalesmanListDeatilTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMySalesmanListDeatilTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *adresslb;
@property (weak, nonatomic) IBOutlet UILabel *idlb;

@property (weak, nonatomic) IBOutlet UIButton *saleBt;
@property (weak, nonatomic) IBOutlet UIButton *businessBt;
@property (weak, nonatomic) IBOutlet UILabel *allMoney;


@property (assign , nonatomic)NSInteger index;

@property (copy , nonatomic)void(^returnsaleman)(NSInteger index);

@property (copy , nonatomic)void(^returnbusiness)(NSInteger index);

@end
