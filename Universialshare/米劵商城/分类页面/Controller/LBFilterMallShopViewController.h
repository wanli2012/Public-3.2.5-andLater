//
//  LBFilterMallShopViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBFilterMallShopViewController : UIViewController

@property (strong , nonatomic)NSMutableArray *models;
@property (copy , nonatomic)void(^refreshClassifyData)(NSString *cataid,NSString *catename);

@end
