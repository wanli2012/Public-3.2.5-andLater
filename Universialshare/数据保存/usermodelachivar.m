//
//  usermodelachivar.m
//  813DeepBreathing
//
//  Created by rimi on 15/8/14.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import "usermodelachivar.h"
#import "UserModel.h"
@implementation usermodelachivar
+(UserModel *)umachive{

    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivepath]];

}
+(void)achive{

    BOOL flag=[NSKeyedArchiver archiveRootObject:[UserModel defaultUser] toFile:[self archivepath]];
    if (!flag) {
        NSLog(@"归档失败");
    }

}

+(NSString *)archivepath{

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basepath=([paths count]>0)?[paths objectAtIndex:0]:nil;
    return [basepath stringByAppendingPathComponent:@"UserModel.us"];

}
@end
