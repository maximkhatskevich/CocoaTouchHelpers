//
//  CTHMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHMutableArray.h"

#import "NSArray+Helpers.h"
#import "NSMutableArray+Helpers.h"
#import "ArrayItemWrapper.h"
#import "NSObject+CTHSubscriptions.h"
#import "MacrosBase.h"

//===

@interface CTHMAResetParamSet ()

@property (strong, nonatomic) CTHMutableArray *array;
@property (copy, nonatomic) NSArray *oldValues;
@property (copy, nonatomic) NSArray *newValues;

@end

//===

@interface CTHMAChangeParamSet ()

@property (strong, nonatomic) CTHMutableArray *array;
@property CTHMAChangeType changeType;
@property NSUInteger targetIndex;
@property (strong, nonatomic) id oldValue;
@property (strong, nonatomic) id newValue;

@end

//===

@interface CTHMutableArray ()

// backing store
@property (strong, nonatomic) NSMutableArray *store;

@property (readonly, nonatomic) NSMapTable *willResetContentSubscriptions;
@property (readonly, nonatomic) NSMapTable *didResetContentSubscriptions;
@property (readonly, nonatomic) NSMapTable *willChangeContentSubscriptions;
@property (readonly, nonatomic) NSMapTable *didChangeContentSubscriptions;
@property (readonly, nonatomic) NSMapTable *willChangeSelectionSubscriptions;
@property (readonly, nonatomic) NSMapTable *didChangeSelectionSubscriptions;

@end

@implementation CTHMutableArray
{
    BOOL _batchUpdate;
}

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        self.store = [NSMutableArray array];
        
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
        self.store = [NSMutableArray arrayWithCapacity:numItems];
        
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
        self.store = [NSMutableArray array];
        
        for (int i = 0; i < count; i++)
        {
            [self.store addObject:
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
    return self.store.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return ((ArrayItemWrapper *)[self.store safeObjectAtIndex:index]).content;
}

#pragma mark - Overrided methods - NSMutableArray

- (void)addObject:(id)anObject
{
    if (anObject)
    {
        CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
        
        params.array = self;
        params.changeType = kInsertionCTHMAChangeType;
        params.targetIndex = self.count; // !!!
        params.newValue = anObject;
        
        //===
        
        [self willChangeContentWithParams:params];
        
        //===
        
        [self.store addObject:
         [ArrayItemWrapper wrapperWithContent:anObject]];
        
        //===
        
        [self didChangeContentWithParams:params];
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject &&
        (self.count <= index))
    {
        CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
        
        params.array = self;
        params.changeType = kInsertionCTHMAChangeType;
        params.targetIndex = index;
        params.newValue = anObject;
        
        //===
        
        [self willChangeContentWithParams:params];
        
        //===
        
        ArrayItemWrapper *newWrapper = [ArrayItemWrapper wrapperWithContent:anObject];
        
        [self.store
         insertObject:newWrapper
         atIndex:index];
        
        //===
        
        [self didChangeContentWithParams:params];
    }
}

- (void)removeLastObject
{
    ArrayItemWrapper *targetWrapper = [self.store lastObject];
    
    //===
    
    if (targetWrapper)
    {
        CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
        
        params.array = self;
        params.changeType = kRemovalCTHMAChangeType;
        params.targetIndex = (self.count - 1);
        params.oldValue = targetWrapper.content;
        
        //===
        
        if (targetWrapper.selected)
        {
            [self willChangeSelectionWithParams:params];
            
            //===
            
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithParams:params];
        }
        
        //===
        
        [self willChangeContentWithParams:params];
        
        //===
        
        [self.store removeLastObject];
        
        //===
        
        [self didChangeContentWithParams:params];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [self.store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper)
    {
        CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
        
        params.array = self;
        params.changeType = kRemovalCTHMAChangeType;
        params.targetIndex = index;
        params.oldValue = targetWrapper.content;
        
        //===
        
        if (targetWrapper.selected)
        {
            [self willChangeSelectionWithParams:params];
            
            //===
            
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithParams:params];
        }
        
        //===
        
        [self willChangeContentWithParams:params];
        
        //===
        
        [self.store removeObjectAtIndex:index];
        
        //===
        
        [self didChangeContentWithParams:params];
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject)
    {
        ArrayItemWrapper *currentWrapper = [self.store safeObjectAtIndex:index];
        
        //===
        
        if (currentWrapper)
        {
            CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
            
            params.array = self;
            params.changeType = kReplacementCTHMAChangeType;
            params.targetIndex = index;
            params.oldValue = currentWrapper.content;
            params.newValue = anObject;
            
            //===
            
            BOOL wasSelected = currentWrapper.selected;
            ArrayItemWrapper *newWrapper = [ArrayItemWrapper wrapperWithContent:anObject];
            
            //===
            
            if (wasSelected)
            {
                [self willChangeSelectionWithParams:params];
            }
            
            [self willChangeContentWithParams:params];
            
            //===
            
            if (wasSelected)
            {
                currentWrapper.selected = NO;
                newWrapper.selected = YES;
            }
            
            [self.store
             replaceObjectAtIndex:index
             withObject:newWrapper];
            
            //===
            
            [self didChangeContentWithParams:params];
            
            if (wasSelected)
            {
                [self didChangeSelectionWithParams:params];
            }
        }
    }
}

