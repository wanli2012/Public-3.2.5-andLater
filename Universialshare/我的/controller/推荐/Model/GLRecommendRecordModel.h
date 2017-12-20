//
//  GLRecommendRecordModel.h
//  PovertyAlleviation
//
//  Created by 龚磊 on 2017/3/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLRecommendRecordModel : NSObject

@property (nonatomic,copy)NSString *uid;//推荐人ID

@property (nonatomic,copy)NSString *group_id;//被推荐人group_id

@property (nonatomic,copy)NSString *username;////被推荐人用户名

@property (nonatomic,copy)NSString *regtime;//推荐时间

@property (nonatomic,copy)NSString *total_money; //总消费

@property (nonatomic,copy)NSString *zyf_money; //总奖励

@property (nonatomic,copy)NSString *phone;//电话

@property (nonatomic,copy)NSString *pic;//电话

@end
