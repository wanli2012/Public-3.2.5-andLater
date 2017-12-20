//
//  LBSendRedpaketModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSendRedpaketModel : NSObject
//'num'           红包金额
//'cname'         获赠人名字
//'truename'      真实名字
//'sxf'           手续费
//'time'          发红包时间
@property (copy , nonatomic)NSString *num;
@property (copy , nonatomic)NSString *cname;
@property (copy , nonatomic)NSString *truename;
@property (copy , nonatomic)NSString *sxf;
@property (copy , nonatomic)NSString *time;

@end
