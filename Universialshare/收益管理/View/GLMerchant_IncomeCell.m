//
//  GLMerchant_IncomeCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchant_IncomeCell.h"
#import "formattime.h"
@implementation GLMerchant_IncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(GLIncomeManagerModel *)model{

    _model = model;
    
    self.timelb.text = _model.addtime;
    self.namelb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    self.rlbael.text = [NSString stringWithFormat:@"让利:¥%@",_model.rl_money];
    self.numlb.text = [NSString stringWithFormat:@"数量:%@",_model.goods_num];
    self.modellb.text = [NSString stringWithFormat:@"模式:%@",_model.rl_type];
    self.moneylb.text = [NSString stringWithFormat:@"合计:%@",_model.total_money];

    [_iamgev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _model.thumb]] placeholderImage:nil];
    
}

-(void)setModel1:(GLIncomeManagerModel *)model1{
    
    _model1 = model1;
    
    NSTimeInterval time1=[_model1.addtime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time1];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.timelb.text = [dateFormatter stringFromDate: detaildate];
    
    self.namelb.text = [NSString stringWithFormat:@"%@",_model1.goods_name];
    self.rlbael.text = [NSString stringWithFormat:@"让利:¥%@",_model1.rl_money];
    self.numlb.text = [NSString stringWithFormat:@"数量:%@",_model1.goods_num];
    self.modellb.text = [NSString stringWithFormat:@"模式:%@",_model1.rl_type];
    self.moneylb.text = [NSString stringWithFormat:@"合计:%@",_model1.total_money];
    
    [_iamgev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _model1.thumb]] placeholderImage:nil];
    
    
    
}

@end
