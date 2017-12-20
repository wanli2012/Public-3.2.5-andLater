//
//  BasetabbarViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BasetabbarViewController.h"
#import "LBIntegralMallViewController.h"
#import "LBMineViewController.h"
#import "BaseNavigationViewController.h"

#import "GLLoginController.h"
#import "LBMineStoreOrderingViewController.h"
#import "LBMyBusinessListViewController.h"

#import "GLNearbyViewController.h"
#import "GLMerchat_StoreController.h"
#import "GLMerchat_CommentController.h"
#import "LBHomeIncomeViewController.h"
#import "GLShoppingCartController.h"

#import "NTESCustomNotificationDB.h"
#import "AppDelegate.h"
#import "LBOnlineConsultationViewController.h"

@interface BasetabbarViewController ()<UITabBarControllerDelegate,NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate>

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@property (nonatomic,assign) NSInteger systemUnreadCount;

@property (nonatomic,assign) NSInteger customSystemUnreadCount;

@end

@implementation BasetabbarViewController

+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[BasetabbarViewController class]]) {
        return (BasetabbarViewController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate=self;
    [self addViewControllers];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(exitLogin) name:@"exitLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(shopingCar) name:@"shopingCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(pushToHome) name:@"pushToHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(selectChatVc) name:@"selectChatVc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(jumploginInterface) name:@"jumploginInterface" object:nil];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
}
//完善资料退出跳转登录
-(void)exitLogin{
    self.selectedIndex = 0;
}

- (void)addViewControllers {

    //米劵商城
    LBIntegralMallViewController *IntegralMallvc = [[LBIntegralMallViewController alloc] init];
    BaseNavigationViewController *IntegralMallnav = [[BaseNavigationViewController alloc] initWithRootViewController:IntegralMallvc];
    IntegralMallvc.tabBarItem = [self barTitle:@"米券商城" image:@"public_welfare_consumption_normal" selectImage:@"public_welfare_consumption_select"];
    
    //我的
    LBMineViewController *minevc = [[LBMineViewController alloc] init];
    BaseNavigationViewController *minenav = [[BaseNavigationViewController alloc] initWithRootViewController:minevc];
    minevc.tabBarItem = [self barTitle:@"我的" image:@"wd_icon" selectImage:@"wd_selected_icon"];
    
    //搜附近
    GLNearbyViewController *nearbyVC = [[GLNearbyViewController alloc] init];
    BaseNavigationViewController *nearbyNav = [[BaseNavigationViewController alloc] initWithRootViewController:nearbyVC];
    nearbyNav.tabBarItem = [self barTitle:@"逛逛" image:@"sfj_icon" selectImage:@"sfj_selected_icon"];
    
    //客服
    LBOnlineConsultationViewController *friendVC = [[LBOnlineConsultationViewController alloc] init];
    BaseNavigationViewController *friendNav = [[BaseNavigationViewController alloc] initWithRootViewController:friendVC];
    friendNav.tabBarItem = [self barTitle:@"客服" image:@"mainServiceN" selectImage:@"mainServiceY"];
    
    //购物车
    GLShoppingCartController *ShoppingVC = [[GLShoppingCartController alloc] init];
    BaseNavigationViewController *ShoppingNav = [[BaseNavigationViewController alloc] initWithRootViewController:ShoppingVC];
    ShoppingNav.tabBarItem = [self barTitle:@"购物车" image:@"购物车未点中" selectImage:@"购物车点中"];
    
    
    self.viewControllers = @[IntegralMallnav,nearbyNav,friendNav,ShoppingNav, minenav];
    
    self.selectedIndex=0;
    
}

- (UITabBarItem *)barTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    
    item.title = title;
    item.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : YYSRGBColor(253, 136, 26, 1)} forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -4);
    return item;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]  || viewController == [tabBarController.viewControllers objectAtIndex:4]) {
        
        if ([UserModel defaultUser].loginstatus == NO) {
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
            return NO;

        }
    }
    
    return YES;
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    self.systemUnreadCount = unreadCount;
    [self refreshContactBadge];
}

#pragma mark - Notification

- (void)refreshSessionBadge{
    UINavigationController *nav = self.viewControllers[4];
    nav.tabBarItem.badgeValue = self.self.systemUnreadCount + self.sessionUnreadCount ? @(self.self.systemUnreadCount + self.sessionUnreadCount).stringValue : nil;
    
    [[NSUserDefaults standardUserDefaults]setObject:@(self.systemUnreadCount + self.sessionUnreadCount) forKey:@"num"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refrehFriendMessage" object:nil userInfo:@{@"num":@(self.self.systemUnreadCount + self.sessionUnreadCount)}];
}

- (void)refreshContactBadge{
    UINavigationController *nav = self.viewControllers[4];
    NSInteger badge = self.systemUnreadCount + self.sessionUnreadCount;
    nav.tabBarItem.badgeValue = badge ? @(badge).stringValue : nil;
    [[NSUserDefaults standardUserDefaults]setObject:@(self.systemUnreadCount + self.sessionUnreadCount) forKey:@"num"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refrehFriendMessage" object:nil userInfo:@{@"num":@(self.systemUnreadCount + self.sessionUnreadCount)}];
    
}

//刷新界面
-(void)refreshInterface{
    
   [self.viewControllers reverseObjectEnumerator];
    [self addViewControllers];

}

- (void)pushToHome{
    
     self.selectedIndex = 0; //回到首页
}

-(void)shopingCar{

    self.selectedIndex = 3;//选中购物车

}

-(void)selectChatVc{
    
    self.selectedIndex = 4;//选中聊天界面
    
}

-(void)jumploginInterface{
    GLLoginController *loginVC = [[GLLoginController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
