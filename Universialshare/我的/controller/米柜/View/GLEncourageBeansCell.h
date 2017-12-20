//
//  GLEncourageBeansCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLEncourageModel.h"

@interface GLEncourageBeansCell : UITableViewCell

@property (nonatomic ,strong)GLEncourageModel *model;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
