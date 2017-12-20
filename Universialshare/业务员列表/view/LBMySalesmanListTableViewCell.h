//
//  LBMySalesmanListTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMySalesmanModel.h"

@interface LBMySalesmanListTableViewCell : UITableViewCell

@property (nonatomic, strong)GLMySalesmanModel *model;

@property (assign , nonatomic)NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *businessNum;

@property (strong , nonatomic)NSString *typestr;//身份类型

@property (copy , nonatomic)void(^returntapgestureimage)();

@end
