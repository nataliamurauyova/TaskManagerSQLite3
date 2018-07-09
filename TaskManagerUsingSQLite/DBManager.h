//
//  DBManager.h
//  TaskManagerUsingSQLite
//
//  Created by Наташа on 06.07.18.
//  Copyright © 2018 Наташа. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject

@property(strong,nonatomic) NSMutableArray *arrColumnNames;
@property(nonatomic) int affectedRows;
@property(nonatomic) long long lastInsertedRowID;

-(instancetype)initWithFileName:(NSString*) dbFileName;

-(void)runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable;
-(NSArray*)loadDataFromDB: (NSString*)query;
-(void)executeQuery:(NSString*)query;

@end
