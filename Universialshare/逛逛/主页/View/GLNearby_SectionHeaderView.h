//
//  GLNearby_SectionHeaderView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLNearby_SectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *subtitile;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@property (nonatomic, assign)NSInteger index;//0:推荐商家  1:附近商家

@end
