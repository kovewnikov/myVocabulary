//
//  UIAlertView+BlockHandler.h
//  myVocabulary
//
//  Created by pkovewnikov on 26.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewDismissedHandler) (NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel);

@interface UIAlertView (BlockHandler) 
- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissHandler:(UIAlertViewDismissedHandler)dHandler cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles,... NS_REQUIRES_NIL_TERMINATION;
@end
