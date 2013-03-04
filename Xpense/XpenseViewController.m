//
//  FirstViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 25/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseViewController.h"
#import "XpenseDetailsViewController.h"

@interface XpenseViewController ()

@end

@implementation XpenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Xpense";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_xpenseListTableView release];
    [_xpenseListSegmentedControl release];
    [super dealloc];
}
- (IBAction)addXpenseBtnPressed:(id)sender {
    XpenseDetailsViewController *xpenseDetailsVC = [[[XpenseDetailsViewController alloc] initWithNewXpense:YES] autorelease];
    [[self navigationController] pushViewController:xpenseDetailsVC animated:YES];
}
@end
