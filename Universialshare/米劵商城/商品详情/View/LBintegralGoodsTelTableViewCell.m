//
//  LBintegralGoodsTelTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBintegralGoodsTelTableViewCell.h"

@implementation LBintegralGoodsTelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (IBAction)takeTelephone:(UIButton *)sender {
    

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phone]]]; //拨号
    
}


@end
