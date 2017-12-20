//
//  LBCustomAttribuText.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBCustomAttribuText : NSObject

+(NSAttributedString*)originstr:(NSString*)originstr specilstr:(NSString*)specilstr  attribus:(NSDictionary<NSAttributedStringKey,id>*)attribus;

+(NSAttributedString*)originstr:(NSString*)originstr specilstrarr:(NSArray*)specilstrarr  attribus:(NSDictionary<NSAttributedStringKey,id>*)attribus;

@end
