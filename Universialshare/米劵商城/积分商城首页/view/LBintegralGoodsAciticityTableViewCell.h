//
//  LBintegralGoodsAciticityTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface LBintegralGoodsAciticityTableViewCell : UITableViewCell

@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;

@property (strong , nonatomic)NSIndexPath *indexpath;

@property (weak, nonatomic) IBOutlet UIImageView *imageone;

-(void)loadimage:(NSString*)imageurl isGif:(NSString*)gifstr;

@end
