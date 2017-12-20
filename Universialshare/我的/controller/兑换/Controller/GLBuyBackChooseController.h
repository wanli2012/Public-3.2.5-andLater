//
//  GLBuyBackChooseController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLBankCardModel;

typedef void (^ReturnBlock)(GLBankCardModel *model);

@interface GLBuyBackChooseController : UIViewController

@property (nonatomic, copy) ReturnBlock returnBlock;

- (void)returnModel:(ReturnBlock)block;

@end
