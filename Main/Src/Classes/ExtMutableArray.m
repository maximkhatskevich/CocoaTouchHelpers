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

@property (strong, nonatomic) NSMapTable *didChangeContentSubscriptions;
@property (strong, nonatomic) NSMapTable *willChangeSelectionSubscriptions;
@property (strong, nonatomic) NSMapTable *didChangeSelectionSubscriptions;

@end

@implementation ExtMutableArray

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
        
        [self didChangeContentWithObject:anObject
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
            
            [self
             didChangeSelectionWithObject:targetWrapper.content
             changeType:kRemoveEMAChangeType];
        }
        
        //===
        
        [_store
         insertObject:[ArrayItemWrapper wrapperWithContent:anObject]
         atIndex:index];
        
        //===
        
        if (targetWrapper)
        {
            [self didChangeContentWithObject:targetWrapper.content
                                          changeType:kRemoveEMAChangeType];
        }
        
        //===
        
        [self didChangeContentWithObject:anObject
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
            
            [self
             didChangeSelectionWithObject:targetWrapper.content
             changeType:kRemoveEMAChangeType];
        }
        
        //===
        
        [_store removeLastObject];
        
        //===
        
        [self didChangeContentWithObject:targetWrapper.content
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
            
            [self
             didChangeSelectionWithObject:targetWrapper.content
             changeType:kRemoveEMAChangeType];
        }
        
        //===
        
        [_store removeObjectAtIndex:index];
        
        //===
        
        if (targetWrapper)
        {
            [self didChangeContentWithObject:targetWrapper.content
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
                
                [self
                 didChangeSelectionWithObject:targetWrapper.content
                 changeType:kRemoveEMAChangeType];
            }
            
            //===
            
            [_store replaceObjectAtIndex:index
                              withObject:[ArrayItemWrapper wrapperWithContent:anObject]];
            
            //===
            
            [self didChangeContentWithObject:targetWrapper.content
                                          changeType:kRemoveEMAChangeType];
            
            //===
            
            [self didChangeContentWithObject:anObject
                                          changeType:kAddEMAChangeType];
        }
    }
}

#pragma mark - Property accessors

- (BOOL)moreItemsAvailalbe
{
    return (self.totalCount > self.count);
}

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

- (NSUInteger)selectedObjectIndex
{
    NSUInteger result = NSNotFound;
    
    //===
    
    NSArray *storeCopy = [NSArray arrayWithArray:_store];
    
    for (NSUInteger i = 0; i < storeCopy.count; i++)
    {
        ArrayItemWrapper *wrapper = storeCopy[i];
        
        if (wrapper.selected)
        {
            result = i;
            break;
        }
    }
    
    //===
    
    return result;
}

- (NSIndexSet *)selectedObjectsIndexSet
{
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    
    //===
    
    NSArray *storeCopy = [NSArray arrayWithArray:_store];
    
    for (NSUInteger i = 0; i < storeCopy.count; i++)
    {
        ArrayItemWrapper *wrapper = storeCopy[i];
        
        if (wrapper.selected)
        {
            [result addIndex:i];
        }
    }
    
    //===
    
    return [[NSIndexSet alloc] initWithIndexSet:result];
}

#pragma mark - Custom

- (void)setup
{
    _didChangeContentSubscriptions =
    [NSMapTable
     mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
     valueOptions:NSPointerFunctionsCopyIn];
    
    _willChangeSelectionSubscriptions =
    [NSMapTable
     mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
     valueOptions:NSPointerFunctionsCopyIn];
    
    _didChangeSelectionSubscriptions =
    [NSMapTable
     mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
     valueOptions:NSPointerFunctionsCopyIn];
    
    _onEqualityCheck = ^(id firstObject, id secondObject) {
        
        return [firstObject isEqual:secondObject];
    };
    
    _totalCount = 0;
}

- (void)didChangeContentWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    for (id key in [[self.didChangeContentSubscriptions keyEnumerator] allObjects])
    {
        ExtArrayDidChangeContentBlock block = [self.didChangeContentSubscriptions objectForKey:key];
        
        if (block)
        {
            block(key, self, targetObject, changeType);
        }
    }
}

- (BOOL)canChangeSelectionWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    BOOL result = YES;
    
    //===
    
    for (id key in [[self.willChangeSelectionSubscriptions keyEnumerator] allObjects])
    {
        ExtArrayWillChangeSelectionBlock block = [self.willChangeSelectionSubscriptions objectForKey:key];
        
        if (block)
        {
            result = block(key, self, targetObject, changeType);
        }
        
        //===
        
        if (!result)
        {
            break;
        }
    }
    
    //===
    
    return result;
}

- (void)didChangeSelectionWithObject:(id)targetObject changeType:(EMAChangeType)changeType
{
    for (id key in [[self.didChangeSelectionSubscriptions keyEnumerator] allObjects])
    {
        ExtArrayDidChangeSelectionBlock block = [self.didChangeSelectionSubscriptions objectForKey:key];
        
        if (block)
        {
            block(key, self, targetObject, changeType);
        }
    }
}

#pragma mark - Add to selection

