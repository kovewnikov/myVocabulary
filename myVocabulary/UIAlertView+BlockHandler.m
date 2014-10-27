//
//  UIAlertView+BlockHandler.m
//  myVocabulary
//
//  Created by pkovewnikov on 26.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "UIAlertView+BlockHandler.h"

#import <objc/runtime.h>


@interface UIAlertViewDismissHelper : NSObject<UIAlertViewDelegate>
@property (copy, nonatomic) UIAlertViewDismissedHandler dismissHandler;
@end

@implementation UIAlertViewDismissHelper

- (id)initWithDismissHandler:(UIAlertViewDismissedHandler)dHandler {
    if((self = [super init])) {
        self.dismissHandler = dHandler;
    }
    return self;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.dismissHandler) {
        self.dismissHandler(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex], buttonIndex == alertView.cancelButtonIndex);
    }
    self.dismissHandler = nil;
}
@end

static char kDismissHelperKey;

@interface UIAlertView ()
@property (nonatomic) UIAlertViewDismissHelper* dismissHelper;
@end

@implementation UIAlertView (BlockHandler)

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissHandler:(UIAlertViewDismissedHandler)dHandler cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitles,... {
    
    UIAlertViewDismissHelper *dHelper = [[UIAlertViewDismissHelper alloc] initWithDismissHandler:dHandler];
    
    self = [self initWithTitle:title message:message delegate:dHelper cancelButtonTitle:cancelTitle otherButtonTitles:otherTitles, nil];
    if (self) {
        [self setDismissHelper:dHelper];
    }
    return self;
    
}
- (void)setDismissHelper:(UIAlertViewDismissHelper *)dismissHelper {
    objc_setAssociatedObject(self, &kDismissHelperKey, dismissHelper, OBJC_ASSOCIATION_RETAIN);
}
- (UIAlertViewDismissHelper*)dismissHelper {
    return objc_getAssociatedObject(self, &kDismissHelperKey);
}

@end
