//
//  LBRiceShopTagTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRiceShopTagTableViewCell.h"

@implementation LBRiceShopTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

     self.dwqTagV = [[LBRiceShopTagView alloc] initWithFrame:CGRectMake(45, 10, [UIScreen mainScreen].bounds.size.width - 55, 0)];
    [self addSubview:self.dwqTagV];
    
}

-(void)setHotSearchArr:(NSArray *)hotSearchArr
{
    _hotSearchArr = hotSearchArr;
    
    /** 注意cell的subView的重复创建！（内部已经做了处理了......） */
    [self.dwqTagV setTagWithTagArray:hotSearchArr];
    
}

@end
