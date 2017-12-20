//
//  GLClassifyRecommendCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLClassifyRecommendCell.h"

@interface GLClassifyRecommendCell()


@end

@implementation GLClassifyRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 5.f;
    self.clipsToBounds = YES;
    
}

- (void)setModel:(GLClassifyModel *)model{
    _model = model;
    
    self.titleLabel.text = model.catename;

    
    
}
@end
