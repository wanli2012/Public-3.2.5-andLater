//
//  NetworkManager.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^uploadProgress)(NSProgress *progress);
typedef void (^success)(NSURLSessionDataTask *task, id object);
typedef void (^failure)(NSURLSessionDataTask *task, NSError *error);

@interface NetworkManager : NSObject
// 参数urlStr表示网络请求url,paramDic表示请求参数,finish回调指网络请求成功回调,enError表示回调失败.

+ (void)requestGETWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError; // GET请求回调


+ (void)requestPOSTWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError; // POST请求回调

+ (void)requestPOSTWithURLStrundelay:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError;// POST请求回调 不需要超时
//需要返回NSURLSessionDataTask
+ (NSURLSessionDataTask*)requestPOSTWithURLStrReture:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError;

+ (NSURLSessionDataTask*)requestGETWithURLStrReture:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError;

+ (AFSecurityPolicy*)customSecurityPolicy;
@end

