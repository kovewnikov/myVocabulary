//
//  MVUserSettings.m
//  myVocabulary
//
//  Created by pkovewnikov on 26.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVUserSettings.h"

#define US_STORE_KEY_TRANSLATE_DIRECTION @"userSettings.translateDirection"
#define US_STORE_KEY_SORTING_TYPE @"userSettings.sortingType"
#define US_STORE_KEY_VOCABULARY_DIRECTION @"userSettings.vocabularyExploreDirection"

@implementation MVUserSettings
+ (instancetype)sharedSettings {
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
    if(self) {
        self.translateDirection = [[NSUserDefaults standardUserDefaults] integerForKey:US_STORE_KEY_TRANSLATE_DIRECTION];
        self.wordsSortingType = [[NSUserDefaults standardUserDefaults] integerForKey:US_STORE_KEY_SORTING_TYPE];
        self.vocabularyDirection = [[NSUserDefaults standardUserDefaults] integerForKey:US_STORE_KEY_VOCABULARY_DIRECTION];
    }
    return self;
}
- (void)setTranslateDirection:(MVUSTranslateDirection)translateDirection {
    if(self.translateDirection == translateDirection) {
        return;
    }
    _translateDirection = translateDirection;
    [[NSUserDefaults standardUserDefaults] setInteger:translateDirection forKey:US_STORE_KEY_TRANSLATE_DIRECTION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setWordsSortingType:(MVUSTranslateDirection)wordsSortingType {
    if(self.wordsSortingType == wordsSortingType) {
        return;
    }
    _wordsSortingType = wordsSortingType;
    [[NSUserDefaults standardUserDefaults] setInteger:wordsSortingType forKey:US_STORE_KEY_SORTING_TYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setVocabularyDirection:(MVUSVocabularyDirection)vocabularyDirection {
    if(self.vocabularyDirection == vocabularyDirection) {
        return;
    }
    _vocabularyDirection = vocabularyDirection;
    [[NSUserDefaults standardUserDefaults] setInteger:vocabularyDirection forKey:US_STORE_KEY_VOCABULARY_DIRECTION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
