//
//  GLNearby_ClassifyConcollectionCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLNearby_ClassifyConcollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign)BOOL isChangeColor;

@end
