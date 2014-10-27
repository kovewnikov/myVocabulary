//
//  MVRequestManager.m
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVRequestManager.h"
#import "Helpers.h"

#define YANDEX_API_KEY @"trnsl.1.1.20141023T191605Z.e5bbfecd22301e24.e042b3b34e92914f6c23ab89b998749c1f4258be"
#define YANDEX_BASE_URL @"https://translate.yandex.net/api/v1.5/tr.json/"
#define YANDEX_API_TRANSLATE_ACTION @"translate"

@implementation MVRequestManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static MVRequestManager* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[MVRequestManager alloc] initPrivate];
    });
    
    return sharedInstance;
}
+ (instancetype)manager {
    NSAssert(NO, @"denied method");
    return nil;
}
- (id)init {
    NSAssert(NO, @"denied method");
    return nil;
}
- (id)initPrivate {
    self = [super initWithBaseURL:[NSURL URLWithString:YANDEX_BASE_URL]];
    if(self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
    }
    return self;
}
- (void)requestTranslateFromRuToEnWithText:(NSString*)textForTranslate
                              successBlock:(void (^)(NSArray* translateVariations))successBlock
                                errorBlock:(void (^)(NSError* error))errorBlock{
    [self requestTranslateWithText:textForTranslate lang:@"ru-en" successBlock:successBlock errorBlock:errorBlock];
}
- (void)requestTranslateFromEnToRuWithText:(NSString*)textForTranslate
                              successBlock:(void (^)(NSArray* translateVariations))successBlock
                                errorBlock:(void (^)(NSError* error))errorBlock{
    [self requestTranslateWithText:textForTranslate lang:@"en-ru" successBlock:successBlock errorBlock:errorBlock];
}
- (void)requestTranslateWithText:(NSString*)textForTranslate
                            lang:(NSString*)lang
                    successBlock:(void (^)(NSArray* translateVariations))successBlock
                      errorBlock:(void (^)(NSError* error))errorBlock {
    NSDictionary* parameters = @{@"key" : YANDEX_API_KEY,
                                 @"text" : textForTranslate,
                                 @"lang" : lang,
                                 @"format" : @"plain",
                                 @"options" : @1};
    [self GET:YANDEX_API_TRANSLATE_ACTION
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if(successBlock) {
              successBlock([responseObject objectForKey:@"text"]);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary *userInfo = @{
                                     NSLocalizedDescriptionKey: localizeStr(@"ERROR_YANDEX_REQUEST_COMMON"),
                                     };
          NSError *newError = [NSError errorWithDomain:@"com.kovewnikov.myVocamulary"
                                               code:0
                                           userInfo:userInfo];
          errorBlock(newError);
      }];
}

@end
