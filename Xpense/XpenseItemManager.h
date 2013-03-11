//
//  XpenseItemManager.h
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface XpenseItemManager : NSObject

+ (XpenseItemManager *) sharedInstance;

- (NSManagedObjectID *)createXpenseWithData:(NSDictionary *)data;
- (void)editAndSaveXpense:(NSManagedObjectID *)xpenseItemObjectID withData:(NSDictionary *)data;
- (NSArray *)fetchAllXpenses;

@end
