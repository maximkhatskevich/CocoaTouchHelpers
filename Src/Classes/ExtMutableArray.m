//
//  ExtMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray.h"

@interface ExtMutableArray ()

@property (strong, nonatomic) NSMutableArray *selection;

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@end

@implementation ExtMutableArray

#pragma mark - Property accessors

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

@end
