//
//  LBFilterMallShopCollectionViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLClassifyModel.h"

@interface LBFilterMallShopCollectionViewCell : UICollectionViewCell

@property (copy , nonatomic)LBclassifyTypeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end
