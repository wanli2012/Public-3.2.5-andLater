
//
//  GLIntegralHeaderView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralHeaderView.h"

@implementation GLIntegralHeaderView

- (IBAction)jumpGoodsClassify:(UIButton *)sender {
    
    [self.delegate clickJimpGoodsClassify:self.section];
}

@end
