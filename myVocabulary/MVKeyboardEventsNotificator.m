//
//  MVKeyboardEventsNotificator.m
//  myVocabulary
//
//  Created by kovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVKeyboardEventsNotificator.h"

@interface MVKeyboardEventsNotificator ()
@property (nonatomic)NSMutableArray *keyboardListeners;
@end

@implementation MVKeyboardEventsNotificator
+ (instancetype)sharedNotificator
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}
- (id)init {
    NSAssert(NO, @"private");
    return nil;
}
- (id)initPrivate {
    self = [super init];
    if(self) {
        self.keyboardListeners = [NSMutableArray array];
        [self registerForKeyboardNotifications];
    }
    return self;
}
- (void)dealloc {
    [self freeKeyboardNotifications];
}

- (void)addKeyboardListener:(id<MVKeyboardAppearHideListener>)listener {
    
    [self.keyboardListeners addObject:listener];
}
- (void)removeKeyboardListenersObject:(id<MVKeyboardAppearHideListener>)listener {
    [self.keyboardListeners removeObject:listener];
}
-(void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) freeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void) keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    for(id<MVKeyboardAppearHideListener> kListener in self.keyboardListeners) {
        [kListener keyboardWillShowWithAnimationCurve:animationCurve duration:animationDuration keyboardRect:keyboardFrame];
    }
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    for(id<MVKeyboardAppearHideListener> kListener in self.keyboardListeners) {
        [kListener keyboardWillHideWithAnimationCurve:animationCurve duration:animationDuration keyboardRect:keyboardFrame];
    }
}
@end