#pragma mark - Overrided methods

- (void)safeAddUniqueObject:(id)object
{
    // NOTE: completely override!
    
    if (object)
    {
        BOOL canProceed = YES;
        
        //===
        
        for (id item in self)
        {
            if (self.onEqualityCheck(item, object))
            {
                // an equal/same object is found in array,
                // so no need to add new instance, because it should be unique
                
                canProceed = NO;
            }
        }
        
        //===
        
        if (canProceed)
        {
            [self addObject:object];
        }
    }
}

#pragma mark - Property accessors

- (NSMapTable *)willResetContentSubscriptions
{
    return [self subscriptionForKey:@"willResetContentSubscriptions"];
}

- (NSMapTable *)didResetContentSubscriptions
{
    return [self subscriptionForKey:@"didResetContentSubscriptions"];
}

- (NSMapTable *)willChangeContentSubscriptions
{
    return [self subscriptionForKey:@"willChangeContentSubscriptions"];
}

- (NSMapTable *)didChangeContentSubscriptions
{
    return [self subscriptionForKey:@"didChangeContentSubscriptions"];
}

- (NSMapTable *)willChangeSelectionSubscriptions
{
    return [self subscriptionForKey:@"willChangeSelectionSubscriptions"];
}

- (NSMapTable *)didChangeSelectionSubscriptions
{
    return [self subscriptionForKey:@"didChangeSelectionSubscriptions"];
}

- (BOOL)moreItemsAvailalbe
{
    return (self.totalCount > self.count);
}

- (NSArray *)selection
{
    NSMutableArray *result = [NSMutableArray array];
    
    //===
    
    for (ArrayItemWrapper *wrapper in self.store)
    {
        if (wrapper.selected)
        {
            [result addObject:wrapper.content];
        }
    }
    
    //===
    
    return [result copy];
}

- (id)selectedObject
{
    return self.selection.firstObject;
}

- (NSUInteger)selectedObjectIndex
{
    NSUInteger result = NSNotFound;
    
    //===
    
    for (NSUInteger i = 0; i < self.store.count; i++)
    {
        ArrayItemWrapper *wrapper = self.store[i];
        
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
    
    for (NSUInteger i = 0; i < self.store.count; i++)
    {
        ArrayItemWrapper *wrapper = self.store[i];
        
        if (wrapper.selected)
        {
            [result addIndex:i];
        }
    }
    
    //===
    
    return [result copy];
}

#pragma mark - Custom

- (void)setup
{
    _batchUpdate = NO;
    
    self.onEqualityCheck = ^(id firstObject, id secondObject) {
        
        return [firstObject isEqual:secondObject];
    };
    
    self.totalCount = 0;
}

- (void)setObjectsFromArray:(NSArray *)otherArray
{
    CTHMAResetParamSet *params = [CTHMAResetParamSet new];
    
    params.array = self;
    params.oldValues = self;
    params.newValues = otherArray;
    
    //===
    
    [self willResetContentWithParams:params];
    
    //===
    
    [self removeAllObjects];
    [self addObjectsFromArray:otherArray];
    
    //===
    
    [self didResetContentWithParams:params];
}

#pragma mark - Add to selection

- (void)addToSelectionObject:(id)newObject
{
    if (newObject)
    {
        ArrayItemWrapper *targetWrapper = nil;
        NSUInteger targetIndex = NSNotFound;
        
        //===
        
        for (NSUInteger i = 0; i < self.store.count; i++)
        {
            ArrayItemWrapper *wrapper = self.store[i];
            
            if (self.onEqualityCheck(wrapper.content, newObject))
            {
                targetWrapper = wrapper;
                targetIndex = i;
                break;
            }
        }
        
        //===
        
        if (targetWrapper &&
            !targetWrapper.selected)
        {
            CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
            
            params.array = self;
            params.changeType = kInsertionCTHMAChangeType;
            params.targetIndex = targetIndex;
            params.newValue = newObject;
            
            //===
            
            [self willChangeSelectionWithParams:params];
            
            //===
            
            targetWrapper.selected = YES;
            
            //===
            
            [self didChangeSelectionWithParams:params];
        }
    }
}

- (void)addToSelectionObjectAtIndex:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [self.store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper &&
        !targetWrapper.selected)
    {
        CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
        
        params.array = self;
        params.changeType = kInsertionCTHMAChangeType;
        params.targetIndex = index;
        params.newValue = targetWrapper.content;
        
        //===
        
        [self willChangeSelectionWithParams:params];
        
        //===
        
        targetWrapper.selected = YES;
        
        //===
        
        [self didChangeSelectionWithParams:params];
    }
}

