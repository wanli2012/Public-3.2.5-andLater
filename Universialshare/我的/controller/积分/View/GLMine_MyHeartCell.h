//
//  GLMine_MyHeartCell.h
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMyheartModel.h"

@interface GLMine_MyHeartCell : UITableViewCell

@property (nonatomic,strong)GLMyheartModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;

@end
