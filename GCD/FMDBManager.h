//
//  FMDBManager.h
//  GCD
//
//  Created by 张源远 on 2018/7/11.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import <Foundation/Foundation.h>

@class mediaModel;

@interface FMDBManager : NSObject

+(FMDBManager *)shareManager;

-(void)insertMediaData:(mediaModel *)model;
-(NSArray<mediaModel*>*)selectAllMediaTableData;
-(void)deletaMediaTableData:(NSArray *)dataArr;

@end
