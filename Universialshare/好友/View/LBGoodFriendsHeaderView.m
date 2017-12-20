//
//  LBGoodFriendsHeaderView.m
//  正儿八金
//
//  Created by 四川三君科技有限公司 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBGoodFriendsHeaderView.h"

@interface LBGoodFriendsHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation LBGoodFriendsHeaderView

-(void)layoutSubviews{
    [super layoutSubviews];
    
        self.searchView.layer.cornerRadius = 3;
        self.searchView.clipsToBounds = YES;

}

@end
