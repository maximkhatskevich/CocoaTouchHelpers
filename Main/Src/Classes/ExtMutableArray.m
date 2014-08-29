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

//===

@interface ExtMutableArray ()

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@property (strong, nonatomic) NSMapTable *contentNotifications;
@property (strong, nonatomic) NSMapTable *selectionNotifications;

@end

@implementation ExtMutableArray

#pragma mark - Property accessors

- (NSArray *)selection
{
    __block NSMutableArray *result = [NSMutableArray array];
    
    //===
    
    dispatch_sync(_operationQueue, ^{
        
        NSArray *storeCopy = [NSArray arrayWithArray:_store];
        
        for (ArrayItemWrapper *wrapper in storeCopy)
        {
            if (wrapper.selected)
            {
                [result addObject:wrapper.content];
            }
        }
    });
    
    //===
    
    return [NSArray arrayWithArray:result];
}

- (id)selectedObject
{
    __block id result = nil;
    
    //===
    
    dispatch_sync(_operationQueue, ^{
        
        result = self.selection.firstObject;
    });
    
    //===
    
    return result;
}

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _store = [NSMutableArray array];
        
        [self setup];
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
        
        [self setup];
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
        
        [self setup];
    }
    
    //===
    
    return self;
}

#pragma mark - Overrided methods - NSArray

- (NSUInteger)count
{
    __block NSUInteger result = 0;
    
    //===
    
    dispatch_sync(_operationQueue, ^{
        
        result = _store.count;
    });
    
    //===
    
    return result;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id result = nil;
    
    //===
    
    dispatch_sync(_operationQueue, ^{
        
        result = ((ArrayItemWrapper *)_store[index]).content;
    });
    
    //===
    
    return result;
}

#pragma mark - Overrided methods - NSMutableArray

- (void)addObject:(id)anObject
{
    if (anObject)
    {
        dispatch_barrier_async(_operationQueue, ^{
            
            [_store addObject:
             [ArrayItemWrapper wrapperWithContent:anObject]];
            
            //===
            
            [self notifyAboutContentChangeWithObject:anObject
                                          changeType:kAddEMAChangeType];
        });
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject)
    {
        dispatch_barrier_async(_operationQueue, ^{
            
            ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
            
            //===
            
            if (targetWrapper.selected)
            {
                targetWrapper.selected = NO;
                
                //===
                
                [self didChangeSelectionWithObject:targetWrapper.content
                                        changeType:kRemoveEMAChangeType];
            }
            
            //===
            
            [_store
             insertObject:[ArrayItemWrapper wrapperWithContent:anObject]
             atIndex:index];
            
            //===
            
            if (targetWrapper)
            {
                [self notifyAboutContentChangeWithObject:targetWrapper.content
                                              changeType:kRemoveEMAChangeType];
            }
            
            //===
            
            [self notifyAboutContentChangeWithObject:anObject
                                          changeType:kAddEMAChangeType];
        });
    }
}

