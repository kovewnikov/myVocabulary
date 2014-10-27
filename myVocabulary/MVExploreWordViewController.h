//
//  MVExploreWordViewController.h
//  myVocabulary
//
//  Created by kovewnikov on 27.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MVExploreWordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;

- (void)configureWithFirstWord:(NSString*)word1 secondWord:(NSString*)word2;
@end
