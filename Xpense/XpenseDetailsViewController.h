//
//  XpenseDetailsViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 4/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XpenseDetailsViewController : UIViewController

- (id)initWithNewXpense:(BOOL)isNew;
- (IBAction)categoryBtnPressed:(id)sender;

@end
