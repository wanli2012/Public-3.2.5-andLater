//
//  LBStoreSendGoodsTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSendGoodsProductModel.h"
@protocol LBStoreSendGoodsDelegete <NSObject>

-(void)clickSendGoods:(NSIndexPath*)indexpath  name:(NSString*)name;

@end

@interface LBStoreSendGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *codelb;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (strong, nonatomic) NSIndexPath  *indexpath;
@property (assign, nonatomic) id<LBStoreSendGoodsDelegete>  delegete;
@property (strong, nonatomic)LBSendGoodsProductModel *WaitOrdersListModel;
@property (strong, nonatomic)LBSendGoodsProductModel *WaitOrdersListModelone;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *goods_specLb;

@end
