//
//  LBFrozenRiceTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFrozenRiceTableViewCell.h"

@interface LBFrozenRiceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *numLB;

@property (weak, nonatomic) IBOutlet UILabel *mallLb;

@end

@implementation LBFrozenRiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBFrozenRiceModel *)model{
    _model = model;

    [_timeLb setAttributedText:[self changeColor:_timeLb rangeNumber:_model.num titile:@"激活米分"]];
    _mallLb .text = _model.addtime;

}

-(void)setMallModel:(LBFrozenRiceModel *)mallModel{

    _mallModel = mallModel;
    
    [_timeLb setAttributedText:[self changeColor:_timeLb rangeNumber:_mallModel.amount titile:@"米子"]];
    [_numLB setAttributedText:[self changeColor:_numLB rangeNumber:_mallModel.voucher titile:@"米券"]];
    _mallLb .text = _mallModel.addtime;

}

- (NSMutableAttributedString *)changeColor:(UILabel*)label rangeNumber:(NSString* )rangeNum titile:(NSString*)str
{
    NSString *totalStr = [NSString stringWithFormat:@"%@:%@",str,rangeNum];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:rangeNum];
    [textColor addAttribute:NSForegroundColorAttributeName value:YYSRGBColor(235, 136, 26, 1) range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangel];
    return textColor;
}
@end
