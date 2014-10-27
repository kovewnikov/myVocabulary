//
//  Helpers.m
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers
+ (NSString*)localizeWithKey:(NSString*)translationKey {
    //берем для всех языков кроме русского английскую локализацию
    static NSBundle* languageBundle;
    if(!languageBundle) {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ru"]) {
            languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"]];
        } else {
            languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
        }
    }
    NSString *s = [languageBundle localizedStringForKey:translationKey value:@"" table:nil];
    return s;
    
}
+ (void)logExceptionWithMessage:(NSString*)msgError {
#ifdef DEBUG
    NSLog(@"%@", msgError);
    @throw [NSException exceptionWithName:@"Exception log" reason:msgError userInfo:nil];
#else
    //TODO: реализовать отправку сомнительных ситуаций на сервер
#endif
    
}
+ (BOOL)isStringContainLetters:(NSString*)string {
    return [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound;
}
+ (BOOL)isStringContainRussianLetters:(NSString*)string {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[а-я]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    
    if (matches.count > 0)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)isStringContainEnglishLetters:(NSString *)string {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    
    if (matches.count > 0)
    {
        return YES;
    }
    return NO;
}
@end
