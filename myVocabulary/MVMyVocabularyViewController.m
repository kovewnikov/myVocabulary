//
//  MVMyVocabularyViewController.m
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVMyVocabularyViewController.h"
#import "MVCoreDataManager.h"
#import "MVEntityWord.h"
#import "MVVocabularyCell.h"
#import "MVUserSettings.h"
#import "MVInterfaceHelper.h"
#import "Helpers.h"
#import "UIAlertView+BlockHandler.h"
#import "MVExploreWordViewController.h"

#define CELL_ID @"MyVocabularyCell"

enum {
    MVExtraViewsVisibilitySearchBarVisible  = 0,
    MVExtraViewsVisibilitySortingBarVisible = 1,
    MVExtraViewsVisibilityNothingVisible    = 2,
} typedef MVExtraViewsVisibilityMode;



@interface MVMyVocabularyViewController () {
    MVExtraViewsVisibilityMode _curExtraViewsVisibility;
}
@property (nonatomic) NSArray* allWords;
@property (nonatomic) NSArray* filteredWords;
@end

@implementation MVMyVocabularyViewController

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
    //set navbar
    self.navigationItem.rightBarButtonItem = [MVInterfaceHelper createBarButtonWithType:MVBarButtonSorting
                                                                                 target:self
                                                                                 action:@selector(onSortingSettingsTap:)];
    self.navigationItem.leftBarButtonItem = [MVInterfaceHelper createBarButtonWithType:MVBarButtonSearch
                                                                                 target:self
                                                                                 action:@selector(onSearchTap:)];
    //set table
    self.vocabularyTbl.delegate = self;
    self.vocabularyTbl.dataSource = self;
    
    //set overlay
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(onOverlayTap:)];
    [self.darkOverlay addGestureRecognizer:singleFingerTap];
    
    //set segments
    [self.vocabularyDirectionSegm setSelectedSegmentIndex:[[MVUserSettings sharedSettings]vocabularyDirection]];
    [self.sortTypeSegm setSelectedSegmentIndex:[[MVUserSettings sharedSettings] wordsSortingType]];
    
    //set searchbar
    self.searchBar.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self needReloadTable];
    [self switchCurExtraViewsVisibility:MVExtraViewsVisibilityNothingVisible animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)switchCurExtraViewsVisibility:(MVExtraViewsVisibilityMode)newVisMode animated:(BOOL)animated {
    if(_curExtraViewsVisibility == newVisMode) {
        return;
    }
    switch (newVisMode) {
        case MVExtraViewsVisibilityNothingVisible:
            if(animated) {
                [self.view layoutIfNeeded];
                self.sortSettingsViewTopOffset.constant = -self.sortSettingsView.frame.size.height;
                self.searchBarTopOffset.constant = -self.searchBar.frame.size.height;
                __weak MVMyVocabularyViewController* wself = self;
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     [wself.view layoutIfNeeded];
                                     wself.darkOverlay.layer.opacity = 0;
                                 } completion:^(BOOL finished) {
                                     wself.darkOverlay.hidden = YES;
                                     _curExtraViewsVisibility = newVisMode;
                                 }];
            } else {
                self.sortSettingsViewTopOffset.constant = -self.sortSettingsView.frame.size.height;
                self.searchBarTopOffset.constant = -self.searchBar.frame.size.height;
                self.darkOverlay.hidden = YES;
                self.darkOverlay.layer.opacity = 0;
                _curExtraViewsVisibility = newVisMode;
            }
            [self.searchBar resignFirstResponder];
            break;
            
        case MVExtraViewsVisibilitySearchBarVisible:
            
            if(animated) {
                [self.view layoutIfNeeded];
                self.sortSettingsViewTopOffset.constant = -self.sortSettingsView.frame.size.height;
                __weak MVMyVocabularyViewController* wself = self;
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     [wself.view layoutIfNeeded];
                                     
                                 } completion:^(BOOL finished) {
                                     [self.view layoutIfNeeded];
                                     wself.searchBarTopOffset.constant = 0;
                                     wself.darkOverlay.hidden = NO;
                                     [UIView animateWithDuration:0.5
                                                      animations:^{
                                                          [wself.view layoutIfNeeded];
                                                          wself.darkOverlay.layer.opacity = 1;
                                                          
                                                      } completion:^(BOOL finished) {
                                                          _curExtraViewsVisibility = newVisMode;
                                                      }];
                                 }];
            } else {
                self.sortSettingsViewTopOffset.constant = -self.sortSettingsView.frame.size.height;
                self.searchBarTopOffset.constant = 0;
                self.darkOverlay.hidden = NO;
                self.darkOverlay.layer.opacity = 1;
                _curExtraViewsVisibility = newVisMode;
            }
            [self.searchBar becomeFirstResponder];
            break;
        case MVExtraViewsVisibilitySortingBarVisible:
            if(animated) {
                [self.view layoutIfNeeded];
                self.searchBarTopOffset.constant = -self.searchBar.frame.size.height;
                __weak MVMyVocabularyViewController* wself = self;
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     [wself.view layoutIfNeeded];
                                 } completion:^(BOOL finished) {
                                     [self.view layoutIfNeeded];
                                     wself.sortSettingsViewTopOffset.constant = 0;
                                     wself.darkOverlay.hidden = NO;
                                     [UIView animateWithDuration:0.5
                                                      animations:^{
                                                          [wself.view layoutIfNeeded];
                                                          wself.darkOverlay.layer.opacity = 1;
                                                          
                                                      } completion:^(BOOL finished) {
                                                          _curExtraViewsVisibility = newVisMode;
                                                      }];
                                 }];
            } else {
                self.sortSettingsViewTopOffset.constant = 0;
                self.searchBarTopOffset.constant = -self.searchBar.frame.size.height;
                self.darkOverlay.hidden = NO;
                self.darkOverlay.layer.opacity = 1;
                _curExtraViewsVisibility = newVisMode;
            }
            [self.searchBar resignFirstResponder];
            break;
    }
    
}
- (void)needReloadTable {
    MVCDMOrderType oType;
    if([[MVUserSettings sharedSettings] wordsSortingType] == MVUSWordsSortingByDate) {
        oType = MVCDMOrderDate;
    } else {
        oType = [[MVUserSettings sharedSettings] vocabularyDirection] == MVUSVocabularyDirectionEnToRu ? MVCDMOrderAlphabeticalEnglish : MVCDMOrderAlphabeticalRussian;
    }
    
    if([Helpers isStringContainLetters:self.searchBar.text]) {
        self.filteredWords = [[MVCoreDataManager sharedCDManager] findWordsWithTextLike:self.searchBar.text withOrder:oType];
    } else {
        self.filteredWords = nil;
        self.allWords = [[MVCoreDataManager sharedCDManager] findWordsWithOrder:oType];
    }
    
    [self.vocabularyTbl reloadData];
}
#pragma mark - UI handlers
- (void)onSortingSettingsTap:(id)sender {
    if(_curExtraViewsVisibility != MVExtraViewsVisibilitySortingBarVisible) {
        [self switchCurExtraViewsVisibility:MVExtraViewsVisibilitySortingBarVisible animated:YES];
    } else {
        [self switchCurExtraViewsVisibility:MVExtraViewsVisibilityNothingVisible animated:YES];
    }
}
- (void)onSearchTap:(id)sender {
    if(_curExtraViewsVisibility != MVExtraViewsVisibilitySearchBarVisible) {
        [self switchCurExtraViewsVisibility:MVExtraViewsVisibilitySearchBarVisible animated:YES];
    } else {
        [self switchCurExtraViewsVisibility:MVExtraViewsVisibilityNothingVisible animated:YES];
    }
}
- (void)onOverlayTap:(UITapGestureRecognizer *)recognizer {
    [self switchCurExtraViewsVisibility:MVExtraViewsVisibilityNothingVisible animated:YES];
}

