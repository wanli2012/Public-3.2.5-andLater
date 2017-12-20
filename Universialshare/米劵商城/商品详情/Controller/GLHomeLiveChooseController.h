//
//  GLHomeLiveChooseController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnChooseValueBlock)(NSString *value,NSInteger index);
@interface GLHomeLiveChooseController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *dataSource;

@property (nonatomic, copy) returnChooseValueBlock block;

@property (nonatomic, assign)BOOL isSelect;//第一行是否选中

@end
