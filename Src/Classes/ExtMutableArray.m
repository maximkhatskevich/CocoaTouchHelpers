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

@property (readwrite, nonatomic) dispatch_queue_t queue;

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
    __block NSMutableArray *result = nil;
    
    //===
    
    dispatch_sync(_queue, ^{
        
        NSArray *selectionObjects =
        [_selectionStorage allObjects];
        
        result = [NSMutableArray array];
        
        for (id selectedObject in selectionObjects)
        {
            if ([self indexOfObject:selectedObject] == NSNotFound)
            {
                [_selectionStorage removeObject:selectedObject];
            }
            else
            {
                [result addObject:selectedObject];
            }
        }
    });
    
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
        _queue = dispatch_queue_create("ExtMutableArrayQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _selectionStorage =
        [NSHashTable
         hashTableWithOptions:NSPointerFunctionsWeakMemory];
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
        _queue = dispatch_queue_create("ExtMutableArrayQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _selectionStorage =
        [NSHashTable
         hashTableWithOptions:NSPointerFunctionsWeakMemory];
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
        _queue = dispatch_queue_create("ExtMutableArrayQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _selectionStorage =
        [NSHashTable
         hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    
    //===
    
    return self;
}

#pragma mark - Overrided methods - NSArray

- (NSUInteger)count
{
    __block NSUInteger result = 0;
    
    //===
    
    dispatch_sync(_queue, ^{
        
        result = self.store.count;
    });
    
    //===
    
    return result;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id result = nil;
    
    //===
    
    dispatch_sync(_queue, ^{
        
        if ([self isValidIndex:index])
        {
            result = [self.store objectAtIndex:index];
        }
    });
    
    //===
    
    return result;
}

#pragma mark - Overrided methods - NSMutableArray

- (void)addObject:(id)anObject
{
    dispatch_barrier_async(_queue, ^{
        
        [self.store addObject:anObject];
    });
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    dispatch_barrier_async(_queue, ^{
        
        [self.store insertObject:anObject atIndex:index];
    });
}

- (void)removeLastObject
{
    dispatch_barrier_async(_queue, ^{
        
        [self.store removeLastObject];
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(_queue, ^{
        
        if ([self isValidIndex:index])
        {
            [self removeObjectAtIndexFromSelection:index];
            [self.store removeObjectAtIndex:index];
        }
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    dispatch_barrier_async(_queue, ^{
        
        if ([self isValidIndex:index])
        {
            [self removeObjectAtIndexFromSelection:index];
            [self.store replaceObjectAtIndex:index
                                  withObject:anObject];
        }
    });
}

#pragma mark - Add

- (void)addObjectToSelection:(id)object
{
    dispatch_barrier_async(_queue, ^{
        
        if ([self.store containsObject:object])
        {
            BOOL canProceed = YES;
            
            //===
            
            if (self.onWillChangeSelection)
            {
                canProceed = self.onWillChangeSelection(self, object, kAddEMAChangeType);
            }
            
            //===
            
            if (canProceed)
            {
                [_selectionStorage addObject:object];
                
                //===
                
                if (self.onDidChangeSelection)
                {
                    self.onDidChangeSelection(self, object, kAddEMAChangeType);
                }
            }
        }
    });
}

- (void)addObjectAtIndexToSelection:(NSUInteger)index
{
    [self addObjectToSelection:
     [self safeObjectAtIndex:index]];
}

- (void)addObjectsToSelection:(NSArray *)objectList
{
    if (objectList.count)
    {
        for (id object in objectList)
        {
            [self addObjectToSelection:object];
        }
    }
    else
    {
        NSLog(@"Nothing to add to selection list.");
    }
}

#pragma mark - Set

- (void)setObjectSelected:(id)object
{
    [self resetSelection];
    
    //===
    
    [self addObjectToSelection:object];
}

- (void)setObjectAtIndexSelected:(NSUInteger)index
{
    [self setObjectSelected:
     [self safeObjectAtIndex:index]];
}

- (void)setObjectsSelected:(NSArray *)objectList
{
    [self resetSelection];
    
    //===
    
    [self addObjectsToSelection:objectList];
}

#pragma mark - Remove

- (void)removeObjectFromSelection:(id)object
{
    dispatch_barrier_async(_queue, ^{
        
        BOOL canProceed = YES;
        
        if (self.onWillChangeSelection)
        {
            canProceed = self.onWillChangeSelection(self, object, kRemoveEMAChangeType);
        }
        
        //===
        
        if (canProceed)
        {
            [_selectionStorage removeObject:object];
            
            //===
            
            if (self.onDidChangeSelection)
            {
                self.onDidChangeSelection(self, object, kRemoveEMAChangeType);
            }
        }
    });
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
    NSArray *objectsToRemove = [_selectionStorage allObjects];
    
    for (id object in objectsToRemove)
    {
        [self removeObjectFromSelection:object];
    }
}

@end
