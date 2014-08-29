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
    NSMutableArray *result = [NSMutableArray array];
    
    //===
    
    NSArray *storeCopy = [NSArray arrayWithArray:_store];
    
    for (ArrayItemWrapper *wrapper in storeCopy)
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
    return _store.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return ((ArrayItemWrapper *)_store[index]).content;
}

#pragma mark - Overrided methods - NSMutableArray

- (void)addObject:(id)anObject
{
    if (anObject)
    {
        [_store addObject:
         [ArrayItemWrapper wrapperWithContent:anObject]];
        
        //===
        
        [self notifyAboutContentChangeWithObject:anObject
                                      changeType:kAddEMAChangeType];
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject)
    {
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
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray
{
    [super addObjectsFromArray:otherArray];
}

- (void)removeLastObject
{
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
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
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
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject)
    {
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
            block(key, self, targetObject, changeType);
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
            block(key, self, targetObject, changeType);
        }
    }
}

#pragma mark - Add to selection

- (void)addObjectToSelection:(id)object
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

- (void)addObjectAtIndexToSelection:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    
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
    NSArray *selection = self.selection;
    
    //===
    
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
        [self resetSelection];
        
        //===
        
        [self addObjectToSelection:object];
    }
}

- (void)setObjectAtIndexSelected:(NSUInteger)index
{
    NSArray *selection = self.selection;
    
    //===
    
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    BOOL multiSelection = (selection.count > 1);
    
    //===
    
    if (!targetWrapper.selected || multiSelection)
    {
        [self resetSelection];
        
        //===
        
        [self addObjectAtIndexToSelection:index];
    }
}

- (void)setObjectsSelected:(NSArray *)objectList
{
    NSArray *selection = self.selection;
    
    //===
    
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
            [self resetSelection];
            
            //===
            
            for (id object in objectList)
            {
                [self addObjectToSelection:object];
            }
        }
    }
    else
    {
        NSLog(@"Nothing to add to selection list.");
    }
}

#pragma mark - Remove from selection

- (void)removeObjectFromSelection:(id)object
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
        
        if (targetWrapper.selected)
        {
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithObject:targetWrapper.content
                                    changeType:kRemoveEMAChangeType];
        }
    }
}

- (void)removeObjectAtIndexFromSelection:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper.selected)
    {
        targetWrapper.selected = NO;
        
        //===
        
        [self didChangeSelectionWithObject:targetWrapper.content
                                changeType:kRemoveEMAChangeType];
    }
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
