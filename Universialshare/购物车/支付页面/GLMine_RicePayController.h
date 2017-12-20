//
//  GLMine_RicePayController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/8/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_RicePayController : UIViewController

@property (nonatomic, copy) NSString *order_id;//订单id

@property (nonatomic, copy) NSString *useableScore;//可用米分

@property (nonatomic, copy) NSString *order_sn;//订单号

@property (nonatomic, copy) NSString *orderPrice;//订单金额

@property (nonatomic, copy) NSString *order_sh; //后台生成的加密字符串

@property (nonatomic, copy) NSString *coupose;

@property (nonatomic, copy) NSString *rice;

@property (nonatomic, copy) NSString *order_type;

@end
