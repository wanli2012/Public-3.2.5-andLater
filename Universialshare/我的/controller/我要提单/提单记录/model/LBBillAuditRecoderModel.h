//
//  LBBillAuditRecoderModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBBillAuditRecoderModel : NSObject

@property (copy , nonatomic)NSString *line_id;//订单id
@property (copy , nonatomic)NSString *total_money;//订单总额
@property (copy , nonatomic)NSString *total_rl_money;//让利总额
@property (copy , nonatomic)NSString *order_num;//订单号
@property (copy , nonatomic)NSString *fail_reason;//失败；理由  没有为空字符串
@property (copy , nonatomic)NSString *updatetime;//审核时间
@property (copy , nonatomic)NSString *addtime;//提交订单时间
@end
