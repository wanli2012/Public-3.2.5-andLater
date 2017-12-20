//
//  LBFilterMallShopCollectionViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFilterMallShopCollectionViewCell.h"

@implementation LBFilterMallShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBclassifyTypeModel *)model{
    _model = model;

    self.titleLb.text = [NSString stringWithFormat:@"%@",model.catename];
    
    if (_model.iscollection == YES) {
        self.titleLb.backgroundColor = TABBARTITLE_COLOR;
        self.titleLb.textColor = [UIColor whiteColor];
    }else{
        self.titleLb.backgroundColor = [UIColor whiteColor];
        self.titleLb.textColor = [UIColor blackColor];
    }
    
    
    
}

@end
