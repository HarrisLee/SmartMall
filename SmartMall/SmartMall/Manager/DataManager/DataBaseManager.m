//
//  DataBaseManager.m
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "DataBaseManager.h"

static DataBaseManager *manager = nil;
static FMDatabaseQueue* queue;

static NSString *formatDB = @"yyyy-MM-dd HH:mm:ss";
const static NSString* normaltypestring = @"floatdoublelongcharshort";
const static NSString* blobtypestring = @"NSDataUIImage";

@implementation DataBaseManager

+ (DataBaseManager *)defaultDBManager {
    @synchronized(self)
    {
        if (manager == nil) {
            manager = [[DataBaseManager alloc] init];
        }
    }
    return manager;
}

- (void)createDataBase
{
    queue = [[FMDatabaseQueue alloc] initWithPath:DB_FILE_PATH];
}

- (void)createTableWith:(Class)objClass {
    
    [self createDataBase];
    
    NSDictionary *dic = [RMUtils getPropertyWithType:objClass withSuper:YES];
    NSArray *nameArray = [dic objectForKey:@"name"];
    NSArray *typeArray = [dic objectForKey:@"type"];
    NSMutableString* pars = [NSMutableString string];
    BaseDBModel *obj = [[objClass alloc] init];
    NSString *primaryKey = obj.primaryKey;
    for (int i=0; i<nameArray.count; i++) {
        NSString *name = [nameArray objectAtIndex:i];
        if ([name isEqualToString:primaryKey]) {
            [pars appendFormat:@"%@ %@ %@",[nameArray objectAtIndex:i],[self toDBType:[typeArray objectAtIndex:i]],@"PRIMARY KEY"];
        }
        else {
            [pars appendFormat:@"%@ %@",[nameArray objectAtIndex:i],[self toDBType:[typeArray objectAtIndex:i]]];
        }
        
        if(i+1 !=nameArray.count)
        {
            [pars appendString:@","];
        }
    }

    [queue inDatabase:^(FMDatabase* db) {
         NSString* createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",NSStringFromClass(objClass),pars];
         [db executeUpdate:createTable];
     }];
}

- (NSString *)toDBType:(NSString*)type {
    if([type isEqualToString:@"int"]) {
        return @"integer";
    }
    if ([normaltypestring rangeOfString:type].location != NSNotFound) {
        return @"float";
    }
    if ([blobtypestring rangeOfString:type].location != NSNotFound) {
        return @"blob";
    }
    return @"text";
}

- (BOOL)insertToDB:(id)model {
    Class objClass = [model class];
    [self createTableWith:objClass];
    __block BOOL execute = NO;
    [queue inDatabase:^(FMDatabase* db) {
         NSMutableArray* insertValues = [NSMutableArray array];
         NSString *insertSQL = [self insertStr:model insertValue:insertValues];
         execute = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
     }];
    return execute;
}

- (BOOL)insertData:(NSArray*)dataArray {
    BaseDBModel *model = [dataArray lastObject];
    Class objClass = [model class];
    [self createTableWith:objClass];
    __block BOOL execute = NO;
    [queue inTransaction:^(FMDatabase* db,BOOL *rollback) {
         for (BaseDBModel *model in dataArray) {
             NSMutableArray* insertValues = [NSMutableArray array];
             NSString *insertSQL = [self insertStr:model insertValue:insertValues];
             BOOL reslut = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
             if (!reslut) {
                 *rollback = YES;
                 return;
             }
         }
         execute = YES;
     }];
    return execute;
}

