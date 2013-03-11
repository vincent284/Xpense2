//
//  FirstViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 25/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseViewController.h"
#import "XpenseDetailsViewController.h"
#import "XpenseItemManager.h"
#import "XpenseItem.h"
#import "XpenseCategory.h"
#import "XpenseItemCell.h"
#import "Utils.h"

@interface XpenseViewController () {
    NSArray *_xpenseItems;
}

@end

@implementation XpenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Xpense";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        _xpenseItems = [[[XpenseItemManager sharedInstance] fetchAllXpenses] retain];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self reloadXpenseItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadXpenseItems];
    [self.xpenseListTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_xpenseListTableView release];
    [_xpenseListSegmentedControl release];
    [_xpenseItems release];
    [super dealloc];
}
- (IBAction)addXpenseBtnPressed:(id)sender {
    XpenseDetailsViewController *xpenseDetailsVC = [[[XpenseDetailsViewController alloc] initWithXpense:nil] autorelease];
    [[self navigationController] pushViewController:xpenseDetailsVC animated:YES];
}

- (void )reloadXpenseItems {
    [_xpenseItems release];
    _xpenseItems = [[[XpenseItemManager sharedInstance] fetchAllXpenses] retain];
}

#pragma mark
#pragma mark TableView related delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *xpenseItems = [[XpenseItemManager sharedInstance] fetchAllXpenses];
    return xpenseItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XpenseItemCell *cell = (XpenseItemCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    if (!cell) {
        cell = [XpenseItemCell createNewCell];
    }
    
    XpenseItem *xpenseItem = [_xpenseItems objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    cell.amountLabel.text = [Utils xpenseStringFromFloat:[xpenseItem.amount floatValue]];
    cell.categoryLabel.text = xpenseItem.category.name;
    cell.dateLabel.text = [formatter stringFromDate:xpenseItem.date];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XpenseItem *xpenseItem = [_xpenseItems objectAtIndex:indexPath.row];
    
    XpenseDetailsViewController *xpenseDetailsVC = [[[XpenseDetailsViewController alloc] initWithXpense:xpenseItem.objectID] autorelease];
    
    [[self navigationController] pushViewController:xpenseDetailsVC animated:YES];
}

@end
