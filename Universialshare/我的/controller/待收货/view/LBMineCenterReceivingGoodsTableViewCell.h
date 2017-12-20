//
//  LBMineCenterReceivingGoodsTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBWaitOrdersListModel.h"
#import "DWBubbleMenuButton.h"

@protocol  LBMineCenterReceivingGoodsDelegete <NSObject>

-(void)checklogistics:(NSIndexPath*)index;
-(void)BuyAgaingoodid:(NSString*)goog_id orderid:(NSString*)orderid indexpath:(NSIndexPath*)indexpath;

@end

@interface LBMineCenterReceivingGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *cartype;

@property (weak, nonatomic) IBOutlet UILabel *numlb;

@property (weak, nonatomic) IBOutlet UILabel *pricelb;

@property (weak, nonatomic) IBOutlet UILabel *storename;

@property (weak, nonatomic) IBOutlet UIButton *sureSend;
//@property (weak, nonatomic) IBOutlet UIButton *SeeBt;

@property (strong, nonatomic)  NSIndexPath *indexpath;

@property (assign,nonatomic)id<LBMineCenterReceivingGoodsDelegete> delegete;

@property(strong,nonatomic)NSString *order_id;

@property (strong, nonatomic)LBWaitOrdersListModel *WaitOrdersListModel;

@property(nonatomic , strong)DWBubbleMenuButton *downMenuButton;

@end
