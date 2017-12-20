//
//  GLBuyBackChooseBankView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnChooseBlock)(NSString *str);

@interface GLBuyBackChooseBankView : UIView

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (nonatomic, copy)returnChooseBlock block;

@end
