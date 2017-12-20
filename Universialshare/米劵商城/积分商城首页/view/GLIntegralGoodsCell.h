//
//  GLIntegralGoodsCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLIntegralGoodsCellDelegate <NSObject>

-(void)clickcheckDetail:(NSString*)goodid;

@end

@interface GLIntegralGoodsCell : UITableViewCell

@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic, assign)int index;

@property (nonatomic, assign)id<GLIntegralGoodsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

-(void)refreshDatasource:(NSArray*)arr;

@property (nonatomic, assign)CGFloat goodOneH;


@end
