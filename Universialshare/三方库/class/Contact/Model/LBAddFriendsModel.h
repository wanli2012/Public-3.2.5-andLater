//
//  LBAddFriendsModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBAddFriendsModel : NSObject

@property (copy , nonatomic)NSString *pic;
@property (copy , nonatomic)NSString *user_name;
@property (copy , nonatomic)NSString *truename;
@property (copy , nonatomic)NSString *im_id;
@property (copy , nonatomic)NSString *group_name;
@property (copy , nonatomic)NSString *phone;
@property (assign , nonatomic)BOOL isrequst;

@end
