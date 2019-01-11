//
//  HZFMDBManager.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/10.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZFMDBManager.h"
#import "FMDB.h"
#import "HZRecordModel.h"

@interface HZFMDBManager ()
@property (nonatomic, strong) FMDatabase *record_db;
@end

@implementation HZFMDBManager

- (void)saveRecordName:(NSString *)name{
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"HZRecordData.db"];
    _record_db = [FMDatabase databaseWithPath:dbPath];
    if ([_record_db open]) {
        
    }else{
        return;
    }
    
    NSString *createTableSql = @"create table if not exists HZRecordFMDBTable('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'recordID' TEXT,'recordName' TEXT)";
    
    BOOL result = [_record_db executeUpdate:createTableSql];
    if (result) {
        NSLog(@"创建成功");
    }else{
        NSLog(@"创建失败");
        return;
    }
    
    BOOL result2 = [_record_db executeUpdate:@"INSERT INTO HZRecordFMDBTable(recordID,recordName) VALUES (?,?);",[self getTimeInterval],name];
    
    if (result2) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    
    [_record_db close];
}


- (BOOL)deleteRecordForID:(NSString *)recordID{
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"HZRecordData.db"];
    _record_db = [FMDatabase databaseWithPath:dbPath];
    if ([_record_db open]) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
        return NO;
    }
    
    BOOL result = [_record_db executeUpdate:@"DELETE form HZRecordFMDBTable WHERE recordID = ?;",recordID];
    if (result) {
        NSLog(@"删除成功");
        [_record_db close];
        return YES;
    }else{
        NSLog(@"删除失败");
        [_record_db close];
        return NO;
    }
}


- (NSString *)queryRecordNameForID:(NSString *)recordID{
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"HZRecordData.db"];
    _record_db = [FMDatabase databaseWithPath:dbPath];
    if ([_record_db open]) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    
    FMResultSet *resultSet = [_record_db executeQuery:@"SELECT * FROM HZRecordFMDBTable WHERE recordID=?",recordID];
    
    while ([resultSet next]) {
        NSString *recordName = [resultSet stringForColumn:@"recordName"];
        [_record_db close];
        return recordName;
    }
    [_record_db close];
    return @"";
}


- (NSArray<HZRecordModel *> *)queryAllRecord{
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"HZRecordData.db"];
    _record_db = [FMDatabase databaseWithPath:dbPath];
    if ([_record_db open]) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    
    FMResultSet *resultSet = [_record_db executeQuery:@"SELECT * FROM HZRecordFMDBTable"];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    while ([resultSet next]) {
        HZRecordModel *recordModel = [[HZRecordModel alloc] init];
        NSString *recordName = [resultSet stringForColumn:@"recordName"];
        NSString *recordID = [resultSet stringForColumn:@"recordID"];
        recordModel.recordID = recordID;
        recordModel.recordTitle = recordName;
        [tempArr addObject:recordModel];
    }
    
    return tempArr;
}



/**
 获取时间戳

 @return 返回时间戳
 */
- (NSString *)getTimeInterval{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger time = interval;
    NSString *timestamp = [NSString stringWithFormat:@"%zd",time];
    return timestamp;
}
@end
