//
//  CategoryDetailsViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 5/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CategoryDetailsViewController.h"
#import "CategoryManager.h"
#import "DbStore.h"
#import "XpenseCategory.h"

@interface CategoryDetailsViewController () {
    NSManagedObjectID *_categoryObjectID;
}

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

- (id)initWithCategory:(NSManagedObjectID *)categoryObjectID {
    self = [self initWithNibName:NSStringFromClass([CategoryDetailsViewController class]) bundle:nil];
    if (self) {
        if (!categoryObjectID) {
            self.title = @"Add Category";
        } else {
            self.title = @"Edit Category";
            _categoryObjectID = [categoryObjectID retain];
        }
    }
    
    return self;
}

- (IBAction)saveBtnPressed:(id)sender {
    if (![self.categoryNameTextField.text isEqual: @""]) {
        if (_categoryObjectID) {
            DbStore *db = [DbStore currentThreadStore];
            XpenseCategory *category = (XpenseCategory *)[db.moc objectWithID:_categoryObjectID];
            category.name = self.categoryNameTextField.text;
            
            [db save];
        } else {
            [[CategoryManager sharedInstance] createCategoryWithName:self.categoryNameTextField.text];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_categoryObjectID) {
        DbStore *db = [DbStore currentThreadStore];
        XpenseCategory *category = (XpenseCategory *)[db.moc objectWithID:_categoryObjectID];
        self.categoryNameTextField.text = category.name;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_categoryNameTextField release];
    [_categoryObjectID release];
    [super dealloc];
}
@end
