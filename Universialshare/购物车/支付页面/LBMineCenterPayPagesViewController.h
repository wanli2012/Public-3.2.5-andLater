//
//  LBMineCenterPayPagesViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterPayPagesViewController : UIViewController

@property (nonatomic, assign) NSInteger payType; // 支付类型 1普通消费支付  2 米分支付 3:面对面支付 4,顺道商城

@property (nonatomic, copy) NSString *order_id;//订单id

@property (nonatomic, copy) NSString *useableScore;//可用米分

@property (nonatomic, copy) NSString *order_sn;//订单号

@property (nonatomic, copy) NSString *orderPrice;//订单金额

@property (nonatomic, copy) NSString *order_sh; //后台生成的加密字符串

@property (nonatomic, assign)NSInteger pushIndex;//记录从哪个控制器push的 1:米劵商城确认订单  2:我的-订单

@property (nonatomic, copy) NSString *coupose;

@property (nonatomic, copy) NSString *rice;


@end
