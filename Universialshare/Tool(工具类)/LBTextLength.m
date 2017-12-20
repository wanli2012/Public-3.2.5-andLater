//
//  LBTextLength.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBTextLength.h"

@implementation LBTextLength

+(NSUInteger)textLength: (NSString *) text{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}
@end
