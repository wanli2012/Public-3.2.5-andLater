//
//  LBBillOfLadingDetailViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/8.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBillOfLadingModel.h"

@interface LBBillOfLadingDetailViewController : UIViewController

@property (strong , nonatomic)LBBillOfLadingModel *model;

@property (assign , nonatomic)BOOL isbutton;//是否隐藏提交按钮 yes 为隐藏 默认为NO
@end
