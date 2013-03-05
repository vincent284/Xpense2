//
//  XpenseDetailsViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 4/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseDetailsViewController.h"
#import "CategoryViewController.h"

@interface XpenseDetailsViewController ()

@end

@implementation XpenseDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNewXpense:(BOOL)isNew {
    self = [self initWithNibName:NSStringFromClass([XpenseDetailsViewController class]) bundle:nil];
    if (self) {
        if (isNew) {
            self.title = @"Add Xpense";
        } else {
            self.title = @"Edit Xpense";
        }
    }
    
    return self;
}

- (IBAction)categoryBtnPressed:(id)sender {
    CategoryViewController *categoryVC = [[[CategoryViewController alloc] initWithNibName:NSStringFromClass([CategoryViewController class]) bundle:nil] autorelease];
    [[self navigationController] pushViewController:categoryVC animated:YES];
}

- (IBAction)saveBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
@end