- (NSString*)insertStr:(id)model insertValue:(NSMutableArray*)insertValues {
    Class objClass = [model class];
    NSDictionary *dic = [RMUtils getPropertyWithType:objClass withSuper:YES];
    NSArray *nameArray = [dic objectForKey:@"name"];
    NSDate* date = [NSDate date];
    NSMutableString* insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString* insertValuesString = [NSMutableString stringWithCapacity:0];
    
    for (int i=0; i<nameArray.count; i++) {
        
        NSString* proname = [nameArray objectAtIndex:i];
        id value =[model valueForKey:proname];
        if (!value) {
            continue;
        }
        [insertKey appendFormat:@"%@,", proname];
        [insertValuesString appendString:@"?,"];
        if([value isKindOfClass:[UIImage class]]) {
            NSString* filename = [NSString stringWithFormat:@"DBFinder/img%f",[date timeIntervalSince1970]];
            [UIImageJPEGRepresentation(value, 1) writeToFile:[RMUtils documentsDirectotyPath:filename] atomically:YES];
            value = filename;
        }
        else if([value isKindOfClass:[NSData class]]) {
            NSString* filename = [NSString stringWithFormat:@"DBFinder/data%f",[date timeIntervalSince1970]];
            [value writeToFile:[RMUtils documentsDirectotyPath:filename] atomically:YES];
            value = filename;
        }
        else if([value isKindOfClass:[NSDate class]]) {
            value = [value stringWithDateFormat:formatDB];
        }
        [insertValues addObject:value];
    }
    [insertKey deleteCharactersInRange:NSMakeRange(insertKey.length - 1, 1)];
    [insertValuesString deleteCharactersInRange:NSMakeRange(insertValuesString.length - 1, 1)];
    NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",NSStringFromClass(objClass),insertKey,insertValuesString];
    return insertSQL;
}

- (BOOL)deleteModel:(BaseDBModel*)model
{
    Class objClass = [model class];
    [self createTableWith:objClass];
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase* db) {
         NSMutableArray* values = [NSMutableArray array];
         NSString* wherekey = [self dictionaryToSqlWhere:model.operateDic andValues:values];
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@",NSStringFromClass([model class]),wherekey];
         result = [db executeUpdate:delete withArgumentsInArray:values];
     }];
    return result;
}

- (BOOL)updateModel:(BaseDBModel*)model
{
    Class objClass = [model class];
    [self createTableWith:objClass];
    NSDictionary *dic = [RMUtils getPropertyWithType:objClass withSuper:YES];
    NSArray *nameArray = [dic objectForKey:@"name"];
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase* db) {
         NSDate* date = [NSDate date];
         NSMutableString* updateKey = [NSMutableString stringWithCapacity:0];
         NSMutableArray* updateValues = [NSMutableArray array];
         for (int i=0; i<nameArray.count; i++) {
             NSString* proname = [nameArray objectAtIndex:i];
             id value =[model valueForKey:proname];
             if (!value) {
                 continue;
             }
             [updateKey appendFormat:@" %@=?,", proname];
             if([value isKindOfClass:[UIImage class]]) {
                 NSString* filename = [NSString stringWithFormat:@"DBFinder/img%f",[date timeIntervalSince1970]];
                 [UIImageJPEGRepresentation(value, 1) writeToFile:[RMUtils documentsDirectotyPath:filename] atomically:YES];
                 value = filename;
             }
             else if([value isKindOfClass:[NSData class]]) {
                 NSString* filename = [NSString stringWithFormat:@"DBFinder/data%f",[date timeIntervalSince1970]];
                 [value writeToFile:[RMUtils documentsDirectotyPath:filename] atomically:YES];
                 value = filename;
             }
             else if([value isKindOfClass:[NSDate class]]) {
                 value = [value stringWithDateFormat:formatDB];
             }
             [updateValues addObject:value];
         }
         [updateKey deleteCharactersInRange:NSMakeRange(updateKey.length - 1, 1)];
         NSString* updateSQL;
         NSMutableArray* whereValues = [NSMutableArray array];
         NSString* wherekey = [self dictionaryToSqlWhere:model.operateDic andValues:whereValues];
         updateSQL = [NSString stringWithFormat:@"update %@ set %@ where %@",NSStringFromClass([model class]),updateKey,wherekey];
         [updateValues addObjectsFromArray:whereValues];
         result = [db executeUpdate:updateSQL withArgumentsInArray:updateValues];
     }];
    return result;
}

