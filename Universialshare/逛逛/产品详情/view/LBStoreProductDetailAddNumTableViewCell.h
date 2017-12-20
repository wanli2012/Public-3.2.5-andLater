//
//  LBStoreProductDetailAddNumTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBStoreProductDetailAddNumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;



@property (copy , nonatomic)void(^retureNum)(NSInteger num);

@end
