//
//  GLNoneOfDonationCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNoneOfDonationCell.h"

@interface GLNoneOfDonationCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rangliLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;



@end


@implementation GLNoneOfDonationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.layer.borderColor = YYSRGBColor(56, 136, 39, 1).CGColor;
    self.statusLabel.layer.cornerRadius = 3.f;
    self.statusLabel.layer.masksToBounds = YES;
}
- (void)setModel:(GLNoneOfDonationModel *)model {
    _model = model;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.time];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    self.dateLabel.text = timeStr;
    self.sellNumLabel.text = model.market;
    self.rangliLabel.text = model.rl_money;

    //状态
    if([model.status isEqualToString:@"1"]){
        self.statusLabel.text = @" 成功 ";
    }else if([model.status isEqualToString:@"0"]){
        self.statusLabel.text = @" 失败 ";
    }else{
        self.statusLabel.text = @" 未审核 ";
    }
    
    //让利类型
    if([model.status integerValue] == 0){
        self.typeLabel.text = @"5%";
    }else if ([model.status integerValue] == 1){
        self.typeLabel.text = @"10%";
    }else if([model.status integerValue] == 2){
        self.typeLabel.text = @"20%";
    }else{
         self.typeLabel.text = @"3%";
    }
}


@end
