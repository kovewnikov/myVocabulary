//
//  MVMyVocabularyViewController.h
//  myVocabulary
//
//  Created by pkovewnikov on 24.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MVMyVocabularyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *vocabularyTbl;
@property (weak, nonatomic) IBOutlet UIView *sortSettingsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortSettingsViewTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopOffset;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *darkOverlay;


@property (weak, nonatomic) IBOutlet UISegmentedControl *vocabularyDirectionSegm;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortTypeSegm;

- (IBAction)onSwitchSegment:(id)sender;

@end
