//
//  LBMineCentermodifyAdressTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCentermodifyAdressTableViewCell.h"

@implementation LBMineCentermodifyAdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)setupevent:(UIButton *)sender {
    
    //[self.subject sendNext:self.setupBt];
    
    if (self.returnSetUpbt) {
        self.returnSetUpbt(self.index);
    }
    
}

- (IBAction)deleteEvent:(UIButton *)sender {
    
   // [self.subject sendNext:self.deleteBt];
    if (self.returnDeletebt) {
        self.returnDeletebt(self.index);
    }
    
}

- (IBAction)editEvent:(UIButton *)sender {
    
    //[self.subject sendNext:self.editbt];
    if (self.returnEditbt) {
        self.returnEditbt(self.index);
    }
    
    
}

// 懒加载
//- (RACSubject *)subject {
//    if (_subject == nil) {
//        _subject = [RACSubject subject];
//    }
//    
//    return _subject;
//}

@end
