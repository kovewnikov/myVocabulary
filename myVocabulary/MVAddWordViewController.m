//
//  MVAddWordViewController.m
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVAddWordViewController.h"
#import "MVRequestManager.h"
#import "MVInterfaceHelper.h"
#import "Helpers.h"
#import "MVEntityWord.h"
#import "MVCoreDataManager.h"
#import "UIAlertView+BlockHandler.h"
#import "MVUserSettings.h"
#import "UIButton+DisabledBehaviour.h"

#define SETTINGS_VIEW_HEIGHT 74

enum {
    MVAWViewExpectAddingMode    = 0,
    MVAWViewJustAddedMode       = 1,
    MVAWViewImpossibleAddMode   = 2,
} typedef MVAWViewMode;

enum {
    MVAWViewReadyStatus                 = 0,
    MVAWViewExecutingTranslateStatus    = 1,
    MVAWViewErrorStatus                 = 2,
} typedef MVAWViewStatus;

@interface MVAddWordViewController ()
@property (nonatomic) NSTimer* timerForTranslating;
@property (nonatomic) BOOL isSettingsVisible;
@property (nonatomic) int initialTranslateBlockBtmOffset;
@property (nonatomic) MVAWViewMode currentViewMode;
@property (nonatomic) MVAWViewStatus currentViewStatus;
@property (nonatomic) MVEntityWord* justAddedWord;
@end



@implementation MVAddWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [MVInterfaceHelper createBarButtonWithType:MVBarButtonSettings
                                                                                 target:self
                                                                                 action:@selector(onSettingsTap:)];
    self.initialTranslateBlockBtmOffset = self.translateBlockBtmOffsetCnstr.constant;

    //set text views
    [self.inputTxtBg setImage:[self.inputTxtBg.image stretchableImageWithLeftCapWidth:16 topCapHeight:16]];
    [self.outputTxtBg setImage:[self.outputTxtBg.image stretchableImageWithLeftCapWidth:16 topCapHeight:16]];
    self.inputTxtV.delegate = self;
    
    //SET VIEW MODE & STATUS
    
    _currentViewMode = -1;
    [self setCurrentViewMode:MVAWViewImpossibleAddMode];
    _currentViewStatus = -1;
    [self setCurrentViewStatus:MVAWViewReadyStatus];
    //SET SETTINGS VIEW
    [MVInterfaceHelper roundCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                             inView:self.settingsView
                          withRadii:CGSizeMake(7, 7)];
    [self.translDirSegm setSelectedSegmentIndex:[[MVUserSettings sharedSettings] translateDirection]];
    
    self.isSettingsVisible = YES;
    [self hideSettingsView:NO];
    //set overlay
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(onOverlayTap:)];
    [self.darkOverlay addGestureRecognizer:singleFingerTap];
    //set btn
    [self.addWordBtn setColorForDisabledState:[UIColor grayColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReadyForStart:) name:NOTIFICATION_READY_FOR_START object:nil];
    [[MVKeyboardEventsNotificator sharedNotificator] addKeyboardListener:self];
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_READY_FOR_START object:nil];
    [[MVKeyboardEventsNotificator sharedNotificator] removeKeyboardListenersObject:self];
    [super viewDidDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mard - Service
- (BOOL)isValidForTranslating:(NSString*)word {
    if([word isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
#pragma mark - Actions
- (void)tryToExecuteTranslate:(NSTimer*)timer {
    if(self.timerForTranslating == timer) {
        [self.timerForTranslating invalidate];
        self.timerForTranslating = nil;
    }
    void (^successBlock)(NSArray*) = ^void (NSArray *translateVariations) {
        NSString* outputText = [translateVariations componentsJoinedByString:@", "];
        self.outputTxtV.text = outputText;
        [self setCurrentViewMode:MVAWViewExpectAddingMode];
        [self setCurrentViewStatus:MVAWViewReadyStatus];
    };
    void (^errorBlock)(NSError*) = ^void (NSError *error) {
        self.outputTxtV.text = @"";
        [self setCurrentViewMode:MVAWViewImpossibleAddMode];
        [self setCurrentViewStatus:MVAWViewErrorStatus];
        [self.errorLbl setText:[NSString stringWithFormat:@"%@: %@", localizeStr(@"ERROR_WORD"), error.localizedDescription]];
    };
    
    
    if(![self isValidForTranslating:self.inputTxtV.text]) {
        self.outputTxtV.text = @"";
        [self setCurrentViewMode:MVAWViewImpossibleAddMode];
        [self setCurrentViewStatus:MVAWViewReadyStatus];

        return;
    }
    if([[MVUserSettings sharedSettings] translateDirection]==MVUSTranslateDirectionRuToEn) {
        [[MVRequestManager sharedManager]
         requestTranslateFromRuToEnWithText:self.inputTxtV.text
         successBlock:successBlock
         errorBlock:errorBlock];
    } else {
        [[MVRequestManager sharedManager]
         requestTranslateFromEnToRuWithText:self.inputTxtV.text
         successBlock:successBlock
         errorBlock:errorBlock];
    }
    
}


- (void)showSettingsView:(BOOL)animated {
    if(self.isSettingsVisible) {
        return;
    }
    [self.view layoutIfNeeded];
    self.settingsViewTopOffsetCnstr.constant = 0;
    if(animated) {
        self.darkOverlay.hidden = NO;
        __weak MVAddWordViewController* wself = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [wself.view layoutIfNeeded];
                             wself.darkOverlay.layer.opacity = 1;
                         } completion:^(BOOL finished) {
                             wself.isSettingsVisible = YES;
                         }];
    } else {
        self.isSettingsVisible = YES;
        self.darkOverlay.hidden = NO;
        self.darkOverlay.layer.opacity = 1;
    }
}
- (void)hideSettingsView:(BOOL)animated {
    if(!self.isSettingsVisible) {
        return;
    }
    [self.view layoutIfNeeded];
    self.settingsViewTopOffsetCnstr.constant = -SETTINGS_VIEW_HEIGHT;
    if(animated) {
        __weak MVAddWordViewController* wself = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [wself.view layoutIfNeeded];
                             wself.darkOverlay.layer.opacity = 0;
                         } completion:^(BOOL finished) {
                             wself.isSettingsVisible = NO;
                             wself.darkOverlay.hidden = YES;
                         }];
    } else {
        self.isSettingsVisible = NO;
        self.darkOverlay.hidden = YES;
        self.darkOverlay.layer.opacity = 0;
    }
}
- (void)toggleSettingsView:(BOOL)animated {
    self.isSettingsVisible ? [self hideSettingsView:animated] : [self showSettingsView:animated];
}

