//
//  LBAddFriendsTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddFriendsTableViewCell.h"

@implementation LBAddFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
//添加好友
- (IBAction)addfriend:(UIButton *)sender {
    
    [self.delegete addfriends:self.index];
}

-(void)setModel:(LBAddFriendsModel *)model{
    _model = model;
    self.IDLb.text = [NSString stringWithFormat:@"用户ID:%@",_model.user_name];
    self.nameLB.text = [NSString stringWithFormat:@"用户名:%@",_model.truename];
    self.typeLb.text = [NSString stringWithFormat:@"用户身份:%@",_model.group_name];
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:@"dtx_icon"]];
    
    BOOL isMe          = [_model.im_id isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount];
    BOOL isMyFriend    = [[NIMSDK sharedSDK].userManager isMyFriend:_model.im_id];
    
    if (_model.isrequst == NO) {
        
        if (isMe) {
            self.addbutton.hidden = YES;
        }else{
            self.addbutton.hidden = NO;
            if (isMyFriend) {
                self.addbutton.backgroundColor = [UIColor darkGrayColor];
                self.addbutton.userInteractionEnabled = NO;
                [self.addbutton setTitle:@"已添加" forState:UIControlStateNormal];
            }else{
                self.addbutton.backgroundColor = TABBARTITLE_COLOR;
                self.addbutton.userInteractionEnabled = YES;
                [self.addbutton setTitle:@"添  加" forState:UIControlStateNormal];
            }
        }
        
    }else{
    
        
        if (isMe) {
            self.addbutton.hidden = YES;
        }else{
            self.addbutton.hidden = NO;
           
        self.addbutton.backgroundColor = [UIColor darkGrayColor];
        self.addbutton.userInteractionEnabled = NO;
        [self.addbutton setTitle:@"待对方同意" forState:UIControlStateNormal];
            
       }
    }

}
@end
