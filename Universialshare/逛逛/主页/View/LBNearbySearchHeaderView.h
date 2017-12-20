//
//  LBNearbySearchHeaderView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLNearby_NearShopModel.h"

@interface LBNearbySearchHeaderView : UITableViewHeaderFooterView

@property (strong , nonatomic)GLNearby_NearShopModel *model;

@property (copy , nonatomic)void(^retureShopID)(NSString *shopid);

@end
