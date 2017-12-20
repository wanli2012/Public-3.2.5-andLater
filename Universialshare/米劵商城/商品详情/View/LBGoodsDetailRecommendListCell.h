//
//  LBGoodsDetailRecommendListCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LBGoodsDetailRecommendListDelegate <NSObject>

-(void)clickcheckDetail:(NSString*)goodid;

@end

@interface LBGoodsDetailRecommendListCell : UITableViewCell

-(void)refreshDataSorce:(NSArray*)arr;
@property (nonatomic ,assign) CGFloat shiftGoodsH;
@property (nonatomic, assign)id<LBGoodsDetailRecommendListDelegate> delegate;

@end