- (void)hideKeyboard {
    [self.inputTxtV resignFirstResponder];
}

- (void)setCurrentViewMode:(MVAWViewMode)currentViewMode {
    if(_currentViewMode == currentViewMode) {
        return;
    }
    _currentViewMode = currentViewMode;
    switch (_currentViewMode) {
        case MVAWViewExpectAddingMode:
            self.addWordBtn.hidden = NO;
            self.addWordBtn.enabled = YES;
            self.removeWordBtn.hidden = YES;
            break;
        case MVAWViewImpossibleAddMode:
            self.addWordBtn.hidden = NO;
            self.addWordBtn.enabled = NO;
            self.removeWordBtn.hidden = YES;
            break;
        case MVAWViewJustAddedMode:
            self.addWordBtn.hidden = YES;
            self.removeWordBtn.hidden = NO;
            break;
    }
}

- (void)setCurrentViewStatus:(MVAWViewStatus)currentViewStatus {
    if(self.currentViewStatus == currentViewStatus) {
        return;
    }
    _currentViewStatus = currentViewStatus;
    switch (_currentViewStatus) {
        case MVAWViewReadyStatus:
            self.arrowImg.hidden = NO;
            self.refreshImg.hidden = YES;
            self.errorLbl.hidden = YES;
            break;
            
        case MVAWViewExecutingTranslateStatus: {
            self.arrowImg.hidden = YES;
            self.refreshImg.hidden = NO;
            self.errorLbl.hidden = YES;
            break;
        }
        case MVAWViewErrorStatus:
            self.arrowImg.hidden = YES;
            self.refreshImg.hidden = YES;
            self.errorLbl.hidden = NO;
            break;
    }
}

#pragma mark - UI event handlers
- (void)onSettingsTap:(id)sender {
    
    [self toggleSettingsView:YES];
    [self hideKeyboard];
}

- (IBAction)onRemoveWordTap:(id)sender {
    if(!self.justAddedWord) {
        excLog(@"alert! unexpectable situation");
        return;
    }
    [self.justAddedWord delete];
    [self.justAddedWord save];
    [self setCurrentViewMode:MVAWViewExpectAddingMode];
#ifdef DEBUG
    NSLog(@"log");
#endif
}

