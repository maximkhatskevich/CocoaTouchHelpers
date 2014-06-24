//
//  ExtMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray.h"

#import "NSArray+Helpers.h"
#import "ArrayItemWrapper.h"

@interface ExtMutableArray ()

@property (readwrite, nonatomic) dispatch_queue_t queue;

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@property (readwrite) BOOL selectionChanged;

@end

@implementation ExtMutableArray

#pragma mark - Property accessors

- (NSArray *)selection
{
    NSMutableArray *result = [NSMutableArray array];
    
    //===
    
    for (ArrayItemWrapper *wrapper in _store)
    {
        if (wrapper.selected)
        {
            [result addObject:wrapper.content];
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
        _queue = dispatch_queue_create("ExtMutableArrayQueue", DISPATCH_QUEUE_CONCURRENT);
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
        _store = [NSMutableArray array];
        _queue = dispatch_queue_create("ExtMutableArrayQueue", DISPATCH_QUEUE_CONCURRENT);
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
        _store = [NSMutableArray array];
        _queue = dispatch_queue_create("ExtMutableArrayQueue", DISPATCH_QUEUE_CONCURRENT);
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
        
        result = _store.count;
    });
    
    //===
    
    return result;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id result = nil;
    
    //===
    
    dispatch_sync(_queue, ^{
        
        result = ((ArrayItemWrapper *)_store[index]).content;
    });
    
    //===
    
    return result;
}

#pragma mark - Overrided methods - NSMutableArray

- (void)addObject:(id)anObject
{
    dispatch_barrier_async(_queue, ^{
        
        [_store addObject:
         [ArrayItemWrapper wrapperWithContent:anObject]];
    });
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    dispatch_barrier_async(_queue, ^{
        
        [_store insertObject:[ArrayItemWrapper wrapperWithContent:anObject]
                     atIndex:index];
    });
}

- (void)removeLastObject
{
    dispatch_barrier_async(_queue, ^{
        
        [_store removeLastObject];
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(_queue, ^{
        
        if ([_store isValidIndex:index])
        {
            [_store removeObjectAtIndex:index];
        }
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    dispatch_barrier_async(_queue, ^{
        
        if ([_store isValidIndex:index])
        {
            [_store replaceObjectAtIndex:index
                              withObject:[ArrayItemWrapper wrapperWithContent:anObject]];
        }
    });
}

#pragma mark - Service

- (BOOL)willChangeSelectionWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    BOOL result = YES;
    
    //===
    
    if (self.onWillChangeSelection)
    {
        result = self.onWillChangeSelection(self, targetObject, changeType);
    }
    
    //===
    
    return result;
}

- (void)didChangeSelectionWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    if (self.onDidChangeSelection)
    {
        self.onDidChangeSelection(self, targetObject, changeType);
    }
    
    //===
    
    // lets notify KVO observers about selection change
    
    _selectionChanged = NO;
    self.selectionChanged = YES;
    _selectionChanged = NO;
}

#pragma mark - Add to selection

- (void)addObjectToSelection:(id)object
{
    ArrayItemWrapper *targetWrapper = nil;
    
    //===
    
    for (ArrayItemWrapper *wrapper in _store)
    {
        if ([wrapper.content isEqual:object])
        {
            targetWrapper = wrapper;
            break;
        }
    }
    
    //===
    
    if (targetWrapper)
    {
        BOOL canProceed = [self willChangeSelectionWithObject:object
                                                   changeType:kAddEMAChangeType];
        
        //===
        
        if (canProceed)
        {
            targetWrapper.selected = YES;
            
            //===
            
            [self didChangeSelectionWithObject:object
                                    changeType:kAddEMAChangeType];
        }
    }
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

#pragma mark - Set selection

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

#pragma mark - Remove from selection

- (void)removeObjectFromSelection:(id)object
{
    ArrayItemWrapper *targetWrapper = nil;
    
    //===
    
    for (ArrayItemWrapper *wrapper in _store)
    {
        if ([wrapper.content isEqual:object])
        {
            targetWrapper = wrapper;
            break;
        }
    }
    
    //===
    
    if (targetWrapper)
    {
        BOOL canProceed = [self willChangeSelectionWithObject:object
                                                   changeType:kRemoveEMAChangeType];
        
        //===
        
        if (canProceed)
        {
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithObject:object
                                    changeType:kRemoveEMAChangeType];
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
    for (ArrayItemWrapper *wrapper in _store)
    {
        wrapper.selected = NO;
    }
}

@end
