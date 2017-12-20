//
//  GLSet_MaskVeiw.h
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GLSet_QuitView.h"

@interface GLSet_MaskVeiw : UIView

@property(nonatomic,strong)UIView *bgView;

@property (nonatomic, strong) UIView  *contentView;

-(void)showViewWithContentView:(UIView *)contentView;

- (void)show;

@end
