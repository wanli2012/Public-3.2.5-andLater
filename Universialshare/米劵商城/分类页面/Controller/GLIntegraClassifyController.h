//
//  GLIntegraClassifyController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLIntegraClassifyController : UIViewController

@property (assign , nonatomic)NSInteger jumpindex;//表示从那个模块跳转的；

@property (strong , nonatomic)NSString *classId;//表示分类id；

@property (strong , nonatomic)NSString *classftyname;//分类名称

@property (strong , nonatomic)NSArray *classftyArr;//分类

@property (strong , nonatomic)NSString * classifyid;//分类id;

@property (strong , nonatomic)NSString *catename;//分类名称

@end
