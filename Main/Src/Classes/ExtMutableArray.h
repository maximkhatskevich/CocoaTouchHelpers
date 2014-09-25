//
//  ExtMutableArray.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

//===

@class ExtMutableArray;

//===

typedef enum {
    kAddEMAChangeType,
    kRemoveEMAChangeType
} EMAChangeType;

//===

typedef BOOL(^ExtArrayEqualityCheck)(id firstObject, id secondObject);
typedef BOOL(^ExtArrayWillChangeSelection)(ExtMutableArray *array, id targetObject, EMAChangeType changeType);
typedef void(^ExtArrayDidChangeSelection)(ExtMutableArray *array, id targetObject, EMAChangeType changeType);

typedef void(^ExtArrayNotificationBlock)(id observer, ExtMutableArray *array, id targetObject, EMAChangeType changeType);

//===

@interface ExtMutableArray : NSMutableArray

// pagination support:
@property NSUInteger totalCount;
@property (readonly) BOOL moreItemsAvailalbe;

@property (readonly, nonatomic) NSArray *selection;
@property (readonly, nonatomic) id selectedObject;

// indesxes of all selected objects:
@property (readonly) NSIndexSet *selectedObjectsIndexSet;
// index of FIRST selected object, if any:
@property (readonly) NSUInteger selectedObjectIndex;

@property (nonatomic, copy) ExtArrayEqualityCheck onEqualityCheck;

- (void)addToSelectionObject:(id)object;
- (void)addToSelectionObjectAtIndex:(NSUInteger)index;
- (void)addToSelectionObjects:(NSArray *)objectList;

- (void)setSelectedObject:(id)object;
- (void)setSelectedObjectAtIndex:(NSUInteger)index;
- (void)setSelectedObjects:(NSArray *)objectList;

- (void)removeFromSelectionObject:(id)object;
- (void)removeFromSelectionObjectAtIndex:(NSUInteger)index;
- (void)removeFromSelectionObjects:(NSArray *)objectList;

- (void)resetSelection;

- (void)subscribe:(id)object forContentUpdates:(ExtArrayNotificationBlock)notificationBlock;
- (void)unsubscribeFromContentUpdates:(id)object;

- (void)subscribe:(id)object forSelectionUpdates:(ExtArrayNotificationBlock)notificationBlock;
- (void)unsubscribeFromSelectionUpdates:(id)object;

@end
