//
//  LBSavaTypeModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSavaTypeModel : NSObject

@property (nonatomic, copy)NSString  *type;

@property (nonatomic, copy)NSString  *shop_id;//门店管理跳转保存的shopid

+(LBSavaTypeModel*)defaultUser;

@end
