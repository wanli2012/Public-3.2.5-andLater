//
//  NTESContactAddFriendViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "NTESContactAddFriendViewController.h"
#import "LBAddFriendsTableViewCell.h"
#import "UIImage+Extension.h"
#import "NTESBundleSetting.h"
#import "NIMCommonTableData.h"
#import "NTESColorButtonCell.h"
#import "NIMCommonTableDelegate.h"
#import "LBAddFriendsModel.h"

@interface NTESContactAddFriendViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,LBAddFriendsDelegete,NIMUserManagerDelegate>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITextField *texttf;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic)NSMutableArray *dataarr;
@property (nonatomic,strong) NIMUser                 *user;
@property (nonatomic,copy  ) NSArray                 *data;
@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@end

@implementation NTESContactAddFriendViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableview.tableFooterView = [UIView new];
     [self.tableview registerNib:[UINib nibWithNibName:@"LBAddFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBAddFriendsTableViewCell"];
     self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"添加好友";
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    

    
}

-(void)reuestDatasource{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"content"] = self.texttf.text;
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Friends/searchUserByContent" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.dataarr removeAllObjects];
        if ([responseObject[@"data"] count] <= 0) {
            [MBProgressHUD showError:@"查不到该用户"];
            return ;
        }
        if ([responseObject[@"code"] integerValue]==1) {
        
            for (NSDictionary  *dic in responseObject[@"data"]) {
                LBAddFriendsModel *model = [LBAddFriendsModel mj_objectWithKeyValues:dic];
                [self.dataarr addObject:model];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:@"请求失败，请检查网络"];
        
    }];



}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 80;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBAddFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBAddFriendsTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegete = self;
    cell.model = self.dataarr[indexPath.row];
    cell.index = indexPath.row;

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [self.view endEditing:YES];
}

-(void)addfriends:(NSInteger)index{
    
    LBAddFriendsModel  *model = _dataarr[index];

    if ([model.im_id length] <= 0) {
        [self.view makeToast:@"该用户还未开通聊天"
                     duration:2.0f
                     position:CSToastPositionCenter];
        return;
    }
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = model.im_id;
    request.operation = NIMUserOperationRequest;
    if ([[NTESBundleSetting sharedConfig] needVerifyForFriend]) {
        request.operation = NIMUserOperationRequest;
        request.message = @"跪求通过";
    }
    NSString *successText = request.operation == NIMUserOperationRequest ? @"添加成功" : @"请求成功";
    NSString *failedText =  request.operation == NIMUserOperationRequest ? @"添加失败" : @"请求失败";
    
    __weak typeof(self) wself = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [wself.view makeToast:successText
                         duration:2.0f
                         position:CSToastPositionCenter];
            model.isrequst = !model.isrequst;
            [wself refresh:model.im_id];
        }else{
            [wself.view makeToast:failedText
                         duration:2.0f
                         position:CSToastPositionCenter];
        }
    }];


}
- (void)refresh:(NSString*)userId{
    self.user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    //[self buildData:userId];
    [self.tableview reloadData];
}
//搜索好友
- (IBAction)serachfriends:(UIButton *)sender {
    
    if (self.texttf.text <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        return;
    }
     [self.view endEditing:YES];
    [self reuestDatasource];
    
}

- (void)buildData:(NSString*)userId{
    BOOL isMe          = [userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount];
    BOOL isMyFriend    = [[NIMSDK sharedSDK].userManager isMyFriend:userId];
    BOOL isInBlackList = [[NIMSDK sharedSDK].userManager isUserInBlackList:userId];
    BOOL needNotify    = [[NIMSDK sharedSDK].userManager notifyForNewMsg:userId];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : userId.length ? self.user.userId : [NSNull null],
                                      CellClass     : @"NTESCardPortraitCell",
                                      RowHeight     : @(100),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"备注名",
                                      DetailTitle  : self.user.alias.length ? self.user.alias : @"",
                                      CellAction   : @"onActionEditAlias:",
                                      ShowAccessory: @(YES),
                                      Disable      : @(!isMyFriend),
                                      },
                                  @{
                                      Title        : @"生日",
                                      DetailTitle  : self.user.userInfo.birth.length ? self.user.userInfo.birth : @"",
                                      Disable      : @(!self.user.userInfo.birth.length),
                                      },
                                  @{
                                      Title        : @"手机",
                                      DetailTitle  : self.user.userInfo.mobile.length ? self.user.userInfo.mobile : @"",
                                      Disable      : @(!self.user.userInfo.mobile.length),
                                      },
                                  @{
                                      Title        : @"邮箱",
                                      DetailTitle  : self.user.userInfo.email.length ? self.user.userInfo.email : @"",
                                      Disable      : @(!self.user.userInfo.email.length),
                                      },
                                  @{
                                      Title        : @"签名",
                                      DetailTitle  : self.user.userInfo.sign.length ? self.user.userInfo.sign : @"",
                                      Disable      : @(!self.user.userInfo.sign.length),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"消息提醒",
                                      CellClass    : @"NTESSettingSwitcherCell",
                                      CellAction   : @"onActionNeedNotifyValueChange:",
                                      ExtraInfo    : @(needNotify),
                                      Disable      : @(isMe),
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"黑名单",
                                      CellClass    : @"NTESSettingSwitcherCell",
                                      CellAction   : @"onActionBlackListValueChange:",
                                      ExtraInfo    : @(isInBlackList),
                                      Disable      : @(isMe),
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"聊天",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"chat",
                                      ExtraInfo    : @(ColorButtonCellStyleBlue),
                                      Disable      : @(isMe),
                                      RowHeight    : @(60),
                                      ForbidSelect : @(YES),
                                      SepLeftEdge  : @(self.view.width),
                                      },
                                  @{
                                      Title        : @"删除好友",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"deleteFriend",
                                      ExtraInfo    : @(ColorButtonCellStyleRed),
                                      Disable      : @(!isMyFriend || isMe),
                                      RowHeight    : @(60),
                                      ForbidSelect : @(YES),
                                      SepLeftEdge  : @(self.view.width),
                                      },
                                  @{
                                      Title        : @"添加好友",
                                      CellClass    : @"NTESColorButtonCell",
                                      CellAction   : @"addFriend",
                                      ExtraInfo    : @(ColorButtonCellStyleBlue),
                                      Disable      : @(isMyFriend  || isMe),
                                      RowHeight    : @(60),
                                      ForbidSelect : @(YES),
                                      SepLeftEdge  : @(self.view.width),
                                      },
                                  ],
                          FooterTitle:@"",
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.texttf.text <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        return NO;
    }
    [self.view endEditing:YES];
    [self reuestDatasource];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(NSMutableArray*)dataarr{

    if (!_dataarr) {
        _dataarr = [NSMutableArray array];
    }

    return _dataarr;
}
@end
