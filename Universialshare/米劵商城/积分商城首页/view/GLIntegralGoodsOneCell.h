//
//  GLIntegralGoodsOneCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLIntegralGoodsOnedelegete <NSObject>

-(void)clickGoodsdetail:(NSString*)goodsid;

@end
@interface GLIntegralGoodsOneCell : UITableViewCell

@property (strong, nonatomic)NSArray *dataArr;
@property (nonatomic, assign)id<GLIntegralGoodsOnedelegete> delegete;
@property (nonatomic, assign)NSInteger index;

-(void)refreshDataSorce:(NSArray*)arr;

@property (nonatomic, assign)CGFloat goodTwoH;
@end
