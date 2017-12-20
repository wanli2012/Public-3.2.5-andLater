//
//  LBViewProtocolViewController.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBViewProtocolViewController : UIViewController

@property(nonatomic,strong)NSString *webUrl;
/**导航条标题*/
@property(nonatomic,strong)NSString *navTitle;

@property(nonatomic,assign)BOOL  loadLocalBool;//是否加载本地数据。默认为NO

@end