- (void)addToSelectionObjects:(NSArray *)objectList
{
    for (id object in objectList)
    {
        [self addToSelectionObject:object];
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
        if (self.onEqualityCheck(selectedObject, object))
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
    
    ArrayItemWrapper *targetWrapper = [self.store safeObjectAtIndex:index];
    BOOL otherSelectedObjects = (selection.count > 1);
    
    //===
    
    if (targetWrapper)
    {
        if (!targetWrapper.selected || otherSelectedObjects)
        {
            [self resetSelection];
            
            //===
            
            [self addToSelectionObjectAtIndex:index];
        }
    }
}

- (void)setSelectedObjects:(NSArray *)newSelection
{
    NSArray *selection = self.selection;
    
    //===
    
    if (newSelection.count)
    {
        // lets check if current and target selection objects are identical?
        
        NSMutableArray *newSelectionCopy = [NSMutableArray arrayWithArray:newSelection];
        NSMutableArray *selectionCopy = [NSMutableArray arrayWithArray:selection];
        
        for (id selectedObject in selection)
        {
            // we should check each item with each item in the other array
            
            for (id targetObject in newSelection)
            {
                if (self.onEqualityCheck(selectedObject, targetObject)) // !!!
                {
                    [newSelectionCopy removeObject:targetObject];
                    [selectionCopy removeObject:selectedObject];
                }
            }
        }
        
        //===
        
        // proceed if NOT fully identical
        
        if (newSelectionCopy.count || selectionCopy.count)
        {
            [self resetSelection];
            
            //===
            
            for (id newSelectedObject in newSelection)
            {
                [self addToSelectionObject:newSelectedObject];
            }
        }
    }
}

#pragma mark - Remove from selection

- (void)removeFromSelectionObject:(id)object
{
    if (object)
    {
        ArrayItemWrapper *targetWrapper = nil;
        NSUInteger targetIndex = NSNotFound;
        
        //===
        
        for (NSUInteger i = 0; i < self.store.count; i++)
        {
            ArrayItemWrapper *wrapper = self.store[i];
            
            if (self.onEqualityCheck(wrapper.content, object))
            {
                targetWrapper = wrapper;
                targetIndex = i;
                break;
            }
        }
        
        //===
        
        if (targetWrapper.selected)
        {
            CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
            
            params.array = self;
            params.changeType = kRemovalCTHMAChangeType;
            params.targetIndex = (self.count - 1);
            params.oldValue = targetWrapper.content;
            
            //===
            
            [self willChangeSelectionWithParams:params];
            
            //===
            
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithParams:params];
        }
    }
}

