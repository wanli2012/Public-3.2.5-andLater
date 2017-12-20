//
//  GLNearby_Model.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLNearby_Model : NSObject

+(GLNearby_Model*)defaultUser;

//经纬度
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSArray *trades;

@property (nonatomic, copy)NSString *city_id;
@property (nonatomic, copy)NSString *city;

//@property (nonatomic, copy)NSString *longitude;
//@property (nonatomic, copy)NSString *trade_id;


@end
