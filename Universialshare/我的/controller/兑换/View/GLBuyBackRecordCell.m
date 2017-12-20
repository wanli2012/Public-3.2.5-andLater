//
//  GLBuyBackRecordCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackRecordCell.h"

@interface GLBuyBackRecordCell()

@end

@implementation GLBuyBackRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLBuyBackRecordModel *)model{
    _model = model;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.time];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    
    self.beanTypeLabel.text = model.Donaldtype;
    self.priceLabel.text = model.num;
    self.dateLabel.text = timeStr;
    
//    if ([model.status isEqualToString:@"0"]) {
//        self.typeLabel.text = @"申请中";
//    }else if ([model.status isEqualToString:@"1"]){
//        self.typeLabel.text = @"回购完成";
//    }else{
//        self.typeLabel.text = @"回购失败";
//    }
    
}


@end
