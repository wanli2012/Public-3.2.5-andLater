//
//  GLReceiveBeansCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//
#import "GLReceiveBeansCell.h"

@implementation GLReceiveBeansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLReceiveBeansModel *)model{
    _model = model;
    
    self.dateLabel.text = model.time;
    
    if ([model.num floatValue] > 10000) {
        
        self.numberLabel.text = [NSString stringWithFormat:@"%.2f",[model.num floatValue] / 10000];
    }else{
        
        self.numberLabel.text = [NSString stringWithFormat:@"%@",model.num];
    }
    self.IDLabel.text = model.type;
}

@end
