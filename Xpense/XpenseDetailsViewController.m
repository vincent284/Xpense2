//
//  XpenseDetailsViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseDetailsViewController.h"
#import "TextFieldCell.h"
#import "LabelCell.h"
#import "CategoryViewController.h"
#import "DatePickerViewController.h"
#import "XpenseItemManager.h"
#import "Common.h"
#import "DbStore.h"
#import "XpenseItem.h"
#import "XpenseCategory.h"
#import "Utils.h"

#define AMOUNT_CELL_INDEX 0
#define CATEGORY_CELL_INDEX 1
#define DATE_CELL_INDEX 2

#define NUMBER_OF_CELL 3


@interface XpenseDetailsViewController () {
    NSString *_amount;
    NSString *_category;
    NSDate *_date;
    NSIndexPath *_amountCellIndexPath;
    NSManagedObjectID *_xpenseItemObjectID;
}

@end

@implementation XpenseDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithXpense:(NSManagedObjectID *)xpenseItemObjectID {
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        if (!xpenseItemObjectID) {
            self.title = @"Add Xpense";
            _amount = @"0";
            _category = @"General";
            _date = [[NSDate date] retain];
            _amountCellIndexPath = nil;
            _xpenseItemObjectID = nil;
        } else {
            self.title = @"Edit Xpense";
            DbStore *db = [DbStore currentThreadStore];
            XpenseItem *xpenseItem = (XpenseItem *)[db.moc objectWithID:xpenseItemObjectID];
            _amount = [[Utils xpenseStringFromFloat:[xpenseItem.amount floatValue]] copy];
            _category = [xpenseItem.category.name copy];
            _date = [xpenseItem.date copy];
            
            _xpenseItemObjectID = xpenseItemObjectID;
        }
        
        UIBarButtonItem *saveItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
        [[self navigationItem] setRightBarButtonItem:saveItem];
        
    }
    
    return self;
}

- (void)dealloc {
    [_date release];
    [_category release];
    [_amountCellIndexPath release];
    [_amount release];
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return NUMBER_OF_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == AMOUNT_CELL_INDEX) {
        // Amount
        NSString *CellIdenrifier = [TextFieldCell globalIdentifier];
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenrifier];
        if (!cell) {
            cell = [TextFieldCell createNewCell];
        }
        
        // Customize
        cell.amountLabel.text = @"Amount";
        cell.amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.amountTextField.text = _amount;
        cell.amountTextField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [_amountCellIndexPath release];
        _amountCellIndexPath = [indexPath retain];
        
        return cell;
    } else if (indexPath.row == CATEGORY_CELL_INDEX) {
        // Category
        NSString *CellIdentifier = [LabelCell globalIdentifier];
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [LabelCell createNewCell];
        }
        
        // Customize
        cell.identifyingLabel.text = @"Category";
        cell.contentLabel.text = _category;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else if (indexPath.row == DATE_CELL_INDEX) {
        // Date
        NSString *CellIdentifier = [LabelCell globalIdentifier];
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [LabelCell createNewCell];
        }
        
        // Customize
        cell.identifyingLabel.text = @"Date";
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        cell.contentLabel.text = [formatter stringFromDate:_date];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return nil;
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
    if (indexPath.row == CATEGORY_CELL_INDEX) {
        CategoryViewController *categoryVC = [[[CategoryViewController alloc] initWithCategoryName:_category] autorelease];
        categoryVC.delegate = self;
        [self.navigationController pushViewController:categoryVC animated:YES];
    } else if (indexPath.row == DATE_CELL_INDEX) {
        DatePickerViewController *datePickerVC = [[[DatePickerViewController alloc] initWithDate:_date] autorelease];
        
        datePickerVC.delegate = self;
        
        [self.navigationController pushViewController:datePickerVC animated:YES];
    }
}


#pragma mark
#pragma mark Bar Buttons
- (void)save {
    TextFieldCell *amountCell = (TextFieldCell *) [self.tableView cellForRowAtIndexPath:_amountCellIndexPath];
    
    [_amount release];
    _amount = [amountCell.amountTextField.text copy];
    
    BOOL valid = YES;
    if ([_amount isEqualToString:@""] || !_category) {
        NSLog(@"Invalid values for XpenseItem");
        valid = NO;
    }
    
    if (valid) {
        NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
        [data setValue:_amount forKey:kAmount];
        [data setValue:_category forKey:kCategoryName];
        [data setValue:_date forKey:kDate];
        
        if (_xpenseItemObjectID) {
            [[XpenseItemManager sharedInstance] editAndSaveXpense:_xpenseItemObjectID withData:data];
        } else {
            [[XpenseItemManager sharedInstance] createXpenseWithData:data];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark CategoryViewControllerDelegate
- (void)categoryViewController:(CategoryViewController *)controller didFinishChoosingCategory:(NSString *)categoryName {
    _category = [categoryName copy];
    [self.tableView reloadData];
}

#pragma mark
#pragma mark DatePickerViewControllerDelegate
- (void)didFinishSelectDate:(NSDate *)newDate {
    [_date release];
    _date = [newDate retain];
    [self.tableView reloadData];
}

@end
