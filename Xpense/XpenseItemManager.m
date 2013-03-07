//
//  XpenseItemManager.m
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseItemManager.h"
#import "XpenseItem.h"
#import "DbStore.h"

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

- (NSManagedObjectID *)createXpenseWithDate:(NSDictionary *)data {
    DbStore *db = [DbStore currentThreadStore];
    XpenseCategory *category = nil;
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
//    category = (XpenseCategory *)[db fetchFirstEntityForName:NSStringFromClass([ class]) predicate:predicate sortDescriptors:nil];
//    
//    if (!category) {
//        category = (XpenseCategory *)[db createEntityForName:NSStringFromClass([XpenseCategory class])];
//        category.name = name;
//    }
//    
//    [db save];
//    
//    return category.objectID;
}

- (NSArray *)fetchAllXpenses {
    
}

@end
