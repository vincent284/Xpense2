//
//  XpenseItemCell.h
//  Xpense
//
//  Created by Vincent Nguyen on 10/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XpenseItemCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;

+ (id)createNewCell;

@end
