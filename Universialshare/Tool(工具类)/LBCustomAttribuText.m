//
//  LBCustomAttribuText.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBCustomAttribuText.h"

@implementation LBCustomAttribuText

+(NSAttributedString*)originstr:(NSString*)originstr specilstr:(NSString*)specilstr  attribus:(NSDictionary<NSAttributedStringKey,id>*)attribus{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    NSRange rang = [originstr rangeOfString:specilstr];
    
    [noteStr addAttributes:attribus range:rang];
    
    return noteStr;
    
}

+(NSAttributedString *)originstr:(NSString *)originstr specilstrarr:(NSArray *)specilstrarr attribus:(NSDictionary<NSAttributedStringKey,id> *)attribus{
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:originstr];
    
    for (int i = 0; i < specilstrarr.count; i++) {
        NSRange rang = [originstr rangeOfString:specilstrarr[i]];
        [noteStr addAttributes:attribus range:rang];
    }
    
    
    return noteStr;
    
    
}
@end
