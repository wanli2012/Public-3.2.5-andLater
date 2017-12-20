//
//  GLTwoButtonCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLTwoButtonCell.h"

@implementation GLTwoButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)changeView:(UIButton *)sender {
    if (sender == self.image_textBtn) {
        self.Image_textV.hidden = NO;
        self.evaluateV.hidden = YES;
    }else{
        self.Image_textV.hidden = YES;
        self.evaluateV.hidden = NO;
    }
    [_delegate changeView:sender.tag];
}


@end
