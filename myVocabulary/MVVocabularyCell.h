//
//  MVVocabularyCell.h
//  myVocabulary
//
//  Created by pkovewnikov on 26.10.14.
//  Copyright (c) 2014 pkovewnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVEntityWord.h"

@interface MVVocabularyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
- (void)configureWithLeftWord:(NSString*)lWord rightWord:(NSString*)rWord;
@end
