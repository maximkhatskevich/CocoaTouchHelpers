//
//  NSArray+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

#pragma mark - Property accessors

- (id)firstObject
{
    return [self safeObjectAtIndex:0];
}

#pragma mark - Helpers

- (BOOL)isValidIndex:(NSUInteger)indexForTest
{
    return (indexForTest < self.count);
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    return ([self isValidIndex:index] ? self[index] : nil);
}

@end
