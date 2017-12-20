//
//  GetLabelBounds.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GetLabelBounds.h"

@implementation GetLabelBounds
+(CGRect)getlabelrect:(NSString*)str width:(CGFloat)width dic:(NSDictionary*)dict{
    
    CGRect sizeconent=[str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return sizeconent;
    
}
@end
