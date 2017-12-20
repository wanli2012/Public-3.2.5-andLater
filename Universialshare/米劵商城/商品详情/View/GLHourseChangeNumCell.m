//
//  GLHourseChangeNumCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseChangeNumCell.h"

@implementation GLHourseChangeNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.changeNumView.layer.cornerRadius = 4.f;
    self.changeNumView.clipsToBounds = YES;
    
}

- (IBAction)changeNum:(UIButton *)sender {
    
    if (sender.tag == 20) {
         self.sumLabel.text = [NSString stringWithFormat:@"%zd",[self.sumLabel.text integerValue] - 1];
        if([self.sumLabel.text integerValue] <= 1){
            self.sumLabel.text = @"1";
        }
    }else{
        self.sumLabel.text = [NSString stringWithFormat:@"%zd",[self.sumLabel.text integerValue] + 1];
    }
    
    if ([_delegate respondsToSelector:@selector(changeNum:)]) { // 如果协议响应
       
        [_delegate changeNum:self.sumLabel.text];
    }
}


@end
