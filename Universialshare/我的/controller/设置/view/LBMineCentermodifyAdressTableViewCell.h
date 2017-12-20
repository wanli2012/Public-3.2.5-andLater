//
//  LBMineCentermodifyAdressTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LBMineCentermodifyAdressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLn;

@property (weak, nonatomic) IBOutlet UIButton *setupBt;

@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
@property (weak, nonatomic) IBOutlet UIButton *editbt;

@property (assign, nonatomic)NSInteger index;

@property (strong, nonatomic)NSString *address_id;

//@property (strong, nonatomic) RACSubject *subject;

@property (nonatomic, copy)void(^returnSetUpbt)(NSInteger index);
@property (nonatomic, copy)void(^returnEditbt)(NSInteger index);
@property (nonatomic, copy)void(^returnDeletebt)(NSInteger index);

@end
