//
//  LBPaysucessView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLShareView;

@interface LBPaysucessView : UIView

@property(nonatomic , strong) UILabel *pricelb;
@property(nonatomic , strong) UILabel *sucesslb;
@property(nonatomic , strong) GLShareView *shareV;

@property(nonatomic , copy) void(^weiboshre)();
@property(nonatomic , copy) void(^weixinshre)();
@property(nonatomic , copy) void(^friendshre)();

-(instancetype)initWithFrame:(CGRect)frame isHiddeShareView:(BOOL)ishidde;

@end
