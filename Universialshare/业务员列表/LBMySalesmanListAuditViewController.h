//
//  LBMySalesmanListAuditViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMySalesmanListAuditViewController : UIViewController

@property (copy , nonatomic)void(^returnpushvc)(NSDictionary *dic);

@property (copy , nonatomic)void(^returnpushinfovc)(NSInteger index);

@end
