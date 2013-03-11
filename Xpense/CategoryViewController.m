//
//  CategoryViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 4/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryDetailsViewController.h"
#import "CategoryManager.h"
#import "XpenseCategory.h"

@interface CategoryViewController () {
    NSString *_selectedCategoryName;
}

@end

@implementation CategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCategoryName:(NSString *)categoryName {
    self = [[CategoryViewController alloc] initWithNibName:NSStringFromClass([CategoryViewController class]) bundle:nil];
    if (self) {
        _selectedCategoryName = categoryName;
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    [lpgr release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Category";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCategory)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCategory {
    CategoryDetailsViewController *categoryDetailsVC = [[[CategoryDetailsViewController alloc] initWithCategory:nil] autorelease];
    [[self navigationController] pushViewController:categoryDetailsVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[CategoryManager sharedInstance] fetchAllCategories] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"Operations";
//    } else {
//        return @"Categories";
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSArray *categories = [[CategoryManager sharedInstance] fetchAllCategories];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        XpenseCategory *category = (XpenseCategory *) [categories objectAtIndex:indexPath.row];
        cell.textLabel.text = category.name;
        if ([category.name isEqualToString:_selectedCategoryName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(categoryViewController:didFinishChoosingCategory:)]) {
            NSArray *categories = [[CategoryManager sharedInstance] fetchAllCategories];
            XpenseCategory *category = (XpenseCategory *)[categories objectAtIndex:indexPath.row];
            [self.delegate categoryViewController:self didFinishChoosingCategory:category.name];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSArray *categories = [[CategoryManager sharedInstance] fetchAllCategories];
            XpenseCategory *category = (XpenseCategory *)[categories objectAtIndex:indexPath.row];
            [[CategoryManager sharedInstance] deleteCategory:category.objectID];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark
#pragma mark Long press gesture recognizer
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        if (indexPath) {
            NSArray *categories = [[CategoryManager sharedInstance] fetchAllCategories];
            XpenseCategory *category = (XpenseCategory *)[categories objectAtIndex:indexPath.row];
            CategoryDetailsViewController *categoryDetailsVC = [[[CategoryDetailsViewController alloc] initWithCategory:category.objectID] autorelease];
            [[self navigationController] pushViewController:categoryDetailsVC animated:YES];
        }
    }
}

@end
