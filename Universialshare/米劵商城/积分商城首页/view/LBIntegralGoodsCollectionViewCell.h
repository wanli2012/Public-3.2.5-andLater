//
//  LBIntegralGoodsCollectionViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLintegralGoodsModel.h"
@protocol LBIntegralGoodsCollectionViewdelegete <NSObject>

-(void)clickcheckcollectionbutton:(NSInteger)index;

@end

@interface LBIntegralGoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *infoLb;
@property (weak, nonatomic) IBOutlet UIButton *collectionBt;

@property (nonatomic, assign)id<LBIntegralGoodsCollectionViewdelegete> delegate;
@property (nonatomic, assign)NSInteger index;
@property (strong , nonatomic)GLintegralGoodsModel *model;


@end
