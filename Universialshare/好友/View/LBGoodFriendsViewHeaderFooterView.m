//
//  LBGoodFriendsViewHeaderFooterView.m
//  正儿八金
//
//  Created by 四川三君科技有限公司 on 2017/9/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBGoodFriendsViewHeaderFooterView.h"
#import "LBGoodFriendsSectionView.h"

@interface LBGoodFriendsViewHeaderFooterView ()

@end
@implementation LBGoodFriendsViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self initsubsview];//_init表示初始化方法
    }
    
    return self;
}

-(void)initsubsview{

    LBGoodFriendsSectionView *view = [[NSBundle mainBundle]loadNibNamed:@"LBGoodFriendsSectionView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0,SCREEN_WIDTH , 50);
    view.autoresizingMask = UIViewAutoresizingNone;
    [view.messageBt addTarget:self action:@selector(clickmessageEvent:) forControlEvents:UIControlEventTouchUpInside];
     [view.MailListBt addTarget:self action:@selector(clickmailListEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:view];
    
    self.goodFriendsSectionView = view;

}

-(void)clickmessageEvent:(UIButton*)sender{

    if (self.currentBt  == self.goodFriendsSectionView.messageBt) {
        return;
    }
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(clickMessageEvent)]) {
        //代理存在且有这个方法
        [self.delegete clickMessageEvent];
    }

}

-(void)clickmailListEvent:(UIButton*)sender{

    if (self.currentBt  == self.goodFriendsSectionView.MailListBt) {
        return;
    }
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(clickMailListEvent)]) {
        //代理存在且有这个方法
        [self.delegete clickMailListEvent];
    }

}


@end
