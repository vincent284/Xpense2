//
//  FirstViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 25/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XpenseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *xpenseListTableView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *xpenseListSegmentedControl;

- (IBAction)addXpenseBtnPressed:(id)sender;

@end
