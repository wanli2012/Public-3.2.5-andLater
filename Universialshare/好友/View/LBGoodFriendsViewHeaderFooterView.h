//
//  LBGoodFriendsViewHeaderFooterView.h
//  正儿八金
//
//  Created by 四川三君科技有限公司 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBGoodFriendsSectionView.h"

@protocol LBGoodFriendsViewHeaderFooterViewdelegete <NSObject>

-(void)clickMessageEvent;
-(void)clickMailListEvent;

@end

@interface LBGoodFriendsViewHeaderFooterView : UITableViewHeaderFooterView

@property (assign , nonatomic)id<LBGoodFriendsViewHeaderFooterViewdelegete> delegete;
@property (strong , nonatomic)LBGoodFriendsSectionView *goodFriendsSectionView;
@property (strong , nonatomic)UIButton *currentBt;

@end
