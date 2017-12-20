//
//  GLCityChooseController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^choseCityBlock)(NSString *str,NSString *city_id);

@interface GLCityChooseController : UIViewController

@property (nonatomic, strong)NSMutableArray *models;

@property (nonatomic, copy)choseCityBlock block;

@end
