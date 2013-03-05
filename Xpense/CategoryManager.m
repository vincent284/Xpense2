//
//  CategoryManager.m
//  Xpense
//
//  Created by Vincent Nguyen on 5/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CategoryManager.h"
#import "DbStore.h"
#import "XpenseCategory.h"

@implementation CategoryManager

#pragma mark
#pragma mark Singleton

static CategoryManager *sharedInstance = nil;

+ (CategoryManager *) sharedInstance {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[CategoryManager alloc] init];
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

- (NSManagedObjectID *)createCategoryWithName:(NSString *)name {
    DbStore *db = [DbStore currentThreadStore];
    XpenseCategory *category = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    category = (XpenseCategory *)[db fetchFirstEntityForName:NSStringFromClass([XpenseCategory class]) predicate:predicate sortDescriptors:nil];
    
    if (!category) {
        category = (XpenseCategory *)[db createEntityForName:NSStringFromClass([XpenseCategory class])];
        category.name = name;
    }
    
    [db save];
    
    return category.objectID;
}

- (void)deleteCategoryWithName:(NSString *)name {
    
}

- (NSArray *)fetchAllCategories {
    DbStore *db = [DbStore currentThreadStore];
    NSArray *categories = [db fetchEntitiesForName:NSStringFromClass([XpenseCategory class]) predicate:nil sortDescriptors:nil];
    
    return categories;
}

@end
