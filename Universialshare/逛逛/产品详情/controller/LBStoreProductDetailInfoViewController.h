//
//  LBStoreProductDetailInfoViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBStoreProductDetailInfoViewController : UIViewController

@property(nonatomic , strong)NSString *goodId;
@property(nonatomic , strong)NSString *goodname;
@property(nonatomic , strong)NSString *storename;
@property(nonatomic , assign)BOOL isnotice;//判断是否需要发送取消收藏通知 yes 发送


@end
