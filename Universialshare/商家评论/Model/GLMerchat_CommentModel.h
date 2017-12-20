//
//  GLStoreProductCommentModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMerchat_CommentModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *comment;

@property (nonatomic, copy)NSString *addtime;

@property (nonatomic, copy)NSString *reply_time;

@property (nonatomic, copy)NSString *reply;

@property (nonatomic, copy)NSString *mark;

@property (nonatomic, copy)NSString *pic;

@property (nonatomic, copy)NSString *user_name;

@property (nonatomic, copy)NSString *is_comment;

@property (nonatomic, copy)NSString *comment_id;

@end
