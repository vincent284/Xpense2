//
//  CategoryDetailsViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 5/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CategoryDetailsViewController.h"
#import "CategoryManager.h"

@interface CategoryDetailsViewController ()

@end

@implementation CategoryDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNewCategory:(BOOL)isNew {
    self = [self initWithNibName:NSStringFromClass([CategoryDetailsViewController class]) bundle:nil];
    if (self) {
        if (isNew) {
            self.title = @"Add Category";
        } else {
            self.title = @"Edit Category";
        }
    }
    
    return self;
}

- (IBAction)saveBtnPressed:(id)sender {
    if (![self.categoryNameTextField.text isEqual: @""]) {
        [[CategoryManager sharedInstance] createCategoryWithName:self.categoryNameTextField.text];
    }
    
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
    [_categoryNameTextField release];
    [super dealloc];
}
@end
