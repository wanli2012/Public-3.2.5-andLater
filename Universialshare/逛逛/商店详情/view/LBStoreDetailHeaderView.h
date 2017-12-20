//
//  LBStoreDetailHeaderView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBStoreDetailHeaderViewDelegete <NSObject>
-(void)checkmoreinfo:(NSInteger)index;
@end
@interface LBStoreDetailHeaderView : UITableViewHeaderFooterView

@property(nonatomic , strong) UIView *baseView;
@property(nonatomic , strong) UILabel *titleLb;//类型标题
@property(nonatomic , strong) UIButton *moreBt;//查看更多
@property (assign, nonatomic)id<LBStoreDetailHeaderViewDelegete> delegete;
@property (assign, nonatomic)NSInteger index;

@end
