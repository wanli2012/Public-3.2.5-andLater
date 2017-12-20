//
//  LBRiceShopDataBase.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRiceShopDataBase.h"

@implementation LBRiceShopDataBase
+(LBRiceShopDataBase*)greateTableOfFMWithTableName:(NSString *)tableName{
    LBRiceShopDataBase *dataPeristent = [[LBRiceShopDataBase alloc]init];
    //创建数据库对象
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",tableName]];
    //创建数据库
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    //设置缓存提高效率
    [database setShouldCacheStatements:YES];
    if([database open]){
        BOOL result = [database executeUpdate:@"CREATE TABLE IF NOT EXISTS NEW_LIST (SID integer PRIMARY KEY AUTOINCREMENT, recoder text NOT NULL);"];
        if (result){
            //NSLog(@"%@",@"创建表成功");
        }else{
            //NSLog(@"创建表失败");
        }
    }
    dataPeristent.dataBase = database;
    [database close];
    return dataPeristent;
}

-(void)insertOfFMWithDataArray:(NSArray *)dataArr{
    if ([_dataBase open]) {
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull model, NSUInteger index, BOOL * _Nonnull stop) {
            NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO NEW_LIST('%@')VALUES('%@')",@"recoder",model[@"recoder"]];
            BOOL res = [_dataBase executeUpdate:insertSql];
            if (res) {
                //NSLog(@"插入成功");
            }else{
                //NSLog(@"插入失败");
            }
        }];
    }
    [_dataBase close];
}

-(void)insertOfFMWithstring:(NSString *)string{
    
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"insert into NEW_LIST (recoder) values(?)"];
        BOOL res = [_dataBase executeUpdate:deleteSql,string];
        if (!res) {
            //NSLog(@"删除失败");
        } else {
            //NSLog(@"删除成功");
        }
        [_dataBase close];
    }
    
    
}

-(void)deleteAllDataOfFMDB{
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from NEW_LIST"];
        BOOL res = [_dataBase executeUpdate:deleteSql];
        if (!res) {
            //NSLog(@"删除失败");
        } else {
            //NSLog(@"删除成功");
        }
        [_dataBase close];
    }
    
}

-(void)deleteOneDataOfFMDB:(NSString *)str{
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from NEW_LIST WHERE recoder = ?"];
        BOOL res = [_dataBase executeUpdate:deleteSql,str];
        if (!res) {
            //NSLog(@"删除失败");
        } else {
            //NSLog(@"删除成功");
        }
        [_dataBase close];
    }
    
}

//查询数据
-(NSArray *)queryAllDataOfFMDB{
    NSMutableArray *dataArr = [@[]mutableCopy];
    // 1.执行查询语句
    if ([_dataBase open]) {
        FMResultSet *resultSet = [_dataBase executeQuery:@"SELECT * FROM NEW_LIST"];
        // 2.遍历结果
        while ([resultSet next]) {
            NSString *annum = [resultSet stringForColumn:@"recoder"];
            
            NSDictionary *dic=@{@"recoder":annum};
            [dataArr addObject:dic];
        }
    }
    [_dataBase close];
    return [dataArr copy];
}

-(BOOL)isDataInTheTable{
    BOOL isHaveData = NO;
    // 1.执行查询语句
    if ([_dataBase open]) {
        FMResultSet *resultSet = [_dataBase executeQuery:@"SELECT * FROM NEW_LIST"];
        while ([resultSet next]) {
            isHaveData = YES;
        }
    }
    [_dataBase close];
    return isHaveData;
    
    
}

@end