- (NSArray*)selectData:(BaseDBModel*)model orderBy:(NSString *)columeName offset:(int)offset count:(int)count
{
    Class modelClass = [model class];
    [self createTableWith:modelClass];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = [RMUtils getPropertyWithType:modelClass withSuper:YES];
    NSArray *nameArray = [dic objectForKey:@"name"];
    NSArray *typeArray = [dic objectForKey:@"type"];
    [queue inDatabase:^(FMDatabase* db) {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select rowid,* from %@ ",NSStringFromClass(modelClass)];
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
         if(model.operateDic !=nil&& model.operateDic.allKeys.count > 0)  {
             NSString* wherekey = [self dictionaryToSqlWhere:model.operateDic andValues:values];
             [query appendFormat:@" where %@",wherekey];
         }
         if(columeName != nil) {
             [query appendFormat:@" order by %@ ",columeName];
         }
         [query appendFormat:@" limit %d offset %d ",count,offset];
         
         FMResultSet* set =[db executeQuery:query withArgumentsInArray:values];
         
         while ([set next]) {
             BaseDBModel *bindingModel = [[modelClass alloc] init];
             bindingModel.rowId = [set intForColumnIndex:0];
             for (int i=0; i<nameArray.count; i++) {
                 NSString* columeName = [nameArray objectAtIndex:i];
                 NSString* columeType = [typeArray objectAtIndex:i];
                 if([@"intfloatdoublelongcharshort" rangeOfString:columeType].location != NSNotFound) {
                     [bindingModel setValue:[NSNumber numberWithDouble:[set doubleForColumn:columeName]] forKey:columeName];
                 }
                 else if([columeType isEqualToString:@"NSString"]) {
                     [bindingModel setValue:[set stringForColumn:columeName] forKey:columeName];
                 }
                 else if([columeType isEqualToString:@"UIImage"]) {
                     NSString* filename = [NSString stringWithFormat:@"DBFinder/%@",[set stringForColumn:columeName]];
                     if([RMUtils isFileExists:[RMUtils documentsDirectotyPath:filename]]) {
                         UIImage* img = [UIImage imageWithContentsOfFile:[RMUtils documentsDirectotyPath:filename]];
                         [bindingModel setValue:img forKey:columeName];
                     }
                 }
                 else if([columeType isEqualToString:@"NSDate"]) {
                     NSString *datestr = [set stringForColumn:columeName];
                     [bindingModel setValue:[datestr dateWithFormat:formatDB] forKey:columeName];
                 }
                 else if([columeType isEqualToString:@"NSData"]) {
                     NSString* filename = [NSString stringWithFormat:@"DBFinder/%@",[set stringForColumn:columeName]];
                     if([RMUtils isFileExists:[RMUtils documentsDirectotyPath:filename]]) {
                         NSData *data = [NSData dataWithContentsOfFile:[RMUtils documentsDirectotyPath:filename]];
                         [bindingModel setValue:data forKey:columeName];
                     }
                 }
             }
             [array addObject:bindingModel];
         }
         [set close];
     }];
    return array;
}

-(NSString*)dictionaryToSqlWhere:(NSDictionary*)dic andValues:(NSMutableArray*)values
{
    NSMutableString* wherekey = [NSMutableString stringWithCapacity:0];
    if(dic != nil && dic.count >0) {
        NSArray* keys = dic.allKeys;
        for (int i=0; i< keys.count;i++) {
            NSString* key = [keys objectAtIndex:i];
            id va = [dic objectForKey:key];
            if(va && [va isKindOfClass:[NSArray class]]) {
                NSArray* vlist = va;
                for (int j=0; j<vlist.count; j++) {
                    id subvalue = [vlist objectAtIndex:j];
                    if(wherekey.length > 0) {
                        if(j >0) {
                            [wherekey appendFormat:@" or %@ = ? ",key];
                        }
                        else {
                            [wherekey appendFormat:@" and %@ = ? ",key];
                        }
                    }
                    else {
                        [wherekey appendFormat:@" %@ = ? ",key];
                    }
                    [values addObject:subvalue];
                }
            }
            else if (va) {
                if(wherekey.length > 0) {
                    [wherekey appendFormat:@" and %@ = ? ",key];
                }
                else {
                    [wherekey appendFormat:@" %@ = ? ",key];
                }
                [values addObject:va];
            }
        }
    }
    return wherekey;
}

@end
