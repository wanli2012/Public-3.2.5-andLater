//
//  GLHourseDetailFirstCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLGoodsDetailModel.h"

@interface GLHourseDetailFirstCell : UITableViewCell

@property (nonatomic, strong)GLGoodsDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBt;
@property (weak, nonatomic) IBOutlet UILabel *coupoesLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miaosuH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miaosuT;

@end
