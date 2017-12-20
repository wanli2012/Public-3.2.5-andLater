//
//  orderEvaluationModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderEvaluationModel : NSObject

@property (copy, nonatomic)NSString *imageurl;
@property (copy, nonatomic)NSString *namelb;
@property (copy, nonatomic)NSString *infolb;
@property (copy, nonatomic)NSString *sizelb;
@property (copy, nonatomic)NSString *moneylb;
@property (assign, nonatomic)BOOL  isexpand;
@property (assign, nonatomic)CGFloat  starValue;
@property (strong, nonatomic)NSString  *conentlb;
@property(nonatomic,strong)NSString *order_goods_id;
@property(nonatomic,strong)NSString *mark;
@property(nonatomic,strong)NSString *is_comment;
@property(nonatomic,strong)NSString *reply;
@property(nonatomic,strong)NSString *conment;
@property(nonatomic,strong)NSString *goods_num;

@end
