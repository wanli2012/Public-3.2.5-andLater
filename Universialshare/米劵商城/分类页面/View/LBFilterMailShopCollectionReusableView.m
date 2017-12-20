//
//  LBFilterMailShopCollectionReusableView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFilterMailShopCollectionReusableView.h"

@implementation LBFilterMailShopCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(GLClassifyModel *)model{
    _model = model;
    self.titleLb.text = [NSString stringWithFormat:@"%@",model.catename];

}
@end
