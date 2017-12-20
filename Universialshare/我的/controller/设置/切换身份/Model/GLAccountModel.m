//
//  GLAccountModel.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLAccountModel.h"

@implementation GLAccountModel

//创建表
+(GLAccountModel*)greateTableOfFMWithTableName:(NSString *)tableName{
    GLAccountModel *dataPeristent = [[GLAccountModel alloc]init];
    //创建数据库对象
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",tableName]];
    //创建数据库
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    //设置缓存提高效率
    [database setShouldCacheStatements:YES];
    if([database open]){
        BOOL result = [database executeUpdate:@"CREATE TABLE IF NOT EXISTS NEW_LIST (SID integer PRIMARY KEY AUTOINCREMENT, headPic text NOT NULL, name text NOT NULL, phone text NOT NULL, password text NOT NULL, groupID text NOT NULL);"];
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
//插入数据
-(void)insertOfFMWithDataArray:(NSArray *)dataArr{
    if ([_dataBase open]) {
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull model, NSUInteger index, BOOL * _Nonnull stop) {
            NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO NEW_LIST('%@','%@','%@','%@','%@')VALUES('%@','%@','%@','%@','%@')",@"headPic",@"name",@"phone",@"password",@"groupID",model[@"headPic"],model[@"name"],model[@"phone"],model[@"password"],model[@"groupID"]];
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

//删除数据(特定一条)
-(void)deleteAllDataOfFMDB:(NSString *)userName{
    
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from NEW_LIST where name = '%@'",userName];
        BOOL res = [_dataBase executeUpdate:deleteSql];
        if (!res) {
            NSLog(@"删除失败");
        } else {
            NSLog(@"删除成功");
        }
        [_dataBase close];
    }
    
}
//删除数据 (所有数据)
-(void)deleteAllDataOfFMDB{
    
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from NEW_LIST"];
        BOOL res = [_dataBase executeUpdate:deleteSql];
        if (!res) {
//            NSLog(@"删除失败");
        } else {
//            NSLog(@"删除成功");
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
            
            NSString *headPic = [resultSet stringForColumn:@"headPic"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *phone = [resultSet stringForColumn:@"phone"];
            NSString *password = [resultSet stringForColumn:@"password"];
            NSString *groupID = [resultSet stringForColumn:@"groupID"];
            
            NSDictionary *dic=@{@"headPic":headPic,@"name":name,@"phone":phone,@"password":password,@"groupID":groupID};
            
            [dataArr addObject:dic];
        }
    }
    [_dataBase close];
    return [dataArr copy];
}
//查询特定数据
-(NSDictionary *)queryDataOfFMDBWithName:(NSString *)name{

    NSDictionary *dic;
    // 1.执行查询语句
    if ([_dataBase open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"SELECT * FROM NEW_LIST where name = '%@'",name];
        FMResultSet *resultSet = [_dataBase executeQuery:deleteSql];

//        FMResultSet *resultSet = [_dataBase executeQuery:@"SELECT * FROM NEW_LIST where name = '%@'",name];
        
        // 2.遍历结果
//        while ([resultSet next]) {
        
            NSString *headPic = [resultSet stringForColumn:@"headPic"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *phone = [resultSet stringForColumn:@"phone"];
            NSString *password = [resultSet stringForColumn:@"password"];
            NSString *groupID = [resultSet stringForColumn:@"groupID"];
            
           dic = @{@"headPic":headPic,@"name":name,@"phone":phone,@"password":password,@"groupID":groupID};
            
//        }
    }
    [_dataBase close];
    
    return dic;
}

//判断表中是否存在数据
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
