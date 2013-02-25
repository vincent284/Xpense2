//
//  XpenseItem.h
//  Xpense
//
//  Created by Vincent Nguyen on 25/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XpenseCategory;

@interface XpenseItem : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * lastEditDate;
@property (nonatomic, retain) XpenseCategory *category;

@end
