//
//  MVCoreDataManager.h
//  myVocabulary
//
//  Created by pkovewnikov on 25.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"
#import "MVEntityWord.h"

enum {
    MVCDMOrderAlphabeticalEnglish   = 0,
    MVCDMOrderAlphabeticalRussian   = 1,
    MVCDMOrderDate                  = 2,
} typedef MVCDMOrderType;

@interface MVCoreDataManager : NSObject
+ (instancetype)sharedCDManager;

- (NSManagedObjectContext*)managedObjectContext;

- (MVEntityWord*)findWordWithRussian:(NSString*)rusV english:(NSString*)engV;
- (NSArray*)findWordsWithOrder:(MVCDMOrderType)order;
- (NSArray*)findWordsWithTextLike:(NSString*)textMatch withOrder:(MVCDMOrderType)order;

//creation
- (MVEntityWord*)createWordWithRussian:(NSString*)rusV english:(NSString*)engV;
@end
