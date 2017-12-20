//
//  LBBillOfLadingHeaderFooterView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBillOfLadingHeaderView.h"
#import "LBBillOfLadingModel.h"

@interface LBBillOfLadingHeaderFooterView : UITableViewHeaderFooterView

@property (strong , nonatomic)LBBillOfLadingHeaderView *headerv;

@property (strong , nonatomic)LBBillOfLadingModel *model;

@property (copy , nonatomic)void(^refreshData)(BOOL iselect,NSString *lineid,NSString *moeny);

@property (copy , nonatomic)void(^refreshShow)(NSString *titile , UIImage *image);

@property (copy , nonatomic)void(^jumpBilldetail)();

@property (copy , nonatomic)void(^detateBill)();

@end
