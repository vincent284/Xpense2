//
//  Utils.m
//  Xpense
//
//  Created by Vincent Nguyen on 10/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSNumber *)xpenseNumberFromString:(NSString *)numberString {
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *amount = [numberFormatter numberFromString:numberString];
    
    return amount;
}

+ (NSString *)xpenseStringFromFloat:(float)number {
    return [NSString stringWithFormat:@"%.2f", number];
}

@end
