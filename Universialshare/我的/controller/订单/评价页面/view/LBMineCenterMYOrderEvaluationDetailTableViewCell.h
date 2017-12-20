//
//  LBMineCenterMYOrderEvaluationDetailTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "orderEvaluationModel.h"

@protocol LBMineCenterMYOrderEvaluationDetailDelegete <NSObject>

-(void)tapgestureshowmoreinfo:(NSInteger)index;
-(void)ishidekeyboard;
-(void)submitevaluationinfo:(NSInteger)index;

@end

@interface LBMineCenterMYOrderEvaluationDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *submitbt;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starview;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *limiteLb;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;

@property (assign, nonatomic)id<LBMineCenterMYOrderEvaluationDetailDelegete> delegete;
@property (assign, nonatomic)NSInteger index;
@property (strong, nonatomic)orderEvaluationModel *orderEvaluationModel;

@end
