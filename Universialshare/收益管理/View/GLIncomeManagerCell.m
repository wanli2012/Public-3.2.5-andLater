//
//  GLIncomeManagerCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIncomeManagerCell.h"

@interface GLIncomeManagerCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *spendLb;
@property (weak, nonatomic) IBOutlet UILabel *riceLb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;

@end

@implementation GLIncomeManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


- (void)setModel:(GLIncomeRecommendModel *)model {
    _model = model;
    
    [_imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.pic]] placeholderImage:nil];
    self.name.text = [NSString stringWithFormat:@"%@",_model.name];
    self.riceLb.attributedText = [self changeColor:self.spendLb rangeNumber:_model.rice str1:@"米分:"];
    self.timelb.text =[NSString stringWithFormat:@"%@",_model.addtime];
    self.spendLb.hidden = YES;
    
    if (self.name.text.length <=0 ||[self.name.text rangeOfString:@"null"].location != NSNotFound) {
        self.name.text = [NSString stringWithFormat:@"%@",_model.user_name];
    }
    
}

-(void)setModel1:(GLIncomeRewardModel *)model1{
    _model1 = model1;
    
    [_imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model1.pic]] placeholderImage:nil];
    self.name.text = [NSString stringWithFormat:@"%@",_model1.name];
    self.spendLb.attributedText = [self changeColor:self.spendLb rangeNumber:_model1.rice str1:@"奖励:"];
    self.riceLb.attributedText = [self changeColor:self.riceLb rangeNumber:_model1.money str1:@"消费:"];
    
    NSTimeInterval time1=[_model1.regtime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time1];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.timelb.text = [dateFormatter stringFromDate: detaildate];
    
    self.spendLb.hidden = NO;
    if (self.name.text.length <=0 ||[self.name.text rangeOfString:@"null"].location != NSNotFound) {
        self.name.text = [NSString stringWithFormat:@"%@",_model.user_name];
    }

}

- (NSMutableAttributedString *)changeColor:(UILabel*)label rangeNumber:(NSString * )rangeNum str1:(NSString*)str
{
    
    NSString *totalStr = [NSString stringWithFormat:@"%@%@",str,rangeNum];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:rangeNum];
    [textColor addAttribute:NSForegroundColorAttributeName value:TABBARTITLE_COLOR range:rangel];
    return textColor;
}

@end
