//
//  GLBuyBackChooseCardController.h
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

// 一会要传的值为NSString类型
typedef void (^newBlock)(NSString *cardNumber);

@interface GLBuyBackChooseCardController : UIViewController
//typedef void (^ReturnBlock)(GLBankCardModel *model);
// 声明block属性
@property (nonatomic, copy) newBlock returnBlock;


@end
