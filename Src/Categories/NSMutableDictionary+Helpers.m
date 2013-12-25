//
//  NSMutableDictionary+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/9/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSMutableDictionary+Helpers.h"

@implementation NSMutableDictionary (Helpers)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (anObject &&
        aKey &&
        [(NSObject *)aKey conformsToProtocol:@protocol(NSCopying)])
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end
