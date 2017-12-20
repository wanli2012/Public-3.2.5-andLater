//
//  NetworkManager.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"


@implementation NetworkManager
// 参数urlStr表示网络请求url,paramDic表示请求参数,finish回调指网络请求成功回调,enError表示回调失败.

+ (void)requestGETWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError {
    // 创建一个SessionManager管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    NSMutableDictionary  *newDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    newDic[@"app_version"] = APP_VERSION;//app版本
    newDic[@"version"] = @"3";//端口
    
    // 指定我们能够解析的数据类型包含html.支持返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // AFNetworking请求结果回调时,failure方法会在两种情况下回调:1.请求服务器失败,服务器返回失败信息;2.服务器返回数据成功,AFN解析返回的数据失败.
    [manager GET:urlStr parameters:newDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        enError(error);
    }];
    
}

+ (void)requestPOSTWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    
    manager.requestSerializer.timeoutInterval=20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    NSString *urlStr1 = [NSString stringWithFormat:@"%@%@",URL_Base,urlStr];
    
    NSMutableDictionary  *newDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    newDic[@"app_version"] = APP_VERSION;
    newDic[@"version"] = @"3";
    
    [manager POST:urlStr1 parameters:newDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        enError(error);
    }];
    
}

//没有延迟时间
+ (void)requestPOSTWithURLStrundelay:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    manager.requestSerializer.timeoutInterval=20;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    
    NSString *urlStr1 = [NSString stringWithFormat:@"%@%@",URL_Base,urlStr];
    
    NSMutableDictionary  *newDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    newDic[@"app_version"] = APP_VERSION;
    newDic[@"version"] = @"3";
    
    [manager POST:urlStr1 parameters:newDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        enError(error);
    }];
    
}

+ (NSURLSessionDataTask*)requestGETWithURLStrReture:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError {
    // 创建一个SessionManager管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    // 指定我们能够解析的数据类型包含html.支持返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // AFNetworking请求结果回调时,failure方法会在两种情况下回调:1.请求服务器失败,服务器返回失败信息;2.服务器返回数据成功,AFN解析返回的数据失败.
    NSMutableDictionary  *newDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    newDic[@"app_version"] = APP_VERSION;
    newDic[@"version"] = @"3";
    NSURLSessionDataTask *task= [manager GET:urlStr parameters:newDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        enError(error);
    }];
    return task;
}

+ (NSURLSessionDataTask*)requestPOSTWithURLStrReture:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject)) finish enError:(void(^)(NSError *error))enError {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval=20;
    NSString *urlStr1 = [NSString stringWithFormat:@"%@%@",URL_Base,urlStr];
    NSMutableDictionary  *newDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    newDic[@"app_version"] = APP_VERSION;
    newDic[@"version"] = @"3";
    NSURLSessionDataTask *task= [manager POST:urlStr1 parameters:newDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        enError(error);
    }];
    
    return task;
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

//+ (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
//    
//    OSStatus securityError = errSecSuccess;
//    
//    //client certificate password
//    
//    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"111111"
//                                      
//                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
//    
//    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//    
//    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
//    
//    if(securityError == 0) {
//        
//        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
//        
//        const void*tempIdentity =NULL;
//        
//        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
//        
//        *outIdentity = (SecIdentityRef)tempIdentity;
//        
//        const void*tempTrust =NULL;
//        
//        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
//        
//        *outTrust = (SecTrustRef)tempTrust;
//        
//    } else {
//        
//        NSLog(@"Failedwith error code %d",(int)securityError);
//        
//        return NO;
//        
//    }
//    
//    return YES;
//    
//}


@end