- (void)removeLastObject
{
    dispatch_barrier_async(_operationQueue, ^{
        
        ArrayItemWrapper *targetWrapper = [_store lastObject];
        
        //===
        
        if (targetWrapper)
        {
            if (targetWrapper.selected)
            {
                targetWrapper.selected = NO;
                
                //===
                
                [self didChangeSelectionWithObject:targetWrapper.content
                                        changeType:kRemoveEMAChangeType];
            }
            
            //===
            
            [_store removeLastObject];
            
            //===
            
            [self notifyAboutContentChangeWithObject:targetWrapper.content
                                          changeType:kRemoveEMAChangeType];
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(_operationQueue, ^{
        
        ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
        
        //===
        
        if (targetWrapper)
        {
            if (targetWrapper.selected)
            {
                targetWrapper.selected = NO;
                
                //===
                
                [self didChangeSelectionWithObject:targetWrapper.content
                                        changeType:kRemoveEMAChangeType];
            }
            
            //===
            
            [_store removeObjectAtIndex:index];
            
            //===
            
            if (targetWrapper)
            {
                [self notifyAboutContentChangeWithObject:targetWrapper.content
                                              changeType:kRemoveEMAChangeType];
            }
        }
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject)
    {
        dispatch_barrier_async(_operationQueue, ^{
            
            ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
            
            //===
            
            if (targetWrapper)
            {
                if (targetWrapper.selected)
                {
                    targetWrapper.selected = NO;
                    
                    //===
                    
                    [self didChangeSelectionWithObject:targetWrapper.content
                                            changeType:kRemoveEMAChangeType];
                }
                
                //===
                
                [_store replaceObjectAtIndex:index
                                  withObject:[ArrayItemWrapper wrapperWithContent:anObject]];
                
                //===
                
                [self notifyAboutContentChangeWithObject:targetWrapper.content
                                              changeType:kRemoveEMAChangeType];
                
                //===
                
                [self notifyAboutContentChangeWithObject:anObject
                                              changeType:kAddEMAChangeType];
            }
        });
    }
}

#pragma mark - Custom

- (void)setup
{
    _contentNotifications = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
                                                  valueOptions:NSPointerFunctionsStrongMemory];
    
    _selectionNotifications = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
                                                    valueOptions:NSPointerFunctionsStrongMemory];
    
    _onEqualityCheck = ^(id firstObject, id secondObject) {
        
        return [firstObject isEqual:secondObject];
    };
    
    _operationQueue = dispatch_queue_create("com.queue.CTH", DISPATCH_QUEUE_CONCURRENT);
    _notificationQueue = [NSOperationQueue mainQueue];

}

- (void)didChangeSelectionWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{

    [self notifyAboutSelectionChangeWithObject:targetObject changeType:changeType];
}

- (void)notifyAboutContentChangeWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    for (id key in [[self.contentNotifications keyEnumerator] allObjects])
    {
        ExtArrayNotificationBlock block = [self.contentNotifications objectForKey:key];
        
        if (block)
        {
            [self.notificationQueue addOperationWithBlock:^{
                
                block(key, self, targetObject, changeType);
            }];
        }
    }
}

- (void)notifyAboutSelectionChangeWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    for (id key in [[self.selectionNotifications keyEnumerator] allObjects])
    {
        ExtArrayNotificationBlock block = [self.selectionNotifications objectForKey:key];
        
        if (block)
        {
            [self.notificationQueue addOperationWithBlock:^{
                
                block(key, self, targetObject, changeType);
            }];
        }
    }
}

#pragma mark - Add to selection (private)

- (void)doAddObjectToSelection:(id)object
{
    if (object)
    {
        ArrayItemWrapper *targetWrapper = nil;
        
        //===
        
        NSArray *storeCopy = [NSArray arrayWithArray:_store];
        
        for (ArrayItemWrapper *wrapper in storeCopy)
        {
            if (_onEqualityCheck(wrapper.content, object))
            {
                targetWrapper = wrapper;
                break;
            }
        }
        
        //===
        
        if (targetWrapper &&
            !targetWrapper.selected)
        {
            targetWrapper.selected = YES;
            
            //===
            
            [self didChangeSelectionWithObject:targetWrapper.content
                                    changeType:kAddEMAChangeType];
        }
    }
}

- (void)doAddObjectAtIndexToSelection:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper)
    {
        targetWrapper.selected = YES;
        
        //===
        
        [self didChangeSelectionWithObject:targetWrapper.content
                                changeType:kAddEMAChangeType];
    }
}

#pragma mark - Add to selection

- (void)addObjectToSelection:(id)object
{
    dispatch_barrier_async(_operationQueue, ^{
        
        [self doAddObjectToSelection:object];
    });
}

- (void)addObjectAtIndexToSelection:(NSUInteger)index
{
    dispatch_barrier_async(_operationQueue, ^{
        
        [self doAddObjectAtIndexToSelection:index];
    });
}

