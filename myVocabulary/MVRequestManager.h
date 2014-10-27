//
//  MVRequestManager.h
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface MVRequestManager :  AFHTTPRequestOperationManager
+ (instancetype)sharedManager;

- (void)requestTranslateFromRuToEnWithText:(NSString*)textForTranslate
                              successBlock:(void (^)(NSArray* translateVariations))successBlock
                                errorBlock:(void (^)(NSError* error))errorBlock;

- (void)requestTranslateFromEnToRuWithText:(NSString*)textForTranslate
                              successBlock:(void (^)(NSArray* translateVariations))successBlock
                                errorBlock:(void (^)(NSError* error))errorBlock;
@end
