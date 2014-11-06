//
//  MVCoreDataManager.m
//  myVocabulary
//
//  Created by pkovewnikov on 25.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVCoreDataManager.h"
#import "NSManagedObject+ActiveRecord.h"


@interface MVCoreDataManager () {
    NSManagedObjectContext* _managedObjectContext;
}
@property (nonatomic) NSManagedObjectModel* managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@end

@implementation MVCoreDataManager

+ (instancetype)sharedCDManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}
- (id)init {
    NSAssert(NO, @"denied method");
    return nil;
}
- (id)initPrivate {
    self = [super init];
    return self;
}
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) return _managedObjectContext;
    
    if (self.persistentStoreCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"myVocabulary" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"myVocabulary.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (MVEntityWord*)findWordWithRussian:(NSString*)rusV english:(NSString*)engV {
    NSString* predStr;
    if(rusV) {
        predStr = [NSString stringWithFormat:@"russian == \"%@\"", rusV];
    }
    if(engV) {
        if(predStr) {
            predStr = [NSString stringWithFormat:@"%@ AND ", predStr];
        } else {
            predStr = @"";
        }
        predStr = [NSString stringWithFormat:@"%@english == \"%@\"", predStr, engV];
    }
    return [MVEntityWord find:predStr];
}
- (NSArray*)findWordsWithTextLike:(NSString*)textMatch withOrder:(MVCDMOrderType)order {
    NSString* predStr = [NSString stringWithFormat:@"russian CONTAINS[cd] '%@' OR english CONTAINS[cd] '%@'", textMatch, textMatch];
    return [MVEntityWord where:predStr order:[self makeOrderStringWithOrderType:order]];
}

- (NSArray*)findWordsWithOrder:(MVCDMOrderType)order {
    
    return [MVEntityWord allWithOrder:[self makeOrderStringWithOrderType:order]];
}

- (MVEntityWord*)createWordWithRussian:(NSString*)rusV english:(NSString*)engV {
    return [MVEntityWord create:@{@"russian" : rusV, @"english" : engV, @"creationDate" : [NSDate date]}];
}

#pragma mark - Service
- (NSString*)makeOrderStringWithOrderType:(MVCDMOrderType)oType {
    NSString* orderString;
    switch (oType) {
        case MVCDMOrderAlphabeticalEnglish:
            orderString = @"english, creationDate";
            break;
        case MVCDMOrderAlphabeticalRussian:
            orderString = @"russian, creationDate";
            break;
        case MVCDMOrderDate:
            orderString = @"russian";
            break;
    }
    return orderString;
}
@end
