//
//  XpenseItemManager.m
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseItemManager.h"
#import "XpenseItem.h"
#import "XpenseCategory.h"
#import "DbStore.h"
#import "Common.h"

@implementation XpenseItemManager

#pragma mark
#pragma mark Singleton

static XpenseItemManager *sharedInstance = nil;

+ (XpenseItemManager *) sharedInstance {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[XpenseItemManager alloc] init];
    });
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
        }
    });
    
    return sharedInstance;
}

- (id)init {
    id __block obj = nil;
    
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        obj = [super init];
        if (obj) {
            // Init
        }
    });
    
    self = obj;
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSManagedObjectID *)createXpenseWithData:(NSDictionary *)data {
    DbStore *db = [DbStore currentThreadStore];
    
    NSString *amountString = [data valueForKey:kAmount];
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *amount = [numberFormatter numberFromString:amountString];
    NSString *categoryName = [data valueForKey:kCategoryName];
    NSDate *date = (NSDate *)[data valueForKey:kDate];
    
    
    XpenseItem *xpenseItem = nil;
    XpenseCategory *category = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", categoryName];
    category = (XpenseCategory *)[db fetchFirstEntityForName:NSStringFromClass([XpenseCategory class]) predicate:predicate sortDescriptors:nil];
    
    // Get the category
    if (!category) {
        category = (XpenseCategory *)[db createEntityForName:NSStringFromClass([XpenseCategory class])];
        category.name = categoryName;
    }
    
    xpenseItem = (XpenseItem *)[db createEntityForName:NSStringFromClass([XpenseItem class])];
    xpenseItem.amount = amount;
    xpenseItem.category = category;
    xpenseItem.date = date;
    
    [db save];

    return xpenseItem.objectID;
}

- (void)editAndSaveXpense:(NSManagedObjectID *)xpenseItemObjectID withData:(NSDictionary *)data {
    DbStore *db = [DbStore currentThreadStore];
    
    NSString *amountString = [data valueForKey:kAmount];
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *amount = [numberFormatter numberFromString:amountString];
    NSString *categoryName = [data valueForKey:kCategoryName];
    NSDate *date = (NSDate *)[data valueForKey:kDate];
    
    
    XpenseItem *xpenseItem = (XpenseItem *) [db.moc objectWithID:xpenseItemObjectID];
    if (xpenseItem) {
        XpenseCategory *category = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", categoryName];
        category = (XpenseCategory *)[db fetchFirstEntityForName:NSStringFromClass([XpenseCategory class]) predicate:predicate sortDescriptors:nil];
        
        // Get the category
        if (!category) {
            category = (XpenseCategory *)[db createEntityForName:NSStringFromClass([XpenseCategory class])];
            category.name = categoryName;
        }
        
        xpenseItem.amount = amount;
        xpenseItem.category = category;
        xpenseItem.date = date;
        
        [db save];
    }
}

- (NSArray *)fetchAllXpenses {
    DbStore *db = [DbStore currentThreadStore];
    NSArray *xpenseItems = [db fetchEntitiesForName:NSStringFromClass([XpenseItem class]) predicate:nil sortDescriptors:nil];
    
    return xpenseItems;
}

@end
