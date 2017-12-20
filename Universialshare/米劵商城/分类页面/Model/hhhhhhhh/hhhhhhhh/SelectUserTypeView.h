//
//  SelectUserTypeView.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(NSInteger index);

@interface SelectUserTypeView : UIView

@property (nonatomic, copy)block block;

@property (nonatomic, copy)NSArray *dataSoure;

@end
