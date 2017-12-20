//
//  GLShoppingCartModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLShoppingCartModel : NSObject

@property (nonatomic, copy)NSString *goods_name;

@property (nonatomic, copy)NSString *goods_id;

@property (nonatomic, copy)NSString *goods_price;

@property (nonatomic, copy)NSString *info;

@property (nonatomic, copy)NSString *num;

@property (nonatomic, copy)NSString *send_price;

@property (nonatomic, copy)NSString *thumb;

@property (nonatomic, copy)NSString *cart_id;

@property (nonatomic, copy)NSString *goods_type;

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *spec;

@property (nonatomic, copy)NSString *spec_id;

@property (nonatomic, assign)BOOL isSelect;//是否被选

@end
