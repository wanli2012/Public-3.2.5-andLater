//
//  LBSendGoodsProductModel.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/3.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendGoodsProductModel.h"

@implementation LBSendGoodsProductModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        _order_goods_id = value;
    }
}

@end
