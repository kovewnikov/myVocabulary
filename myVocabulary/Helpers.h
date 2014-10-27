//
//  Helpers.h
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define localizeStr(key) [Helpers localizeWithKey:key]
#define excLog(...) [Helpers logExceptionWithMessage:__VA_ARGS__]


@interface Helpers : NSObject
+ (NSString*)localizeWithKey:(NSString*)translationKey;
+ (void)logExceptionWithMessage:(NSString*)msgError;

+ (BOOL)isStringContainLetters:(NSString*)string;
+ (BOOL)isStringContainRussianLetters:(NSString*)string;
+ (BOOL)isStringContainEnglishLetters:(NSString *)string;
@end
