//
//  LabelCell.h
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *identifyingLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

+ (id)createNewCell;

+ (NSString *) globalIdentifier;
- (NSString *) reuseIdentifier;

@end
