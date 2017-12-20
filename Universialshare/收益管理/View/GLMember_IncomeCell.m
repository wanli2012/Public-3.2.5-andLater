//
//  GLMember_IncomeCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMember_IncomeCell.h"
#import "formattime.h"

@interface GLMember_IncomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *one;
@property (weak, nonatomic) IBOutlet UILabel *two;
@property (weak, nonatomic) IBOutlet UILabel *three;
@property (weak, nonatomic) IBOutlet UILabel *four;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *all_money;


@end

@implementation GLMember_IncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(GLIncomeBusinessModel *)model{

    _model = model;

    [_imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.pic]] placeholderImage:nil];
    self.name.text = [NSString stringWithFormat:@"%@",_model.truename];
    self.one.text = [NSString stringWithFormat:@"20%%:¥%@",_model.one];
    self.two.text = [NSString stringWithFormat:@"10%%:¥%@",_model.two];
    self.three.text = [NSString stringWithFormat:@"5%%:¥%@",_model.three];
    self.four.text = [NSString stringWithFormat:@"3%%:¥%@",_model.four];
    self.timelb.text = [formattime formateTimeYMD:_model.regtime];
    self.all_money.attributedText = [self changeColor:self.all_money rangeNumber:_model.total];
    
}

- (NSMutableAttributedString *)changeColor:(UILabel*)label rangeNumber:(NSString * )rangeNum
{
    
    NSString *totalStr = [NSString stringWithFormat:@"%@%@",@"销售额:",rangeNum];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:rangeNum];
    [textColor addAttribute:NSForegroundColorAttributeName value:TABBARTITLE_COLOR range:rangel];
    return textColor;
}

@end
