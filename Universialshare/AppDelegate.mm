//
//  AppDelegate.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "BasetabbarViewController.h"
#import "GLLoginController.h"
#import "IQKeyboardManager.h"
#import "BaseNavigationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "yindaotuViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMessage.h"
#import "WXApi.h"

#import "NTESLogManager.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "UIView+Toast.h"
#import "NTESRedPacketManager.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESDemoConfig.h"
#import "NTESCellLayoutConfig.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESNotificationCenter.h"
#import "NTESSubscribeManager.h"
#import <PushKit/PushKit.h>

#import "UMMobClick/MobClick.h"

#import <UserNotifications/UserNotifications.h>
#import "NTESClientUtil.h"
#import "NTESSessionUtil.h"
#import "Reachability.h"

NSString *NTESNotificationLogout = @"NTESNotificationLogout";

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate,NIMLoginManagerDelegate,UIAlertViewDelegate,PKPushRegistryDelegate>
{
@private
    Reachability *hostReach;
}

@property(strong,nonatomic)BMKMapManager* mapManager;
@property(strong,nonatomic)NSDictionary* userInfo;
@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;
    
- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变
- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接改变后的情况

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self setupNIMSDK];
    [self setupServices];
    [self registerPushService];
    [self commonInitListenEvents];
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"YDpxkRgH1YcLhjuvGq3OD4RPGqeS8swt" generalDelegate:self];
    if (!ret) {
        [MBProgressHUD showError:@"启动百度地图失败"];
    }
    //友盟分享
    [UMSocialData setAppKey:UMSHARE_APPKEY];
    [UMSocialWechatHandler setWXAppId:WEIXI_APPKEY appSecret:WEIXI_SECRET url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WEIBO_APPKEY
                                              secret:WEIBO_SECRET
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    /**
     *微信支付
     */
    [WXApi registerApp:WEIXI_APPKEY withDescription:@"dztg"];
    
    /**
     *推送
     */
    [UMessage startWithAppkey:@"59433fc8677baa3448001d44" launchOptions:launchOptions ];
    //注册通知，如果要使用category的自定义策略
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    //[UMessage setLogEnabled:YES];
    
    /**
     *友盟统计
     */
    
    UMConfigInstance.appKey = @"59a772c965b6d60e730002a1";
    UMConfigInstance.channelId = @"App Store";
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK
    
    //主界面
     [self setupMainViewController];
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    
    [self updateInterfaceWithReachability: hostReach];
   
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    
//        NSString * token = [[[[deviceToken description]
//                              stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                             stringByReplacingOccurrencesOfString: @">" withString: @""]
//                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    

}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    self.userInfo = userInfo;
    //定制自定的的弹出框
    NSString *str = [NSString stringWithFormat:@"%@",userInfo[@"nim"]];
    
    if (![str isEqualToString:@"1"]) {//表示不是网易云推送
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                                message:userInfo[@"aps"][@"alert"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即更新", nil];
            
            [alertView show];
            
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectChatVc" object:nil];
        }

    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 登录需要编写
    [UMSocialSnsService applicationDidBecomeActive];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //关闭U-Push自带的弹出框
            NSString *str = [NSString stringWithFormat:@"%@",userInfo[@"nim"]];
        
        if (![str isEqualToString:@"1"]) {//表示不是网易云推送
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:userInfo[@"aps"][@"alert"][@"title"]
                                                                message:userInfo[@"aps"][@"alert"][@"body"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即更新", nil];
            
            [alertView show];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectChatVc" object:nil];
        }
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"safepay"]){
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Alipaysucess" object:nil];
                
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:
                        returnStr=@"订单正在处理中";
                        break;
                    case 4000:
                        returnStr=@"订单支付失败";
                        break;
                    case 6001:
                        returnStr=@"订单取消";
                        break;
                    case 6002:
                        returnStr=@"网络连接出错";
                        break;
                        
                    default:
                        break;
                }
                
                [MBProgressHUD showError:returnStr];
                
            }
        }];
    }else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    return YES;
}
// NOTE: 9.0以后使用新API接口
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Alipaysucess" object:nil];
                
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:
                        returnStr=@"订单正在处理中";
                        break;
                    case 4000:
                        returnStr=@"订单支付失败";
                        break;
                    case 6001:
                        returnStr=@"订单取消";
                        break;
                    case 6002:
                        returnStr=@"网络连接出错";
                        break;
                        
                    default:
                        break;
                }
                
                [MBProgressHUD showError:returnStr];
                
            }
        }];
    }

    return YES;
    
}

