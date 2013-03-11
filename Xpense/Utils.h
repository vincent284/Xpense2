//
//  Utils.h
//  Xpense
//
//  Created by Vincent Nguyen on 10/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSNumber *)xpenseNumberFromString:(NSString *)numberString;
+ (NSString *)xpenseStringFromFloat:(float)number;

@end
