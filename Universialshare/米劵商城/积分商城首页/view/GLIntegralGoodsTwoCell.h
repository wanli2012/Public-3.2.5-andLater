//
//  GLIntegralGoodsTwoCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLIntegralGoodsTwodelegete <NSObject>

-(void)clickCheckGoodsinfo:(NSString*)goodid;

@end
@interface GLIntegralGoodsTwoCell : UITableViewCell

@property (strong, nonatomic)NSArray *dataArr;
@property (nonatomic, assign)id<GLIntegralGoodsTwodelegete> delegate;

-(void)refreshdataSource:(NSArray*)arr;

@property (assign , nonatomic)CGFloat beautfHeight;//缓存精品推荐高度

@end
