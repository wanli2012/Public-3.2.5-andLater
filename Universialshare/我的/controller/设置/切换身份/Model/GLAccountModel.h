//
//  GLAccountModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/8/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface GLAccountModel : NSObject

@property(nonatomic,strong)FMDatabase *dataBase;

//创建表
+(GLAccountModel *)greateTableOfFMWithTableName:(NSString *)tableName;
//插入数据
-(void)insertOfFMWithDataArray:(NSArray*)dataArr;
//删除特定数据
-(void)deleteAllDataOfFMDB:(NSString *)userName;
//删除所有数据
-(void)deleteAllDataOfFMDB;
//查询数据
-(NSArray*)queryAllDataOfFMDB;
//查询特定数据
-(NSDictionary *)queryDataOfFMDBWithName:(NSString *)name;
//判断表中是否存在数据
-(BOOL)isDataInTheTable;

@end
