//
//  LoginIdentityView.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(NSInteger index);

@interface LoginIdentityView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (nonatomic, copy)block block;
@property (nonatomic, copy)NSArray *dataSoure;

@end
