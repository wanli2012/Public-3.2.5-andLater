//
//  GLStoreProductCommentCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMerchat_CommentModel.h"

@protocol  GLMerchat_CommentCellDelegate <NSObject>

- (void)comment:(NSInteger)index;

@end

@interface GLMerchat_CommentCell : UITableViewCell

@property (nonatomic, strong)GLMerchat_CommentModel *model;

@property (nonatomic, assign)id<GLMerchat_CommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property (nonatomic, assign)NSInteger index;

@end
