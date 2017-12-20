//
//  GLRecommendCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendCell.h"

@implementation GLRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLRecommendModel *)model{
    _model = model;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.regtime];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    self.dateLabel.text = timeStr;
    
    if ([model.num rangeOfString:@"null"].location != NSNotFound) {
        self.numberLabel.text = @"0";
    }else{
       self.numberLabel.text = model.num;
    }

}
@end
