//
//  CategoryManager.h
//  Xpense
//
//  Created by Vincent Nguyen on 5/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CategoryManager : NSObject


+ (CategoryManager *) sharedInstance;

- (NSManagedObjectID *)createCategoryWithName:(NSString *)name;
- (void)deleteCategoryWithName:(NSString *)name;
- (NSArray *)fetchAllCategories;
@end