- (void)addObjectsToSelection:(NSArray *)objectList
{
    dispatch_barrier_async(_operationQueue, ^{
        
        if (objectList.count)
        {
            for (id object in objectList)
            {
                [self doAddObjectToSelection:object];
            }
        }
        else
        {
            NSLog(@"Nothing to add to selection list.");
        }
    });
}

#pragma mark - Set selection

- (void)setObjectSelected:(id)object
{
    dispatch_barrier_async(_operationQueue, ^{
        
        [self doResetSelection];
        
        //===
        
        [self doAddObjectToSelection:object];
    });
}

- (void)setObjectAtIndexSelected:(NSUInteger)index
{
    dispatch_barrier_async(_operationQueue, ^{
        
        [self doResetSelection];
        
        //===
        
        [self doAddObjectAtIndexToSelection:index];
    });
}

- (void)setObjectsSelected:(NSArray *)objectList
{
    dispatch_barrier_async(_operationQueue, ^{
        
        [self doResetSelection];
        
        //===
        
        if (objectList.count)
        {
            for (id object in objectList)
            {
                [self doAddObjectToSelection:object];
            }
        }
        else
        {
            NSLog(@"Nothing to add to selection list.");
        }
    });
}

#pragma mark - Remove from selection

- (void)removeObjectFromSelection:(id)object
{
    if (object)
    {
        dispatch_barrier_async(_operationQueue, ^{
            
            ArrayItemWrapper *targetWrapper = nil;
            
            //===
            
            NSArray *storeCopy = [NSArray arrayWithArray:_store];
            
            for (ArrayItemWrapper *wrapper in storeCopy)
            {
                if (_onEqualityCheck(wrapper.content, object))
                {
                    targetWrapper = wrapper;
                    break;
                }
            }
            
            //===
            
            if (targetWrapper.selected)
            {
                targetWrapper.selected = NO;
                
                //===
                
                [self didChangeSelectionWithObject:targetWrapper.content
                                        changeType:kRemoveEMAChangeType];
            }
        });
    }
}

- (void)removeObjectAtIndexFromSelection:(NSUInteger)index
{
    dispatch_barrier_async(_operationQueue, ^{
        
        ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
        
        //===
        
        if (targetWrapper.selected)
        {
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithObject:targetWrapper.content
                                    changeType:kRemoveEMAChangeType];
        }
    });
}

- (void)removeObjectsFromSelection:(NSArray *)objectList
{
    for (id object in objectList)
    {
        [self removeObjectFromSelection:object];
    }
}

#pragma mark - Reset

- (void)doResetSelection
{
    NSArray *storeCopy = [NSArray arrayWithArray:_store];
    
    for (ArrayItemWrapper *wrapper in storeCopy)
    {
        if (wrapper.selected)
        {
            wrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithObject:wrapper.content
                                    changeType:kRemoveEMAChangeType];
        }
    }
}

- (void)resetSelection
{
    dispatch_barrier_async(_operationQueue, ^{
        
        [self doResetSelection];
    });
}

#pragma mark - Track selection

- (void)subscribe:(id)object forContentUpdates:(ExtArrayNotificationBlock)notificationBlock
{
    if (object && notificationBlock)
    {
        [self.contentNotifications setObject:notificationBlock
                                      forKey:object];
    }
}

- (void)unsubscribeFromContentUpdates:(id)object
{
    [self.contentNotifications removeObjectForKey:object];
}

- (void)subscribe:(id)object forSelectionUpdates:(ExtArrayNotificationBlock)notificationBlock
{
    if (object && notificationBlock)
    {
        [self.selectionNotifications setObject:notificationBlock
                                        forKey:object];
    }
}

- (void)unsubscribeFromSelectionUpdates:(id)object
{
    [self.selectionNotifications removeObjectForKey:object];
}

@end
