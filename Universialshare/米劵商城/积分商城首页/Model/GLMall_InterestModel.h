//
//  GLMall_InterestModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMall_InterestModel : NSObject

@property (nonatomic, copy)NSString *goods_id;

//url
@property (nonatomic, copy)NSString *thumb;
//商品名称
@property (nonatomic, copy)NSString *goods_name;
//价格
@property (nonatomic, copy)NSString *discount;
//商品其他介绍
@property (nonatomic, copy)NSString *goods_details;

@property (nonatomic, copy)NSString *goods_price;//原价

@end
