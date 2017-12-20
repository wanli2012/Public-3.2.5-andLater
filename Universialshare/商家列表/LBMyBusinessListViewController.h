//
//  LBMyBusinessListViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMyBusinessListViewController : UIViewController

@property (copy , nonatomic)void(^returnpushvc)(NSDictionary *dic);

@property (copy , nonatomic)void(^returnpushinfovc)(NSInteger index);

@property (assign , nonatomic)BOOL HideNavB;//是否隐藏导航栏

@end
