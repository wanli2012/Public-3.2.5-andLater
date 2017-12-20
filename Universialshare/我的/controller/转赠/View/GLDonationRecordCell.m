//
//  GLDonationRecordCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationRecordCell.h"
@interface GLDonationRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *beanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *momeylb;

@end

@implementation GLDonationRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLDonationRecordModel *)model{
    _model = model;

    if ([model.cname rangeOfString:@"null"].location != NSNotFound) {
        model.cname = @"";
    }
    if ([model.num rangeOfString:@"null"].location != NSNotFound) {
        model.num = @"0";
    }
    if ([model.time rangeOfString:@"null"].location != NSNotFound) {
        model.time = @"";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.time];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    
    self.nameTitle.text = [NSString stringWithFormat:@"获赠人: %@",model.truename];
    
    if (model.truename.length <= 0) {
         self.nameTitle.text = [NSString stringWithFormat:@"获赠人: %@",model.cname];
    }

    self.dateLabel.text = timeStr;
    
    if ([model.type integerValue]==1) {
        self.beanNumLabel.text = @"转赠类型: 米券";
    }else{
       self.beanNumLabel.text = @"转赠类型: 米子";
    }
    
    self.momeylb.text = [NSString stringWithFormat:@"转赠数量: %@",model.num];
    
    if ([model.num intValue] > 10000) {
        
        CGFloat num = [model.num  floatValue] / 10000;
        self.momeylb.text = [NSString stringWithFormat:@"转赠数量: %.2f万",num];
        
    }
   
}
@end
