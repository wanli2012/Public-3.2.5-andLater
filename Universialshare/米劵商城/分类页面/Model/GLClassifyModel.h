//
//  GLClassifyModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/8/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBclassifyTypeModel : NSObject

@property (nonatomic, copy)NSString *catename;
@property (nonatomic, copy)NSString *cate_id;
@property (nonatomic, copy)NSString *pid;
@property (assign , nonatomic)BOOL iscollection;

@end

@interface GLClassifyModel : NSObject

@property (nonatomic, copy)NSString *cate_id;

@property (nonatomic, copy)NSString *catename;

@property (nonatomic, copy)NSString *pid;//父级id

@property (nonatomic, copy)NSArray<LBclassifyTypeModel *> *son;//父级id

@end

