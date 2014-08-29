//
//  ExtTSMutableArray.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

//===

@class ExtTSMutableArray;

typedef enum {
    kAddETSMAChangeType,
    kRemoveETSMAChangeType
} ETSMAChangeType;

typedef BOOL(^ExtTSArrayEqualityCheck)(id firstObject, id secondObject);
typedef BOOL(^ExtTSArrayWillChangeSelection)(ExtTSMutableArray *array, id targetObject, ETSMAChangeType changeType);
typedef void(^ExtTSArrayDidChangeSelection)(ExtTSMutableArray *array, id targetObject, ETSMAChangeType changeType);

typedef void(^ExtTSArrayNotificationBlock)(id observer, ExtTSMutableArray *array, id targetObject, ETSMAChangeType changeType);

//===

@interface ExtTSMutableArray : NSMutableArray

@property (readonly, nonatomic) NSArray *selection;
@property (readonly, nonatomic) id selectedObject;

@property (nonatomic, copy) ExtTSArrayEqualityCheck onEqualityCheck;

@property (strong, nonatomic) dispatch_queue_t operationQueue;
@property (strong, nonatomic) NSOperationQueue *notificationQueue;

- (void)addObjectToSelection:(id)object;
- (void)addObjectAtIndexToSelection:(NSUInteger)index;
- (void)addObjectsToSelection:(NSArray *)objectList;

- (void)setObjectSelected:(id)object;
- (void)setObjectAtIndexSelected:(NSUInteger)index;
- (void)setObjectsSelected:(NSArray *)objectList;

- (void)removeObjectFromSelection:(id)object;
- (void)removeObjectAtIndexFromSelection:(NSUInteger)index;
- (void)removeObjectsFromSelection:(NSArray *)objectList;

- (void)resetSelection;

- (void)subscribe:(id)object forContentUpdates:(ExtTSArrayNotificationBlock)notificationBlock;
- (void)unsubscribeFromContentUpdates:(id)object;

- (void)subscribe:(id)object forSelectionUpdates:(ExtTSArrayNotificationBlock)notificationBlock;
- (void)unsubscribeFromSelectionUpdates:(id)object;

@end
