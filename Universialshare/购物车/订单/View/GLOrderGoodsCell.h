//
//  GLOrderGoodsCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLConfirmOrderModel.h"

@interface GLOrderGoodsCell : UITableViewCell

@property (nonatomic, strong)GLConfirmOrderModel *model;
@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;

@end
