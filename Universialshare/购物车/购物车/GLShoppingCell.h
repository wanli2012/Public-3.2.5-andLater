//
//  GLShoppingCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLShoppingCartModel.h"

//@protocol GLShoppingCellDelegate <NSObject>
//
//- (void)changeStatus:(NSInteger)index;
//
//- (void)addNum:(NSInteger)index;
//
//- (void)reduceNum:(NSInteger)index;

//@end

@interface GLShoppingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (nonatomic, assign)NSInteger index;
//@property (nonatomic, assign)id <GLShoppingCellDelegate>delegate;

@property (nonatomic, strong)GLShoppingCartModel *model;
@end
