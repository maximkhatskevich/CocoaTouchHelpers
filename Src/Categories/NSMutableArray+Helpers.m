//
//  NSMutableArray+Helpers.m
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 5/6/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSMutableArray+Helpers.h"

@implementation NSMutableArray (Helpers)

- (void)safeAddObject:(id)object
{
    if (object)
    {
        [self addObject:object];
    }
}

- (void)safeAddUniqueObject:(id)object
{
    if (object &&
        ![self containsObject:object])
    {
        [self addObject:object];
    }
}

- (void)safeAddUniqueParseObject:(id)object
{
    if (object &&
        ![self containsParseObject:object])
    {
        [self addObject:object];
    }
}

@end
