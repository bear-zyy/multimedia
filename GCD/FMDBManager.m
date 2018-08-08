//
//  FMDBManager.m
//  GCD
//
//  Created by 张源远 on 2018/7/11.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDB.h"
#import "mediaModel.h"

@interface FMDBManager ()
{
    FMDatabase * _db;
}

@end

@implementation FMDBManager

+(FMDBManager *)shareManager{
    static FMDBManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        _db = [[FMDatabase alloc] initWithPath:[self getDocumentPath]];
    }
    
    if ([_db open]) {
        [self creatTable];
    }
    return self;
}

-(void)creatTable{
    NSString * sql = @"create table if not exists mediaTable (data blob , type int , ID text , playUrl text)";// PRIMARY KEY NOT NULL
    [_db executeUpdate:sql];
}

-(void)insertMediaData:(mediaModel *)model{
    
    if ([_db open]) {
        
        NSString * sql = @"insert into 'mediaTable' ('data' , 'type' , 'ID' , 'playUrl') values( ? , ? , ? , ?)";
        
        [_db executeUpdate:sql, model.data , @(model.type) , model.ID , model.playUrl];
    }
    
}

-(NSArray<mediaModel *>*)selectAllMediaTableData{
    
    NSMutableArray<mediaModel *> * dataArr = [NSMutableArray array];
    
    if ([_db open]) {
        
        NSString * sql = @"select * from mediaTable";
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            mediaModel * media = [[mediaModel alloc] init];
            media.ID = [rs stringForColumn:@"ID"];
            media.data = [rs dataForColumn:@"data"];
            media.type = [rs intForColumn:@"type"];
            media.playUrl = [rs stringForColumn:@"playUrl"];
            [dataArr addObject:media];
        }
    }
    
    return dataArr;
}

-(void)deletaMediaTableData:(NSArray *)dataArr{
    
}

-(NSString *)getDocumentPath
{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:@"mediaData.sqlite"];
    return filePath;
}

@end
