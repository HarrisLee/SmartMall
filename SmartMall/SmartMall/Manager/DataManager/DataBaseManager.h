//
//  DataBaseManager.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RMUtils.h"
#import "BaseDBModel.h"

#define DB_FILE_PATH        [RMUtils documentsFilePath:@"SmartMall.db"]

@interface DataBaseManager : NSObject

+(DataBaseManager *)defaultDBManager;

- (void)createTableWith:(Class)objClass;
- (BOOL)insertToDB:(BaseDBModel*)model;
- (BOOL)insertData:(NSArray*)dataArray;
- (BOOL)deleteModel:(BaseDBModel*)model;
- (BOOL)updateModel:(BaseDBModel*)model;
- (NSArray*)selectData:(BaseDBModel*)model orderBy:(NSString *)columeName offset:(int)offset count:(int)count;

@end
