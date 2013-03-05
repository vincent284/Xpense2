//
//  DbStore.m
//  Xpense
//
//  Created by Vincent Nguyen on 25/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "DbStore.h"

#define DATABASE_NAME @"appdb"

@interface DbStore() {
    
}

@property (nonatomic, retain) NSManagedObjectContext *moc;

+ (NSString *)applicationDocumentsDirectory;
+ (NSManagedObjectContext *)createNewMoc;

@end

@implementation DbStore

@synthesize moc = _moc;

static NSMutableDictionary *mocs = nil;
static NSMutableDictionary *mocThreads = nil;
static int counter;
static dispatch_queue_t serialQueue;

+ (void)initialize {
    mocs = [[NSMutableDictionary alloc] init];
    mocThreads = [[NSMutableDictionary alloc] init];
    counter = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(threadWillExit:)
                                                 name:NSThreadWillExitNotification
                                               object:nil];
}

+ (DbStore *)mainThreadStore {
    if (![NSThread isMainThread]) {
        NSAssert(NO, @"[DbStore mainThreadStore] cannot be accessed from background thread");
        return nil;
    }
    
    return [self currentThreadStore];
}

+ (DbStore *)currentThreadStore {
    static NSString *key = @"DbStore";
    NSThread *currentThread = [NSThread currentThread];
    NSMutableDictionary *threadDictionary = [currentThread threadDictionary];
    if (![threadDictionary valueForKey:key]) {
        NSManagedObjectContext *moc = [self createNewMoc];
        DbStore *db = [[[DbStore alloc] init] autorelease];
        db.moc = moc;
        [threadDictionary setValue:db forKey:key];
    }
    
    return [threadDictionary valueForKey:key];
}

+ (NSManagedObjectContext *)createNewMoc {
    NSPersistentStoreCoordinator *psc = [DbStore persistentStoreCoordinator];
    if (psc != nil) {
        NSManagedObjectContext *newMoc = [NSManagedObjectContext new];
        [newMoc setPersistentStoreCoordinator:psc];
        [newMoc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        
        NSThread *currentThread = [NSThread currentThread];
        __block NSString *name = [currentThread name];
        if ([name length] == 0) {
            dispatch_async(serialQueue, ^{
                name = [NSString stringWithFormat:@"%d", ++counter];
                [currentThread setName:name];
            });
        }
        
        dispatch_async(serialQueue, ^{
            [mocs setValue:newMoc forKey:name];
            [mocThreads setValue:currentThread forKey:name];
        });
        
        NSLog(@"Created new moc on thread %@", name);
        return [newMoc autorelease];
    }
    
    return nil;
}

+ (void)threadWillExit:(NSNotification *)notif {
    NSThread *exitingThread = [notif object];
    [self destroyManagedObjectContextForThreadName:exitingThread.name];
}

+ (void)destroyManagedObjectContextForThreadName:(NSString *)name {
    dispatch_async(serialQueue, ^{
        if (name != nil && [mocs objectForKey:name] != nil) {
            [mocs removeObjectForKey:name];
            [mocThreads removeObjectForKey:name];
        }
    });
}

+ (void)mergeChanges:(NSNotification *)notif {
    NSManagedObjectContext *mocThatSendNotification = [notif object];
    //    NSLog(@"%@", mocs);
    //    NSLog(@"%@", serialQueue);
    //    NSLog(@"%@", mocThreads);
    dispatch_async(serialQueue, ^{
        [mocs enumerateKeysAndObjectsUsingBlock:^(id name, id moc, BOOL *stop) {
            name = (NSString *)name;
            moc = (NSManagedObjectContext *)moc;
            NSThread *thread = [mocThreads objectForKey:name];
            
            // don't send notifications back to the MOC that sent it.
            if (![moc isEqual:mocThatSendNotification] && thread == [NSThread mainThread]) {
                
                // http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different
                for(NSManagedObject *object in [[notif userInfo] objectForKey:NSUpdatedObjectsKey]) {
                    [[moc objectWithID:[object objectID]] willAccessValueForKey:nil];
                }
                
                @try {
                    // Merge changes back to the context of the main thread
                    [moc performSelector:@selector(mergeChangesFromContextDidSaveNotification:)
                                onThread:thread
                              withObject:notif
                           waitUntilDone:NO];
                }
                @catch (NSException *exception) {
                    NSLog(@"****    [DbStore mergeChanges:] exception: %@", exception);
                }
                @finally {
                    
                }
            }
        }];
    });
}

#pragma mark
#pragma mark Database methods
- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors {
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.moc];
	[request setEntity:entity];
    [request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors];
    
	NSError *error = nil;
	NSArray *entities = [self.moc executeFetchRequest:request error:&error];
    if(error) {
        NSLog(@"Error fetching entities");
        return nil;
    }
    
	return entities;
}

- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
               prefetchingKeyPaths:(NSArray *)keypaths {
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.moc];
	[request setEntity:entity];
    [request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors];
    [request setRelationshipKeyPathsForPrefetching:keypaths];
    
	NSError *error = nil;
	NSArray *entities = [self.moc executeFetchRequest:request error:&error];
    if(error) {
        NSLog(@"Error fetching entities");
        return nil;
    }
    
	return entities;
}

- (NSManagedObject *)fetchFirstEntityForName:(NSString *)name
                                   predicate:(NSPredicate *)predicate
                             sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:name inManagedObjectContext:self.moc];
    
    [request setEntity:entityDes];
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *entities = [self.moc executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching first entities");
        return nil;
    }
    
    if (entities.count > 0)
        return [entities objectAtIndex:0];
    else
        return nil;
}

// Count the number of entities
- (NSUInteger)countEntityForName:(NSString*)name
                       predicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors {
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.moc];
	[request setEntity:entity];
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    
	NSError *error = nil;
	NSUInteger count = [self.moc countForFetchRequest:request error:&error];
    if(error) {
        NSLog(@"Error counting fetched entities");
    }
    
    return count;
}

- (NSManagedObject *)createEntityForName:(NSString*)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name
										 inManagedObjectContext:self.moc];
}

- (void)deleteEntity:(NSManagedObject*)entity {
    [entity.managedObjectContext deleteObject:entity];
}

- (BOOL)save {
    assert(self.moc);
    
    if (![self.moc hasChanges]) {
        NSLog(@"Db has no change to save");
        return true;
    }
    
    NSError *error = nil;
    if (![self.moc save:&error]) {
        NSLog(@"Save Db error: %@", error);
        return false;
    }
    
    return true;
}

#pragma mark
#pragma mark Singleton objects

static NSManagedObjectModel *managedObjectModel = nil;
static NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;

+ (NSManagedObjectModel *)managedObjectModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Xpense" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });
    
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", DATABASE_NAME]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:storePath]) {
            NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:DATABASE_NAME ofType:@"sqlite"];
            
            if (defaultStorePath) {
                [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
            }
        }
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        //Options for light weight migration
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSError *error = nil;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if ([persistentStoreCoordinator
             addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            NSLog(@"Error creating persistentStoreCoordinator: %@, %@", error, [error userInfo]);
        }
    });
    
    return persistentStoreCoordinator;
}

#pragma mark
#pragma mark Application's documents directory
+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark
#pragma mark dealloc
- (void)dealloc {
    self.moc = nil;
    [super dealloc];
}
@end
