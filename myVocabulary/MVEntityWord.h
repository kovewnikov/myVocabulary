//
//  MVEntityWord.h
//  myVocabulary
//
//  Created by pkovewnikov on 26.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MVEntityWord : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSString * russian;

@end
