//
//  GLIncomeManagerModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIncomeManagerModel : NSObject

@property (nonatomic, copy)NSString *rl_type;//让利类型

@property (nonatomic, copy)NSString *rl_money;//让利金额

@property (nonatomic, copy)NSString *goods_name;//商品名字

@property (nonatomic, copy)NSString *goods_num;// 商品数量

@property (nonatomic, copy)NSString *total_money;//总额

@property (nonatomic, copy)NSString *thumb;//商品图片

@property (nonatomic, copy)NSString *addtime;//添加时间

@property (nonatomic, copy)NSString *typer;

@end

@interface GLIncomeBusinessModel : NSObject

@property (nonatomic, copy)NSString *four;

@property (nonatomic, copy)NSString *group_name;

@property (nonatomic, copy)NSString *one;

@property (nonatomic, copy)NSString *pic;

@property (nonatomic, copy)NSString *regtime;

@property (nonatomic, copy)NSString *three;

@property (nonatomic, copy)NSString *total;

@property (nonatomic, copy)NSString *truename;

@property (nonatomic, copy)NSString *two;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *shop_address;

@property (nonatomic, copy)NSString *typer;

@end

@interface GLIncomeRecommendModel : NSObject

@property (nonatomic, copy)NSString *addtime;

@property (nonatomic, copy)NSString *money;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *pic;

@property (nonatomic, copy)NSString *rice;

@property (nonatomic, copy)NSString *truename;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)NSString *user_name;

@property (nonatomic, copy)NSString *typer;

@end

@interface GLIncomeRewardModel : NSObject

@property (nonatomic, copy)NSString *regtime;

@property (nonatomic, copy)NSString *money;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *pic;

@property (nonatomic, copy)NSString *rice;

@property (nonatomic, copy)NSString *truename;

@property (nonatomic, copy)NSString *user_name;

@property (nonatomic, copy)NSString *typer;

@property (nonatomic, copy)NSString *uid;

@end
