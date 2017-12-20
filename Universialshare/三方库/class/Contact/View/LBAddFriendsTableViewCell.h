//
//  LBAddFriendsTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBAddFriendsModel.h"

@protocol LBAddFriendsDelegete <NSObject>

-(void)addfriends:(NSInteger)index;

@end

@interface LBAddFriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *IDLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (assign , nonatomic)id<LBAddFriendsDelegete> delegete;
@property (assign , nonatomic)NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (strong , nonatomic)LBAddFriendsModel *model;

@end
