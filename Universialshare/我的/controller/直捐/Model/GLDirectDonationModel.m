//
//  GLDirectDonationModel.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDirectDonationModel.h"

@implementation GLDirectDonationModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"time"]){
        _timeStr = value;
    }
}

@end
