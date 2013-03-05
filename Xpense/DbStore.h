//
//  DbStore.h
//  Xpense
//
//  Created by Vincent Nguyen on 25/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DbStore : NSObject 

+ (DbStore *)mainThreadStore;

+ (DbStore *)currentThreadStore;

@property (nonatomic, retain, readonly) NSManagedObjectContext *moc;

#pragma mark
#pragma mark Database methods
- (NSManagedObject*)createEntityForName:(NSString*)name;
- (void)deleteEntity:(NSManagedObject*)entity;

// Count the number of entities
- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors;

- (NSUInteger)countEntityForName:(NSString*)name
                       predicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors;

- (NSManagedObject *)fetchFirstEntityForName:(NSString *)name
                                   predicate:(NSPredicate *)predicate
                             sortDescriptors:(NSArray *)sortDescriptors;

- (BOOL) save;
@end
