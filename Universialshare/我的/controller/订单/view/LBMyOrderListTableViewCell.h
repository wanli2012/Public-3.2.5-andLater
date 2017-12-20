//
//  LBMyOrderListTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMyOrdersListModel.h"
#import "LBMyorderRebateModel.h"

@protocol LBMyOrderListTableViewdelegete <NSObject>

-(void)clickTapgesture;

@end

@interface LBMyOrderListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *baseview1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseView1H;


@property (weak, nonatomic) IBOutlet UILabel *stauesLb;

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *payBt;
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
@property (assign, nonatomic)NSInteger index;
@property (strong, nonatomic)NSIndexPath *indexpath;
@property (copy, nonatomic)void(^retunpaybutton)(NSInteger index);
@property (copy, nonatomic)void(^retundeletebutton)(NSIndexPath *index);

@property (assign, nonatomic)id<LBMyOrderListTableViewdelegete> delegete;
@property (strong, nonatomic)LBMyOrdersListModel *myorderlistModel;
@property (strong, nonatomic)LBMyorderRebateModel *myorderRebateModel;

@end
