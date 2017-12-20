//
//  LoadWaitView.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadWaitView : UIView

@property (assign , nonatomic)BOOL  isTap;//判断是否可以点击 默认是可以的

+(LoadWaitView *)addloadview:(CGRect)rect tagert:(id)tagert;//加载

-(void)removeloadview;//移除

@end
