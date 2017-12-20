//
//  LBMineCentermodifyAdressViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnAddressBlock)(NSString *name,NSString *phoneNum,NSString *address,NSString *addressid);
@interface LBMineCentermodifyAdressViewController : UIViewController

@property (nonatomic, copy)returnAddressBlock block;

@end
