//
//  UIButton+DisabledBehaviour.m
//  myVocabulary
//
//  Created by pkovewnikov on 27.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "UIButton+DisabledBehaviour.h"

#import <objc/runtime.h>

static void * colorForDisabledStatePropertyKey = &colorForDisabledStatePropertyKey;
static void * colorForEnabledStatePropertyKey = &colorForEnabledStatePropertyKey;

//@interface UIButton ()
//@property (nonatomic, strong) UIColor *intermediateColor;
//@end

@implementation UIButton (DisabledBehaviour)
- (void)awakeFromNib {
    objc_setAssociatedObject(self, colorForEnabledStatePropertyKey, self.backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setColorForDisabledState:(UIColor*)color {
    objc_setAssociatedObject(self, colorForDisabledStatePropertyKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(self.enabled) {
        self.backgroundColor = objc_getAssociatedObject(self, colorForEnabledStatePropertyKey);
    } else {
        self.backgroundColor = objc_getAssociatedObject(self, colorForDisabledStatePropertyKey);
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if(self.enabled) {
        self.backgroundColor = objc_getAssociatedObject(self, colorForEnabledStatePropertyKey);
    } else {
        self.backgroundColor = objc_getAssociatedObject(self, colorForDisabledStatePropertyKey);
    }
}
@end
