//
//  MVUserSettings.h
//  myVocabulary
//
//  Created by pkovewnikov on 26.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    MVUSWordsSortingByName = 0,
    MVUSWordsSortingByDate = 1,
} typedef MVUSWordsSortingType;

enum {
    MVUSVocabularyDirectionEnToRu = 0,
    MVUSVocabularyDirectionRuToEn = 1,
} typedef MVUSVocabularyDirection;

enum {
    MVUSTranslateDirectionEnToRu = 0,
    MVUSTranslateDirectionRuToEn = 1,
} typedef MVUSTranslateDirection;

@interface MVUserSettings : NSObject
+ (instancetype)sharedSettings;

@property (nonatomic) MVUSTranslateDirection translateDirection;
@property (nonatomic) MVUSTranslateDirection wordsSortingType;
@property (nonatomic) MVUSVocabularyDirection vocabularyDirection;
@end
