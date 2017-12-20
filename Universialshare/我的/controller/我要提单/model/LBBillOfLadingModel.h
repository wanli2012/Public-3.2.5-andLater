//
//  LBBillOfLadingModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/8.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBBillOfLadingModel : NSObject

@property (copy , nonatomic)NSString *addtime;
@property (copy , nonatomic)NSString *dkpz_pic;
@property (copy , nonatomic)NSString *goods_name;
@property (copy , nonatomic)NSString *goods_total;
@property (copy , nonatomic)NSString *line_id;
@property (copy , nonatomic)NSString *line_money;
@property (copy , nonatomic)NSString *order_num;
@property (copy , nonatomic)NSString *phone;
@property (copy , nonatomic)NSString *rl_money;
@property (copy , nonatomic)NSString *rlmodel_type;
@property (copy , nonatomic)NSString *truename;
@property (copy , nonatomic)NSString *user_name;
@property (copy , nonatomic)NSString *xfpz_pic;
@property (copy , nonatomic)NSString *yh_uid;
@property (copy , nonatomic)NSString *fail_reason;
@property (copy , nonatomic)NSString *group_id;
@property (copy , nonatomic)UIImage *imagev;
@property (assign , nonatomic)BOOL isImage;//是否有图片

@property (assign , nonatomic)BOOL isSelect;


@end
