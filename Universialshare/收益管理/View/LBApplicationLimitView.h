//
//  LBApplicationLimitView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/7/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBApplicationLimitView : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UITextField *yzmTf;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;

@property (weak, nonatomic) IBOutlet UIButton *yzmbt;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UITextField *typeLabel;

@end
