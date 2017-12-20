//
//  LBMineCenterMeeToTotalTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMeeToTotalTableViewCell.h"

@interface LBMineCenterMeeToTotalTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation LBMineCenterMeeToTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    
}

-(void)setModel:(LBMeeBomodel *)model{
    _model = model;
    
    self.timeLb.text = _model.addtime;
    
    if ([self compareDate:[self nowtimeWithString] withDate:_model.addtime] == 0) {
        self.timeLb.textColor = [UIColor redColor];
        self.moneyLb.textColor = [UIColor redColor];
        self.lineView.backgroundColor = [UIColor redColor];
    }else{
        self.timeLb.textColor = [UIColor darkGrayColor];
        self.moneyLb.textColor = [UIColor darkGrayColor];
        self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }
    
}

-(NSString*)nowtimeWithString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate date];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}

//比较两个日期的大小  日期格式为2016-08-14 08：46：20
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}


@end