- (IBAction)onAddWordTap:(id)sender {
    NSString *errorMsg;
    
    switch ([MVUserSettings sharedSettings].translateDirection) {
        case MVUSTranslateDirectionEnToRu:
            if([[MVCoreDataManager sharedCDManager] findWordWithRussian:self.outputTxtV.text english:self.inputTxtV.text]) {
                errorMsg = localizeStr(@"ERROR_ADD_ALREADY_ADDED");
            }
            if(![Helpers isStringContainEnglishLetters:self.inputTxtV.text]) {
                errorMsg = localizeStr(@"ERROR_ADD_ADDED_WORD_NOT_MATCH_PICKED_LANG");
            }
            break;
            
        case MVUSTranslateDirectionRuToEn:
            if([[MVCoreDataManager sharedCDManager] findWordWithRussian:self.inputTxtV.text english:self.outputTxtV.text]) {
                errorMsg = localizeStr(@"ERROR_ADD_ALREADY_ADDED");
            }
            if(![Helpers isStringContainRussianLetters:self.inputTxtV.text]) {
                errorMsg = localizeStr(@"ERROR_ADD_ADDED_WORD_NOT_MATCH_PICKED_LANG");
            }
            break;
    }
    if(errorMsg) {
        UIAlertView* erAlert = [[UIAlertView alloc]
                                initWithTitle:localizeStr(@"ERROR_WORD")
                                message:errorMsg
                                dismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {}
                                cancelButtonTitle:localizeStr(@"OK_WORD")
                                otherButtonTitles: nil];
        [erAlert show];
    } else {
        NSString* rusV;
        NSString* engV;
        if([MVUserSettings sharedSettings].translateDirection == MVUSTranslateDirectionEnToRu) {
            rusV = self.outputTxtV.text;
            engV = self.inputTxtV.text;
        } else {
            engV = self.outputTxtV.text;
            rusV = self.inputTxtV.text;
        }
        self.justAddedWord = [[MVCoreDataManager sharedCDManager] createWordWithRussian:rusV english:engV];
        [self.justAddedWord save];
        [self setCurrentViewMode:MVAWViewJustAddedMode];
    }
}

- (IBAction)onSwitchTranslateDirection:(id)sender {
    [[MVUserSettings sharedSettings] setTranslateDirection:((UISegmentedControl*)sender).selectedSegmentIndex];
    [self setCurrentViewStatus:MVAWViewExecutingTranslateStatus];
    [self setCurrentViewMode:MVAWViewImpossibleAddMode];
    [self tryToExecuteTranslate:nil];
}
- (void)onOverlayTap:(UITapGestureRecognizer *)recognizer {
    [self hideSettingsView:YES];
}
#pragma mark - UITextViewDelegate implementation
- (void)textViewDidChange:(UITextView *)textView {
    if(textView == self.inputTxtV) {
        if(self.timerForTranslating) {
            [self.timerForTranslating invalidate];
            self.timerForTranslating = nil;
        }
        self.timerForTranslating = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tryToExecuteTranslate:) userInfo:nil repeats:NO];
        [self setCurrentViewStatus:MVAWViewExecutingTranslateStatus];
        [self setCurrentViewMode:MVAWViewImpossibleAddMode];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self hideKeyboard];
        return NO;
    }
    return YES;
}

#pragma mark KeyboardAppearHideListener

-(void)keyboardWillShowWithAnimationCurve:(UIViewAnimationCurve)animCurve
                                 duration:(NSTimeInterval)duration
                             keyboardRect:(CGRect)kRect {
    [self.view layoutIfNeeded];
    self.translateBlockBtmOffsetCnstr.constant = kRect.size.height-self.tabBarController.tabBar.frame.size.height;
    __weak MVAddWordViewController* wself = self;
    [UIView animateWithDuration:duration
                     animations:^{
                         [wself.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];

    
}
-(void)keyboardWillHideWithAnimationCurve:(UIViewAnimationCurve)animCurve
                                 duration:(NSTimeInterval)duration
                             keyboardRect:(CGRect)kRect {
    [self.view layoutIfNeeded];
    self.translateBlockBtmOffsetCnstr.constant = self.initialTranslateBlockBtmOffset;
    __weak MVAddWordViewController* wself = self;
    [UIView animateWithDuration:duration
                     animations:^{
                         [wself.view layoutIfNeeded];
                     } completion:^(BOOL finished) {}];

}

@end
