//
//  LBRiceShopDataBase.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface LBRiceShopDataBase : NSObject
@property(nonatomic,strong)FMDatabase *dataBase;
//创建表
+(LBRiceShopDataBase *)greateTableOfFMWithTableName:(NSString *)tableName;
//插入数据
-(void)insertOfFMWithDataArray:(NSArray*)dataArr;
//插入某条数据
-(void)insertOfFMWithstring:(NSString*)string;
//删除数据
-(void)deleteAllDataOfFMDB;
//删除某条数据
-(void)deleteOneDataOfFMDB:(NSString*)str;
//查询数据
-(NSArray*)queryAllDataOfFMDB;
//判断表中是否存在数据
-(BOOL)isDataInTheTable;
@end
