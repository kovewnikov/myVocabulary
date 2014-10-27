//
//  MVExploreWordViewController.m
//  myVocabulary
//
//  Created by kovewnikov on 27.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import "MVExploreWordViewController.h"
#import "MVInterfaceHelper.h"

@interface MVExploreWordViewController ()
@property (nonatomic) NSString* word1;
@property (nonatomic) NSString* word2;
@end

@implementation MVExploreWordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[MVInterfaceHelper createBarButtonWithType:MVBarButtonBack target:self action:@selector(onBackTap:)];
    [self fillLabelsAndTitle];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureWithFirstWord:(NSString*)word1 secondWord:(NSString*)word2 {
    self.word1 = word1;
    self.word2 = word2;
    if([self isViewLoaded]) {
        [self fillLabelsAndTitle];
    }
}
- (void)fillLabelsAndTitle {
    
    if(self.word1) {
        self.navigationItem.title = self.word1;
        self.lbl1.text = self.word1;
    }
    if(self.word2) {
        self.lbl2.text = self.word2;
    }
}
#pragma mark - Actions
- (void)onBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
