
//  UserModel.m
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import "UserModel.h"
#import "usermodelachivar.h"
#import <objc/runtime.h>
@implementation UserModel
/**< 线程安全的单例创建 */
+ (UserModel *)defaultUser {
    static UserModel *model;
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model=[usermodelachivar umachive];
        if (!model) {
            model = [[UserModel alloc]init];
        }
        
    });
    
    return model;
}
#pragma mark - getter
- (BOOL)needAutoLogin {
    BOOL needautologin=[[[NSUserDefaults standardUserDefaults]objectForKey:@"AUTOLOGIN"]boolValue];
    return needautologin;
}

//解档
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        unsigned int count = 0;
        //获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([UserModel class], &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //NSString *key = [[NSString stringWithUTF8String:name] substringFromIndex:1];
            //进行解档取值
            id value = [aDecoder decodeObjectForKey:strName];
            //strName=value;
            //利用KVC对属性赋值
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}
//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([UserModel class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
    
}
@end
