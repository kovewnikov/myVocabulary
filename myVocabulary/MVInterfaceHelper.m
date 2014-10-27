//
//  MVInterfaceHelper.m
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVInterfaceHelper.h"

@implementation MVInterfaceHelper

+(UIBarButtonItem*)createBarButtonWithType:(MVBarButtonType)btnType target:(id)target action:(SEL)action {
    
    UIImage* btnImg;
    switch (btnType) {
        case MVBarButtonSettings:
            btnImg = [UIImage imageNamed:@"navbar_icon_settings.png"];
            break;
        case MVBarButtonSorting:
            btnImg = [UIImage imageNamed:@"navbar_icon_sort.png"];
            break;
        case MVBarButtonSearch:
            btnImg = [UIImage imageNamed:@"navbar_icon_search.png"];
            break;
        case MVBarButtonBack:
            btnImg = [UIImage imageNamed:@"navbar_icon_back.png"];
            break;
    }
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView setBackgroundImage:btnImg forState:UIControlStateNormal];
    [btnView setFrame:CGRectMake(0, 0, 25, 25)];
    [btnView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    return item;
}
+ (void)roundCorners:(UIRectCorner)corners inView:(UIView*)view withRadii:(CGSize)radii {
    UIBezierPath *clippingPath = [UIBezierPath bezierPathWithRoundedRect:view.frame
                                                         byRoundingCorners:corners
                                                               cornerRadii:radii];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = clippingPath.CGPath;
    view.layer.mask = mask;
}


@end
