//
//  GLFriendController.m
//  正儿八金
//
//  Created by 龚磊 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLFriendController.h"
#import "LBGoodFriendsHeaderView.h"
#import "LBGoodFriendsViewHeaderFooterView.h"
#import "LBGoodFriendsSectionView.h"
#import "NTESSessionListViewController.h"
#import "NTESContactViewController.h"
#import "QQPopMenuView.h"
#import "NTESContactAddFriendViewController.h"
#import "NTESSessionViewController.h"
#import "NIMContactSelectViewController.h"
#import "NTESSettingViewController.h"
#import "NTESSearchTeamViewController.h"
#import "AnotherSearchViewController.h"

@interface GLFriendController ()

@property (weak, nonatomic) IBOutlet UIView *navagationView;
@property (strong, nonatomic) LBGoodFriendsHeaderView *goodFriendsHeaderView;
@property (strong, nonatomic) LBGoodFriendsSectionView *goodFriendsSectionView;
@property (strong , nonatomic)UIButton *currentBt;

@property (strong, nonatomic)NTESSessionListViewController *sessionListVc;
@property (strong, nonatomic)NTESContactViewController *contactVc;
@property (strong, nonatomic)UIViewController *currentVC;
@property (strong, nonatomic)NSMutableArray *typeArr;
@property (strong, nonatomic)QQPopMenuView *popview;

@end

