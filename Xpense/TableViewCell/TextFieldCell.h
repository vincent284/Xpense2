//
//  TextFieldCell.h
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;

+ (id)createNewCell;

+ (NSString *) globalIdentifier;
- (NSString *) reuseIdentifier;

@end
