//
//  GLIntegralMallTopCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMallHotModel.h"

@protocol GLIntegralMallTopCellDelegete <NSObject>

-(void)tapgestureTag:(NSInteger)Tag;

@end

@interface GLIntegralMallTopCell : UITableViewCell

@property (nonatomic, strong)NSArray<GLMallHotModel *> *models;
@property (nonatomic, assign)id<GLIntegralMallTopCellDelegete> delegete;
@property (nonatomic, assign)NSInteger index;


@end
