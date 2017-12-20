//
//  GLCityModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data,City,Country;
@interface GLCityModel : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<Data *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface Data : NSObject

@property (nonatomic, copy) NSString *province_code;

@property (nonatomic, strong) NSArray<City *> *city;

@property (nonatomic, copy) NSString *province_name;

@end

@interface City : NSObject

@property (nonatomic, copy) NSString *city_name;

@property (nonatomic, copy) NSString *city_code;

@property (nonatomic, strong) NSArray<Country *> *country;

@end

@interface Country : NSObject

@property (nonatomic, copy) NSString *country_code;

@property (nonatomic, copy) NSString *country_name;

@end

