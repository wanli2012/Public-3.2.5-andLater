//
//  LBIncomeChooseHeaderFooterView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBIncomeChooseHeaderdelegete <NSObject>

-(void)clickonlinebutton;
-(void)clickunderlinebutton;

@end

@interface LBIncomeChooseHeaderFooterView : UIView

@property(nonatomic , strong) UIView *lineview;
@property(nonatomic , strong) UIButton *onLineBt;//线上
@property(nonatomic , strong) UIButton *underLineBt;//线下

@property(nonatomic , assign) id<LBIncomeChooseHeaderdelegete> delegete;

@end
