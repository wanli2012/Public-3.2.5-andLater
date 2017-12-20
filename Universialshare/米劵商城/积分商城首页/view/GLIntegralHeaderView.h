//
//  GLIntegralHeaderView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GLIntegralHeaderViewdelegete <NSObject>

-(void)clickJimpGoodsClassify:(NSInteger)section;

@end
@interface GLIntegralHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLb;
@property (nonatomic, assign)id<GLIntegralHeaderViewdelegete> delegate;
@property (nonatomic, assign)NSInteger section;

@end
