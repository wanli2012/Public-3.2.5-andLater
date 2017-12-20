//
//  LBMineCenterModifyLoginSecretViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)();
@interface GLMerchat_StoreModifyController : UIViewController

@property (nonatomic, copy)returnBlock block;

@property (nonatomic, copy)NSString *uid;

@end
