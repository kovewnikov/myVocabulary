//
//  MVKeyboardEventsNotificator.h
//  myVocabulary
//
//  Created by kovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MVKeyboardAppearHideListener <NSObject>

-(void)keyboardWillShowWithAnimationCurve:(UIViewAnimationCurve)animCurve
                                 duration:(NSTimeInterval)duration
                             keyboardRect:(CGRect)rect;
-(void)keyboardWillHideWithAnimationCurve:(UIViewAnimationCurve)animCurve
                                 duration:(NSTimeInterval)duration
                             keyboardRect:(CGRect)rect;

@end


@interface MVKeyboardEventsNotificator : NSObject
+ (instancetype)sharedNotificator;

- (void)addKeyboardListener:(id<MVKeyboardAppearHideListener>)listener;
- (void)removeKeyboardListenersObject:(id<MVKeyboardAppearHideListener>)listener;
@end
