//
//  LBSendRedPaketTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSendRedPaketTableViewCell.h"

@implementation LBSendRedPaketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LBSendRedpaketModel *)model{
    _model = model;
    
    self.userId.text = [NSString stringWithFormat:@"用户名:%@",_model.truename];
    self.moneylb.text = [NSString stringWithFormat:@"手续费:¥%@",_model.sxf];
    self.phonelb.text = [NSString stringWithFormat:@"米子:¥%@",_model.num];
    self.timelb.text = [NSString stringWithFormat:@"%@",_model.time];
    
    if ([_model.truename rangeOfString:@"null"].location != NSNotFound || _model.truename.length <= 0) {
       self.userId.text = [NSString stringWithFormat:@"用户名:%@",_model.cname];
    }

}

@end
