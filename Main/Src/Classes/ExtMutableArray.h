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

typedef enum {
    kAddEMAChangeType,
    kInsertEMAChangeType,
    kReplaceEMAChangeType,
    kRemoveEMAChangeType
} EMAChangeType;

typedef BOOL(^ExtArrayWillChangeSelection)(ExtMutableArray *array, id targetObject, EMAChangeType changeType);
typedef void(^ExtArrayDidChangeSelection)(ExtMutableArray *array, id targetObject, EMAChangeType changeType);

typedef void(^ExtArrayNotificationBlock)(id observer, ExtMutableArray *array, id targetObject, EMAChangeType changeType);

//===

@interface ExtMutableArray : NSMutableArray

@property (readonly, nonatomic) NSArray *selection;
@property (readonly, nonatomic) id selectedObject;

@property (nonatomic, copy) ExtArrayWillChangeSelection onWillChangeSelection;
@property (nonatomic, copy) ExtArrayDidChangeSelection onDidChangeSelection;

- (void)setObjectSelected:(id)object;
- (void)setObjectAtIndexSelected:(NSUInteger)index;
- (void)setObjectsSelected:(NSArray *)objectList;

- (void)addObjectToSelection:(id)object;
- (void)addObjectAtIndexToSelection:(NSUInteger)index;
- (void)addObjectsToSelection:(NSArray *)objectList;

- (void)removeObjectFromSelection:(id)object;
- (void)removeObjectAtIndexFromSelection:(NSUInteger)index;
- (void)removeObjectsFromSelection:(NSArray *)objectList;

- (void)resetSelection;

- (void)setOnWillChangeSelection:(ExtArrayWillChangeSelection)onWillChangeSelection;
- (void)setOnDidChangeSelection:(ExtArrayDidChangeSelection)onDidChangeSelection;

- (void)subscribe:(id)object forContentUpdates:(ExtArrayNotificationBlock)notificationBlock;
- (void)unsubscribeFromContentUpdates:(id)object;

- (void)subscribe:(id)object forSelectionUpdates:(ExtArrayNotificationBlock)notificationBlock;
- (void)unsubscribeFromSelectionUpdates:(id)object;

@end
