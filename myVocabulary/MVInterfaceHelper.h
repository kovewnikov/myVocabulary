//
//  MVInterfaceHelper.h
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    MVBarButtonSettings = 0,
    MVBarButtonSearch   = 1,
    MVBarButtonSorting  = 2,
    MVBarButtonBack     = 3,
} typedef MVBarButtonType;

@interface MVInterfaceHelper : NSObject

+(UIBarButtonItem*)createBarButtonWithType:(MVBarButtonType)btnType target:(id)target action:(SEL)action;
+ (void)roundCorners:(UIRectCorner)corners inView:(UIView*)view withRadii:(CGSize)radii;
@end
