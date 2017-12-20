//
//  MineCollectionHeaderV.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@protocol MineCollectionHeaderVDelegete <NSObject>

-(void)tapgestureHeadimage;
-(void)tapgesturecheckMoreinfo;

@end

@interface MineCollectionHeaderV : UICollectionReusableView

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (assign , nonatomic)id<MineCollectionHeaderVDelegete> delegete;

-(void)refreshDataInfo;

@end
