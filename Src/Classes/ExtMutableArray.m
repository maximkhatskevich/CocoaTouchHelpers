//
//  ExtMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray.h"

#import "NSArray+Helpers.h"

@interface ExtMutableArray ()

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@end

@implementation ExtMutableArray
{
    NSHashTable *_selectionStorage;
}

#pragma mark - Property accessors

- (NSArray *)selection
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

- (id)selectedObject
{
    return self.selection.firstObject;
}

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _store = [NSMutableArray array];
    }
    
    //===
    
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _store = [NSMutableArray arrayWithCapacity:numItems];
    }
    
    //===
    
    return self;
}

- (instancetype)initWithObjects:(const id [])objects
                          count:(NSUInteger)count
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _store = [NSMutableArray arrayWithObjects:objects
                                            count:count];
    }
    
    //===
    
    return self;
}

#pragma mark - Overrided methods - NSArray

- (NSUInteger)count
{
    return self.store.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.store objectAtIndex:index];
}

#pragma mark - Overrided methods - NSMutableArray

- (void)addObject:(id)anObject
{
    [self.store addObject:anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    [self.store insertObject:anObject atIndex:index];
}

- (void)removeLastObject
{
    [self.store removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    if ([self isValidIndex:index])
    {
        [self removeObjectAtIndexFromSelection:index];
        [self.store removeObjectAtIndex:index];
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ([self isValidIndex:index])
    {
        [self removeObjectAtIndexFromSelection:index];
        [self.store replaceObjectAtIndex:index
                              withObject:anObject];
    }
}

#pragma mark - Service

- (NSHashTable *)selectionStorage
{
    if (!_selectionStorage)
    {
        _selectionStorage =
        [NSHashTable
         hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    
    return _selectionStorage;
}

#pragma mark - Add

- (BOOL)addObjectToSelection:(id)object
{
    BOOL result = NO;
    
    //===
    
    if ([self containsObject:object])
    {
        result = YES;
        
        //===
        
        if (self.onWillChangeSelection)
        {
            result = self.onWillChangeSelection(self, object, kAddEMAChangeType);
        }
        
        //===
        
        if (result)
        {
            [[self selectionStorage] addObject:object];
            
            //===
            
            if (self.onDidChangeSelection)
            {
                self.onDidChangeSelection(self, object, kAddEMAChangeType);
            }
        }
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
    BOOL canProceed = YES;
    
    if (self.onWillChangeSelection)
    {
        canProceed = self.onWillChangeSelection(self, object, kRemoveEMAChangeType);
    }
    
    //===
    
    if (canProceed)
    {
        [[self selectionStorage] removeObject:object];
        
        //===
        
        if (self.onDidChangeSelection)
        {
            self.onDidChangeSelection(self, object, kRemoveEMAChangeType);
        }
    }
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
        [self removeObjectFromSelection:object];
    }
}

#pragma mark - Reset

- (void)resetSelection
{
    NSArray *objectsToRemove = [[self selectionStorage] allObjects];
    
    for (id object in objectsToRemove)
    {
        [self removeObjectFromSelection:object];
    }
}

@end
