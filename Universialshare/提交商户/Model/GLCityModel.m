//
//  GLCityModel.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLCityModel.h"

@implementation GLCityModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [Data class]};
}
@end
@implementation Data

+ (NSDictionary *)objectClassInArray{
    return @{@"city" : [City class]};
}

@end


@implementation City

+ (NSDictionary *)objectClassInArray{
    return @{@"country" : [Country class]};
}

@end


@implementation Country

@end


