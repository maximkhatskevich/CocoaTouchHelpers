//
//  ExtMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray.h"

@interface ExtMutableArray ()

@property (readonly, nonatomic) NSMutableArray *mutableSelection;

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@end

@implementation ExtMutableArray

#pragma mark - Property accessors

- (NSMutableArray *)mutableSelection
{
    return (NSMutableArray *)_selection;
}

- (id)selectedObject
{
    return self.mutableSelection.firstObject;
}

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _store = [NSMutableArray array];
        _selection = [NSMutableArray array];
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
        _selection = [NSMutableArray array];
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
        _selection = [NSMutableArray array];
    }
    
    //===
    
    return self;
}

#pragma mark - NSArray

- (NSUInteger)count
{
    return self.store.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.store objectAtIndex:index];
}

#pragma mark - NSMutableArray

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
    [self.store removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    [self.store replaceObjectAtIndex:index withObject:anObject];
}

#pragma mark - Add

- (BOOL)addObjectToSelection:(id)object
{
    BOOL result = NO;
    
    //===
    
    if ([self indexOfObject:object] != NSNotFound)
    {
        [self.mutableSelection addObject:object];
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
    [self.mutableSelection removeObject:object];
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
    [self.mutableSelection removeAllObjects];
}

@end