- (IBAction)onSwitchSegment:(id)sender {
    if(sender == self.vocabularyDirectionSegm) {
        [[MVUserSettings sharedSettings] setVocabularyDirection:[((UISegmentedControl*)sender) selectedSegmentIndex]];
    } else if(sender == self.sortTypeSegm) {
        [[MVUserSettings sharedSettings] setWordsSortingType:[((UISegmentedControl*)sender) selectedSegmentIndex]];
    }
    [self needReloadTable];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.filteredWords) {
        return self.filteredWords.count;
    } else {
        return self.allWords.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVEntityWord* word;
    if(self.filteredWords) {
        word = [self.filteredWords objectAtIndex:indexPath.row];
    } else {
        word = [self.allWords objectAtIndex:indexPath.row];
    }
    
    MVVocabularyCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if([MVUserSettings sharedSettings].vocabularyDirection == MVUSVocabularyDirectionEnToRu) {
        [cell configureWithLeftWord:word.english rightWord:word.russian];
    } else {
        [cell configureWithLeftWord:word.russian rightWord:word.english];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MVEntityWord* word;
    if(self.filteredWords) {
        word = [self.filteredWords objectAtIndex:indexPath.row];
    } else {
        word = [self.allWords objectAtIndex:indexPath.row];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:localizeStr(@"ALERT_TITLE_REALLY_DELETE_WORD")
                                                    message:localizeStr(@"ALERT_DESCRIPTION_REALLY_DELETE_WORD")
                                             dismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                                                 switch (selectedIndex) {
                                                     case 0:
                                                         [word delete];
                                                         [word save];
                                                         [self needReloadTable];
                                                         break;
                                                     case 1:
                                                         [self.vocabularyTbl setEditing:NO animated:YES];
                                                 }
                                             }
                                          cancelButtonTitle:localizeStr(@"YES_WORD")
                                          otherButtonTitles:localizeStr(@"NO_WORD"), nil];
    [alert show];
    
    
}
#pragma mark - UISearchBarDelegate implementation
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self needReloadTable];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController class] == [MVExploreWordViewController class]) {
        MVVocabularyCell *cell = sender;
        MVExploreWordViewController *next = segue.destinationViewController;
        [next configureWithFirstWord:cell.leftLbl.text secondWord:cell.rightLbl.text];
    }
}



@end