@implementation GLFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.goodFriendsHeaderView];
    [self.view addSubview:self.goodFriendsSectionView];
    self.currentBt = self.goodFriendsSectionView.messageBt;
    
    self.sessionListVc = [[NTESSessionListViewController alloc] init];
    self.sessionListVc.view.frame = CGRectMake(0,165, SCREEN_WIDTH, SCREEN_HEIGHT - 165);
    [self addChildViewController:self.sessionListVc];
    
    self.contactVc = [[NTESContactViewController alloc] init];
    self.contactVc.view.frame = CGRectMake(0, 165, SCREEN_WIDTH, SCREEN_HEIGHT - 165);
    [self addChildViewController:self.contactVc];
    
    //设置默认控制器为fristVc
    self.currentVC = self.sessionListVc;
    [self.view addSubview:self.sessionListVc.view];
    
  }


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    

}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.navagationView.layer.shadowColor = YYSRGBColor(207, 207, 207, 1).CGColor;
    self.navagationView.layer.shadowOffset=CGSizeMake(0, 5);
    self.navagationView.layer.shadowOpacity=0.5;

}
- (IBAction)showOtherfunction:(UIButton *)sender {
    
    __weak typeof(self) weakself = self;
    
    _popview = [[QQPopMenuView alloc] initWithItems:self.typeArr
                              
                                                            width:130
                                                 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
                                                           action:^(NSInteger index) {
                                                               switch (index) {
                                                                   case 0:
                                                                       [weakself addGoodFriend];//添加好友
                                                                       break;
                                                                   case 1:
                                                                       [weakself InitiateGroupChat];//发起群聊
                                                                       break;
                                                                   case 2:
                                                                       [weakself creatDiscussGroup];//发起讨论组
                                                                       break;
                                                                   case 3:
                                                                       [weakself setUp];//设置
                                                                       break;
                                                                       
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
    
    _popview.isBigImage = YES;
    
    [_popview show];
    
    
}
#pragma mark -- 附加功能
-(void)addGoodFriend{
   [_popview hide];
    self.hidesBottomBarWhenPushed = YES;
  NTESContactAddFriendViewController  *vc = [[NTESContactAddFriendViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
  
}

-(void)InitiateGroupChat{
[_popview hide];
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [self presentMemberSelector:^(NSArray *uids) {
        NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
        NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
        option.name       = @"高级群";
        option.type       = NIMTeamTypeAdvanced;
        option.joinMode   = NIMTeamJoinModeNoAuth;
        option.postscript = @"邀请你加入群组";
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
            [SVProgressHUD dismiss];
            if (!error) {
                NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                [self.navigationController showViewController:vc sender:nil];
                
            }else{
                [self.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
            }
        }];
    }];

}
-(void)creatDiscussGroup{
   [_popview hide];
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [self presentMemberSelector:^(NSArray *uids) {
        if (!uids.count) {
            return; //讨论组必须除自己外必须要有一个群成员
        }
        NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
        NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
        option.name       = @"讨论组";
        option.type       = NIMTeamTypeNormal;
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
            [SVProgressHUD dismiss];
            if (!error) {
                NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                [self.navigationController showViewController:vc sender:nil];
                
            }else{
                [self.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
            }
        }];
    }];

}

-(void)setUp{
    [_popview hide];
    self.hidesBottomBarWhenPushed = YES;
    NTESSettingViewController  *vc = [[NTESSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

}
//搜索
-(void)tapgestureSearchFriend{
    self.hidesBottomBarWhenPushed = YES;
   AnotherSearchViewController *vc = [[AnotherSearchViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];

}
- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}
#pragma mark ------- 切换好友和通讯录
-(void)clickmessageEvent:(UIButton*)sender{
    
    if (self.currentBt == self.goodFriendsSectionView.messageBt) {
        return;
    }
    self.currentBt.selected = NO;
    self.currentBt = self.goodFriendsSectionView.messageBt;
    self.currentBt.selected = YES;
   
     [self replaceFromOldViewController:self.contactVc toNewViewController:self.sessionListVc];
}

-(void)clickmailListEvent:(UIButton*)sender{
    
    if (self.currentBt == self.goodFriendsSectionView.MailListBt) {
        return;
    }
    self.currentBt.selected = NO;
    self.currentBt = self.goodFriendsSectionView.MailListBt;
    self.currentBt.selected = YES;
    [self replaceFromOldViewController:self.sessionListVc toNewViewController:self.contactVc];
    
}
-(LBGoodFriendsHeaderView*)goodFriendsHeaderView{

    if (!_goodFriendsHeaderView) {
        _goodFriendsHeaderView = [[NSBundle mainBundle ]loadNibNamed:@"LBGoodFriendsHeaderView" owner:self options:nil].firstObject;
        _goodFriendsHeaderView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
         _goodFriendsHeaderView.autoresizingMask = UIViewAutoresizingNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureSearchFriend)];
        [_goodFriendsHeaderView addGestureRecognizer:tap];
    }

    return _goodFriendsHeaderView;

}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    if (self.currentVC == newVc) {
        return;
    }
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}

-(LBGoodFriendsSectionView*)goodFriendsSectionView{
    
    if (!_goodFriendsSectionView) {
        
        _goodFriendsSectionView = ({
        
            LBGoodFriendsSectionView *view = [[NSBundle mainBundle]loadNibNamed:@"LBGoodFriendsSectionView" owner:nil options:nil].firstObject;
            view.frame = CGRectMake(0, 115,SCREEN_WIDTH , 50);
            view.autoresizingMask = UIViewAutoresizingNone;
            [view.messageBt addTarget:self action:@selector(clickmessageEvent:) forControlEvents:UIControlEventTouchUpInside];
            [view.MailListBt addTarget:self action:@selector(clickmailListEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            view;
        
        });
    }
    
    return _goodFriendsSectionView;
    
}

-(NSMutableArray*)typeArr{
    
    if (!_typeArr) {
        _typeArr = [NSMutableArray arrayWithArray:@[@{@"title":@"添加好友",@"imageName":@"addfriend"},
                                                    @{@"title":@"创建高级群",@"imageName":@"group-chat"},
                                                    @{@"title":@"创建讨论组",@"imageName":@"cheatroom"},
                                                    @{@"title":@"设置",@"imageName":@"setting"},
                                                    ]];
    }
    
    return _typeArr;
}
@end
