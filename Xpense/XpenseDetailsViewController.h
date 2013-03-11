//
//  XpenseDetailsViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CategoryViewController.h"
#import "DatePickerViewController.h"

@interface XpenseDetailsViewController : UITableViewController <CategoryViewControllerDelegate, DatePickerViewControllerProtocol, UITextFieldDelegate>

- (id)initWithXpense:(NSManagedObjectID *)xpenseItemObjectID;

@end
