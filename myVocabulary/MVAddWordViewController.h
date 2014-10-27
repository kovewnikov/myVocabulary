//
//  MVAddWordViewController.h
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVKeyboardEventsNotificator.h"

@interface MVAddWordViewController : UIViewController<UITextViewDelegate, MVKeyboardAppearHideListener>
@property (weak, nonatomic) IBOutlet UIImageView *inputTxtBg;
@property (weak, nonatomic) IBOutlet UITextView *inputTxtV;
@property (weak, nonatomic) IBOutlet UIImageView *outputTxtBg;
@property (weak, nonatomic) IBOutlet UITextView *outputTxtV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *translateBlockBtmOffsetCnstr;
@property (weak, nonatomic) IBOutlet UIView *darkOverlay;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *refreshImg;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;

@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *translDirSegm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewTopOffsetCnstr;


@property (weak, nonatomic) IBOutlet UIButton *addWordBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeWordBtn;

- (IBAction)onRemoveWordTap:(id)sender;
- (IBAction)onAddWordTap:(id)sender;
- (IBAction)onSwitchTranslateDirection:(id)sender;

@end
