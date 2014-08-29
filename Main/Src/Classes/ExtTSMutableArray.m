//
//  ExtTSMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtTSMutableArray.h"

#import "NSArray+Helpers.h"
#import "ArrayItemWrapper.h"

//===

@interface ExtTSMutableArray ()

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@property (strong, nonatomic) NSMapTable *contentNotifications;
@property (strong, nonatomic) NSMapTable *selectionNotifications;

@end

@implementation ExtTSMutableArray

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
        
        for (int i = 0; i < count; i++)
        {
            [_store addObject:
             [ArrayItemWrapper wrapperWithContent:objects[i]]];
        }
        
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
                                          changeType:kAddETSMAChangeType];
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
                                        changeType:kRemoveETSMAChangeType];
            }
            
            //===
            
            [_store
             insertObject:[ArrayItemWrapper wrapperWithContent:anObject]
             atIndex:index];
            
            //===
            
            if (targetWrapper)
            {
                [self notifyAboutContentChangeWithObject:targetWrapper.content
                                              changeType:kRemoveETSMAChangeType];
            }
            
            //===
            
            [self notifyAboutContentChangeWithObject:anObject
                                          changeType:kAddETSMAChangeType];
        });
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray
{
    [super addObjectsFromArray:otherArray];
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
                                        changeType:kRemoveETSMAChangeType];
            }
            
            //===
            
            [_store removeLastObject];
            
            //===
            
            [self notifyAboutContentChangeWithObject:targetWrapper.content
                                          changeType:kRemoveETSMAChangeType];
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
                                        changeType:kRemoveETSMAChangeType];
            }
            
            //===
            
            [_store removeObjectAtIndex:index];
            
            //===
            
            if (targetWrapper)
            {
                [self notifyAboutContentChangeWithObject:targetWrapper.content
                                              changeType:kRemoveETSMAChangeType];
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
                                            changeType:kRemoveETSMAChangeType];
                }
                
                //===
                
                [_store replaceObjectAtIndex:index
                                  withObject:[ArrayItemWrapper wrapperWithContent:anObject]];
                
                //===
                
                [self notifyAboutContentChangeWithObject:targetWrapper.content
                                              changeType:kRemoveETSMAChangeType];
                
                //===
                
                [self notifyAboutContentChangeWithObject:anObject
                                              changeType:kAddETSMAChangeType];
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

- (void)didChangeSelectionWithObject:(id)targetObject changeType:(ETSMAChangeType)changeType
{

    [self notifyAboutSelectionChangeWithObject:targetObject changeType:changeType];
}

- (void)notifyAboutContentChangeWithObject:(id)targetObject changeType:(ETSMAChangeType)changeType
{
    for (id key in [[self.contentNotifications keyEnumerator] allObjects])
    {
        ExtTSArrayNotificationBlock block = [self.contentNotifications objectForKey:key];
        
        if (block)
        {
            [self.notificationQueue addOperationWithBlock:^{
                
                block(key, self, targetObject, changeType);
            }];
        }
    }
}

- (void)notifyAboutSelectionChangeWithObject:(id)targetObject changeType:(ETSMAChangeType)changeType
{
    for (id key in [[self.selectionNotifications keyEnumerator] allObjects])
    {
        ExtTSArrayNotificationBlock block = [self.selectionNotifications objectForKey:key];
        
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
                                    changeType:kAddETSMAChangeType];
        }
    }
}

- (void)doAddObjectAtIndexToSelection:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper &&
        !targetWrapper.selected)
    {
        targetWrapper.selected = YES;
        
        //===
        
        [self didChangeSelectionWithObject:targetWrapper.content
                                changeType:kAddETSMAChangeType];
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
    NSArray *selection = self.selection;
    
    //===
    
    dispatch_barrier_async(_operationQueue, ^{
        
        BOOL alreadySelected = NO;
        BOOL otherSelectedObjects = NO;
        
        for (id selectedObject in selection)
        {
            if (_onEqualityCheck(selectedObject, object))
            {
                alreadySelected = YES;
                break;
            }
            else
            {
                otherSelectedObjects = YES;
            }
        }
        
        //===
        
        if (!alreadySelected || otherSelectedObjects)
        {
            [self doResetSelection];
            
            //===
            
            [self doAddObjectToSelection:object];
        }
    });
}

- (void)setObjectAtIndexSelected:(NSUInteger)index
{
    NSArray *selection = self.selection;
    
    //===
    
    dispatch_barrier_async(_operationQueue, ^{
        
        ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
        BOOL multiSelection = (selection.count > 1);
        
        //===
        
        if (!targetWrapper.selected || multiSelection)
        {
            [self doResetSelection];
            
            //===
            
            [self doAddObjectAtIndexToSelection:index];
        }
    });
}

- (void)setObjectsSelected:(NSArray *)objectList
{
    NSArray *selection = self.selection;
    
    //===
    
    dispatch_barrier_async(_operationQueue, ^{
        
        if (objectList.count)
        {
            // lets check if current and target selection objects are identical?
            
            NSMutableArray *targetCopyList = [NSMutableArray arrayWithArray:objectList];
            NSMutableArray *selectionCopyList = [NSMutableArray arrayWithArray:selection];
            
            for (id selectedObject in selection)
            {
                for (id targetObject in objectList)
                {
                    if (_onEqualityCheck(selectedObject, targetObject))
                    {
                        [targetCopyList removeObject:targetObject];
                        [selectionCopyList removeObject:selectedObject];
                    }
                }
            }
            
            //===
            
            // proceed if NOT fully identical
            
            if (targetCopyList.count || selectionCopyList.count)
            {
                [self doResetSelection];
                
                //===
                
                for (id object in objectList)
                {
                    [self doAddObjectToSelection:object];
                }
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
                                        changeType:kRemoveETSMAChangeType];
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
                                    changeType:kRemoveETSMAChangeType];
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
                                    changeType:kRemoveETSMAChangeType];
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

- (void)subscribe:(id)object forContentUpdates:(ExtTSArrayNotificationBlock)notificationBlock
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

- (void)subscribe:(id)object forSelectionUpdates:(ExtTSArrayNotificationBlock)notificationBlock
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
