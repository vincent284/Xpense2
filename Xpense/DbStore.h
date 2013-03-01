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

- (BOOL) save;
@end