/**
 *微信支付
 */
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysucess" object:nil];
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付结果：取消！";
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                break;
        }
    }
    [MBProgressHUD showError:strMsg];
}

#pragma mark ----- uialertviewdelegete
//下载
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_URL]];
    }
    
}

#pragma mark =====即时通讯
#pragma mark PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    if ([type isEqualToString:PKPushTypeVoIP])
    {
         [[NIMSDK sharedSDK] updatePushKitToken:credentials.token];
    }
    
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    DDLogInfo(@"receive payload %@ type %@",payload.dictionaryPayload,type);
    NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
    if ([badge isKindOfClass:[NSNumber class]]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
    DDLogInfo(@"registry %@ invalidate %@",registry,type);
}

- (void)setupNIMSDK
{
        //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
        self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
        [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
        [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
        [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    
    
        //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
        //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
        //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 S DK 未提供的接口。
        NSString *appKey        = [[NTESDemoConfig sharedConfig] appKey];
        NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
        option.apnsCername      = [[NTESDemoConfig sharedConfig] apnsCername];
        option.pkCername        = [[NTESDemoConfig sharedConfig] pkCername];
        [[NIMSDK sharedSDK] registerWithOption:option];
    
        //注册自定义消息的解析器
        [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
        //注册 NIMKit 自定义排版配置
        [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
    
}

- (void)setupMainViewController
{
    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        [[NTESServiceManager sharedManager] start];
    }
   
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isdirect1"] isEqualToString:@"YES"]) {
        self.window.rootViewController = [[BasetabbarViewController alloc]init];
    }else{
        self.window.rootViewController = [[yindaotuViewController alloc]init];
    }
}


#pragma mark - logic impl
- (void)setupServices
{
        [[NTESLogManager sharedManager] start];
        [[NTESNotificationCenter sharedCenter] start];
        [[NTESSubscribeManager sharedManager] start];
//        [[NTESRedPacketManager sharedManager] start];
}

#pragma mark - misc
- (void)registerPushService
{
    //apns
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //pushkit
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
}

- (void)commonInitListenEvents
{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(logout:)
                                                     name:NTESNotificationLogout
                                                   object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

#pragma mark - 注销
-(void)logout:(NSNotification*)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    [[NTESServiceManager sharedManager] destory];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumploginInterface" object:nil];
    
    [UserModel defaultUser].loginstatus = NO;
    [usermodelachivar achive];
   
}

#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    [self showAutoLoginErrorAlert:error];
}

#pragma mark - 登录错误回调
- (void)showAutoLoginErrorAlert:(NSError *)error
{
    NSString *message = [NTESSessionUtil formatAutoLoginMessage:error];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"自动登录失败"
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    {
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
                                                                NSString *account = [data account];
                                                                NSString *token = [data token];
                                                                if ([account length] && [token length])
                                                                {
                                                                    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
                                                                    loginData.account = account;
                                                                    loginData.token = token;
                                                                    
                                                                    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
                                                                }
                                                            }];
        [vc addAction:retryAction];
    }
    
    
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
                                                             }];
                                                         }];
    [vc addAction:logoutAction];
    
    [self.window.rootViewController presentViewController:vc
                                                 animated:YES
                                               completion:nil];
}
    
//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}


//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == ReachableViaWWAN)
    {
        [self showNetworkStatusAlert:@"现在使用的是无线网络"];
    }
    else if(status == ReachableViaWiFi)
    {
        
    }else
    {
        [self showNetworkStatusAlert:@"无网络连接,查看设置"];
    }
    
}
    


-(void)showNetworkStatusAlert:(NSString *)str{
    //我这里是网络变化弹出一个警报框，由于不知道怎么让widow加载UIAlertController，所以这里用UIAlertView替代了
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];

}


#pragma mark - 键盘高度处理
- (void)iqKeyboardShowOrHide {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

-(NSDictionary*)userInfo{
    if (!_userInfo) {
        _userInfo = [NSDictionary dictionary];
    }
    return _userInfo;
}

@end
