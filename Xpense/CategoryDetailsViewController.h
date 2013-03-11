//
//  CategoryDetailsViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 5/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CategoryDetailsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *categoryNameTextField;

- (id)initWithCategory:(NSManagedObjectID *)categoryObjectID;

- (IBAction)saveBtnPressed:(id)sender;

@end