- (void)removeFromSelectionObjectAtIndex:(NSUInteger)index
{
    ArrayItemWrapper *targetWrapper = [self.store safeObjectAtIndex:index];
    
    //===
    
    if (targetWrapper.selected)
    {
        CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
        
        params.array = self;
        params.changeType = kRemovalCTHMAChangeType;
        params.targetIndex = (self.count - 1);
        params.oldValue = targetWrapper.content;
        
        //===
        
        [self willChangeSelectionWithParams:params];
        
        //===
        
        targetWrapper.selected = NO;
        
        //===
        
        [self didChangeSelectionWithParams:params];
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
    for (NSUInteger i = 0; i < self.store.count; i++)
    {
        ArrayItemWrapper *targetWrapper = self.store[i];
        
        if (targetWrapper.selected)
        {
            CTHMAChangeParamSet *params = [CTHMAChangeParamSet new];
            
            params.array = self;
            params.changeType = kRemovalCTHMAChangeType;
            params.targetIndex = i;
            params.oldValue = targetWrapper.content;
            
            //===
            
            [self willChangeSelectionWithParams:params];
            
            //===
            
            targetWrapper.selected = NO;
            
            //===
            
            [self didChangeSelectionWithParams:params];
        }
    }
}

#pragma mark - Notifications - Public

- (NSString *)notifyOnWillResetContent:(CTHMAResetNotificationBlock)notificationBlock
{
    return [self
            addNotification:notificationBlock
            targetTable:self.willResetContentSubscriptions];
}

- (NSString *)notifyOnDidResetContent:(CTHMAResetNotificationBlock)notificationBlock
{
    return [self
            addNotification:notificationBlock
            targetTable:self.didResetContentSubscriptions];
}

- (NSString *)notifyOnWillChangeContent:(CTHMAChangeNotificationBlock)notificationBlock
{
    return [self
            addNotification:notificationBlock
            targetTable:self.willChangeContentSubscriptions];
}

- (NSString *)notifyOnDidChangeContent:(CTHMAChangeNotificationBlock)notificationBlock
{
    return [self
            addNotification:notificationBlock
            targetTable:self.didChangeContentSubscriptions];
}

- (NSString *)notifyOnWillChangeSelection:(CTHMAChangeNotificationBlock)notificationBlock
{
    return [self
            addNotification:notificationBlock
            targetTable:self.willChangeSelectionSubscriptions];
}

- (NSString *)notifyOnDidChangeSelection:(CTHMAChangeNotificationBlock)notificationBlock
{
    return [self
            addNotification:notificationBlock
            targetTable:self.didChangeSelectionSubscriptions];
}

- (BOOL)cancelNotificationWithId:(NSString *)notificationId
{
    BOOL result = NO;
    
    //===
    
    result = [self
              removeNotificationWithId:notificationId
              fromTable:self.willResetContentSubscriptions];
    
    if (!result)
    {
        result = [self
                  removeNotificationWithId:notificationId
                  fromTable:self.didResetContentSubscriptions];
    }
    
    if (!result)
    {
        result = [self
                  removeNotificationWithId:notificationId
                  fromTable:self.willChangeContentSubscriptions];
    }
    
    if (!result)
    {
        result = [self
                  removeNotificationWithId:notificationId
                  fromTable:self.didChangeContentSubscriptions];
    }
    
    if (!result)
    {
        result = [self
                  removeNotificationWithId:notificationId
                  fromTable:self.willChangeSelectionSubscriptions];
    }
    
    if (!result)
    {
        result = [self
                  removeNotificationWithId:notificationId
                  fromTable:self.didChangeSelectionSubscriptions];
    }
    
    //===
    
    return result;
}

#pragma mark - Notifications - Private - Manage

- (NSString *)addNotification:(id)notificationBlock
                  targetTable:(NSMapTable *)targetTable
{
    NSString *result = nil; // target notification id
    
    //===
    
    if (notificationBlock)
    {
        result = [[NSProcessInfo processInfo] globallyUniqueString];
        
        //===
        
        if (isNonZeroString(result))
        {
            [targetTable
             setObject:notificationBlock
             forKey:result];
        }
    }
    
    //===
    
    return result;
}

- (BOOL)removeNotificationWithId:(NSString *)notificationId
                       fromTable:(NSMapTable *)targetTable
{
    BOOL result = NO;
    
    //===
    
    for (id key in [[targetTable keyEnumerator] allObjects])
    {
        if ([key isEqualToString:notificationId])
        {
            result = YES;
            break;
        }
    }
    
    //===
    
    if (result)
    {
        [targetTable removeObjectForKey:notificationId];
    }
    
    //===
    
    return result;
}

#pragma mark - Notifications - Private - Send notifications

- (void)notifyAboutResetWithTable:(NSMapTable *)targetTable
                           params:(CTHMAResetParamSet *)params
{
    for (id key in [[targetTable keyEnumerator] allObjects])
    {
        CTHMAResetNotificationBlock block = [targetTable objectForKey:key];
        
        if (block)
        {
            block(params);
        }
    }
}

- (void)willResetContentWithParams:(CTHMAResetParamSet *)params
{
    _batchUpdate = YES;
    
    //===
    
    [self
     notifyAboutResetWithTable:self.willResetContentSubscriptions
     params:params];
}

- (void)didResetContentWithParams:(CTHMAResetParamSet *)params
{
    [self
     notifyAboutResetWithTable:self.didResetContentSubscriptions
     params:params];
    
    //===
    
    _batchUpdate = NO;
}

- (void)notifyAboutChangeWithTable:(NSMapTable *)targetTable
                            params:(CTHMAChangeParamSet *)params
{
    if (!_batchUpdate)
    {
        for (id key in [[targetTable keyEnumerator] allObjects])
        {
            CTHMAChangeNotificationBlock block = [targetTable objectForKey:key];
            
            if (block)
            {
                block(params);
            }
        }
    }
}

- (void)willChangeContentWithParams:(CTHMAChangeParamSet *)params
{
    [self
     notifyAboutChangeWithTable:self.willChangeContentSubscriptions
     params:params];
}

- (void)didChangeContentWithParams:(CTHMAChangeParamSet *)params
{
    [self
     notifyAboutChangeWithTable:self.didChangeContentSubscriptions
     params:params];
}

- (void)willChangeSelectionWithParams:(CTHMAChangeParamSet *)params
{
    [self
     notifyAboutChangeWithTable:self.willChangeSelectionSubscriptions
     params:params];
}

- (void)didChangeSelectionWithParams:(CTHMAChangeParamSet *)params
{
    [self
     notifyAboutChangeWithTable:self.didChangeSelectionSubscriptions
     params:params];
}

@end
