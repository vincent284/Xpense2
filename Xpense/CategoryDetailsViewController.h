//
//  CategoryDetailsViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 5/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *categoryNameTextField;

- (id)initWithNewCategory:(BOOL)isNew;

- (IBAction)saveBtnPressed:(id)sender;

@end
