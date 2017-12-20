//
//  GLEncourageBeansCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLEncourageBeansCell.h"

@implementation GLEncourageBeansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLEncourageModel *)model{
    _model = model;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.timeStr];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];

    self.numberLabel.text = model.num;
    
    
    self.dateLabel.text = timeStr;
    self.typeLabel.text = model.donatetype;
    
}

@end
