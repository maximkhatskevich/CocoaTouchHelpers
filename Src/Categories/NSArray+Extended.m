//
//  NSArray+Extended.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 27/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "NSArray+Extended.h"

#import <objc/runtime.h>

static void *SelectionKey;

//===

@implementation NSArray (Tracking)

#pragma mark - Property accessors

- (NSArray *)selection
{
    @synchronized(self)
    {
        NSMutableArray *result = [NSMutableArray array];
        
        //===
        
        NSArray *selectionObjects =
        [[self selectionStorage] allObjects];
        
        for (id selectedObject in selectionObjects)
        {
            if ([self indexOfObject:selectedObject] == NSNotFound)
            {
                [[self selectionStorage] removeObject:selectedObject];
            }
            else
            {
                [result addObject:selectedObject];
            }
        }
        
        //===
        
        return [NSArray arrayWithArray:result];
    }
}

- (id)selectedObject
{
    return self.selection.firstObject;
}

#pragma mark - Internal

- (NSHashTable *)selectionStorage
{
    @synchronized(self)
    {
        NSHashTable *result =
        objc_getAssociatedObject(self, &SelectionKey);
        
        //===
        
        if (!result)
        {
            result =
            [NSHashTable
             hashTableWithOptions:NSPointerFunctionsWeakMemory];
            
            objc_setAssociatedObject(self,
                                     &SelectionKey,
                                     result,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        //===
        
        return result;
    }
}

#pragma mark - Add

- (BOOL)addObjectToSelection:(id)object
{
    BOOL result = NO;
    
    //===
    
    if ([self indexOfObject:object] != NSNotFound)
    {
        [[self selectionStorage] addObject:object];
        result = YES;
    }
    
    //===
    
    return result;
}

- (BOOL)addObjectAtIndexToSelection:(NSUInteger)index
{
    return [self addObjectToSelection:
            [self safeObjectAtIndex:index]];
}

- (BOOL)addObjectsToSelection:(NSArray *)objectList
{
    BOOL result = NO;
    
    //===
    
    if (objectList.count)
    {
        result = YES;
        
        for (id object in objectList)
        {
            if (![self addObjectToSelection:object])
            {
                result = NO;
            }
        }
    }
    else
    {
        NSLog(@"Nothing to add to selection list.");
    }
    
    //===
    
    return result;
}

#pragma mark - Set

- (BOOL)setObjectSelected:(id)object
{
    [self resetSelection];
    
    //===
    
    return [self addObjectToSelection:object];
}

- (BOOL)setObjectAtIndexSelected:(NSUInteger)index
{
    return [self setObjectSelected:
            [self safeObjectAtIndex:index]];
}

- (BOOL)setObjectsSelected:(NSArray *)objectList
{
    [self resetSelection];
    
    //===
    
    return [self addObjectsToSelection:objectList];
}

#pragma mark - Remove

- (void)removeObjectFromSelection:(id)object
{
    [[self selectionStorage] removeObject:object];
}

- (void)removeObjectAtIndexFromSelection:(NSUInteger)index
{
    [self removeObjectFromSelection:
     [self safeObjectAtIndex:index]];
}

- (void)removeObjectsFromSelection:(NSArray *)objectList
{
    for (id object in objectList)
    {
        [[self selectionStorage] removeObject:object];
    }
}

#pragma mark - Reset

- (void)resetSelection
{
    [[self selectionStorage] removeAllObjects];
}

@end
