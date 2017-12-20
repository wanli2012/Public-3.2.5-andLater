//
//  GLTwoButtonCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLTwoButtonCellDelegate <NSObject>

- (void)changeView:(NSInteger )tag;

@end

@interface GLTwoButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *image_textBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet UIView *Image_textV;
@property (weak, nonatomic) IBOutlet UIView *evaluateV;

@property (nonatomic, assign)id<GLTwoButtonCellDelegate>delegate;

@end
