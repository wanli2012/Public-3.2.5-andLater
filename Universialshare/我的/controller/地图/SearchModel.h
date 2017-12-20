//
//  SearchModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface SearchModel : NSObject

@property (copy , nonatomic)NSString *name;

@property (copy , nonatomic)NSString *address;

@property (assign , nonatomic) CLLocationCoordinate2D pt;

@end