- (void)addToSelectionObject:(id)object
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
            BOOL canProceed =
            [self canChangeSelectionWithObject:targetWrapper.content
                                       changeType:kAddEMAChangeType];
            
            //===
            
            if (canProceed)
            {
                targetWrapper.selected = YES;
                
                //===
                
                [self
                 didChangeSelectionWithObject:targetWrapper.content
                 changeType:kAddEMAChangeType];
            }
        }
    }
    else
    {
        NSLog(@"Nothing to add to selection list.");
    }
}

- (void)addToSelectionObjectAtIndex:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper &&
        !targetWrapper.selected)
    {
        BOOL canProceed =
        [self canChangeSelectionWithObject:targetWrapper.content
                                   changeType:kAddEMAChangeType];
        
        //===
        
        if (canProceed)
        {
            targetWrapper.selected = YES;
            
            //===
            
            [self
             didChangeSelectionWithObject:targetWrapper.content
             changeType:kAddEMAChangeType];
        }
    }
}

- (void)addToSelectionObjects:(NSArray *)objectList
{
    if (objectList.count)
    {
        for (id object in objectList)
        {
            [self addToSelectionObject:object];
        }
    }
    else
    {
        NSLog(@"Nothing to add to selection list.");
    }
}

#pragma mark - Set selection

- (void)setSelectedObject:(id)object
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
        
        [self addToSelectionObject:object];
    }
}

- (void)setSelectedObjectAtIndex:(NSUInteger)index
{
    NSArray *selection = self.selection;
    
    //===
    
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    BOOL multiSelection = (selection.count > 1);
    
    //===
    
    if (targetWrapper) // index MUST be valid !!!
    {
        if (!targetWrapper.selected || multiSelection)
        {
            [self resetSelection];
            
            //===
            
            [self addToSelectionObjectAtIndex:index];
        }
    }
}

- (void)setSelectedObjects:(NSArray *)objectList
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
                [self addToSelectionObject:object];
            }
        }
    }
    else
    {
        NSLog(@"Nothing to add to selection list.");
    }
}

#pragma mark - Remove from selection

- (void)removeFromSelectionObject:(id)object
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
            BOOL canProceed =
            [self canChangeSelectionWithObject:targetWrapper.content
                                       changeType:kRemoveEMAChangeType];
            
            //===
            
            if (canProceed)
            {
                targetWrapper.selected = NO;
                
                //===
                
                [self
                 didChangeSelectionWithObject:targetWrapper.content
                 changeType:kRemoveEMAChangeType];
            }
        }
    }
}

- (void)removeFromSelectionObjectAtIndex:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [_store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper.selected)
    {
        BOOL canProceed =
        [self canChangeSelectionWithObject:targetWrapper.content
                                   changeType:kRemoveEMAChangeType];
        
        //===
        
        if (canProceed)
        {
            targetWrapper.selected = NO;
            
            //===
            
            [self
             didChangeSelectionWithObject:targetWrapper.content
             changeType:kRemoveEMAChangeType];
        }
    }
}

- (void)removeFromSelectionObjects:(NSArray *)objectList
{
    for (id object in objectList)
    {
        [self removeFromSelectionObject:object];
    }
}

#pragma mark - Reset

- (void)resetSelection
{
    NSArray *storeCopy = [NSArray arrayWithArray:_store];
    
    for (ArrayItemWrapper *targetWrapper in storeCopy)
    {
        if (targetWrapper.selected)
        {
            BOOL canProceed =
            [self canChangeSelectionWithObject:targetWrapper.content
                                       changeType:kRemoveEMAChangeType];
            
            //===
            
            if (canProceed)
            {
                targetWrapper.selected = NO;
                
                //===
                
                [self
                 didChangeSelectionWithObject:targetWrapper.content
                 changeType:kRemoveEMAChangeType];
            }
        }
    }
}

#pragma mark - Track changes

- (void)notify:(id)object onDidChangeContent:(ExtArrayDidChangeContentBlock)notificationBlock
{
    if (object && notificationBlock)
    {
        [self.didChangeContentSubscriptions
         setObject:notificationBlock
         forKey:object];
    }
}

- (void)cancelDidChangeContentNotificationsFor:(id)object
{
    [self.didChangeContentSubscriptions removeObjectForKey:object];
}

- (void)notify:(id)object onWillChangeSelection:(ExtArrayWillChangeSelectionBlock)notificationBlock
{
    if (object && notificationBlock)
    {
        [self.willChangeSelectionSubscriptions
         setObject:notificationBlock
         forKey:object];
    }
}

- (void)cancelWillChangeSelectionNotificationsFor:(id)object
{
    [self.willChangeSelectionSubscriptions removeObjectForKey:object];
}

- (void)notify:(id)object onDidChangeSelection:(ExtArrayDidChangeSelectionBlock)notificationBlock
{
    if (object && notificationBlock)
    {
        [self.didChangeSelectionSubscriptions
         setObject:notificationBlock
         forKey:object];
    }
}

- (void)cancelDidChangeSelectionNotificationsFor:(id)object
{
    [self.didChangeSelectionSubscriptions removeObjectForKey:object];
}

@end
