//
//  CTHMutableArray.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

//===

@class CTHMutableArray;
@class CTHMAResetParamSet;
@class CTHMAChangeParamSet;

//===

typedef enum
{
    kInsertionCTHMAChangeType,
    kRemovalCTHMAChangeType,
    kReplacementCTHMAChangeType
    
} CTHMAChangeType;

//===

typedef BOOL(^CTHMAEqualityCheckBlock)(id leftObject, id rightObject);
typedef void(^CTHMAResetNotificationBlock)(CTHMAResetParamSet *params);
typedef void(^CTHMAChangeNotificationBlock)(CTHMAChangeParamSet *params);

//===

@interface CTHMAResetParamSet : NSObject

@property (readonly, strong, nonatomic) CTHMutableArray *array;
@property (readonly, copy, nonatomic) NSArray *previousValues;
@property (readonly, copy, nonatomic) NSArray *targetValues;

@end

//===

@interface CTHMAChangeParamSet : NSObject

@property (readonly, strong, nonatomic) CTHMutableArray *array;
@property (readonly) CTHMAChangeType changeType;
@property (readonly) NSUInteger targetIndex;
@property (readonly, strong, nonatomic) id previousValue;
@property (readonly, strong, nonatomic) id targetValue;

@end

//===

@interface CTHMutableArray : NSMutableArray

// pagination support:
@property NSUInteger totalCount;
@property (readonly) BOOL moreItemsAvailalbe;

@property (readonly, nonatomic) NSArray *selection;
@property (readonly, nonatomic) id selectedObject;

// indesxes of all selected objects:
@property (readonly) NSIndexSet *selectedObjectsIndexSet;
// index of FIRST selected object, if any:
@property (readonly) NSUInteger selectedObjectIndex;

@property (nonatomic, copy) CTHMAEqualityCheckBlock onEqualityCheck;

- (void)setObjectsFromArray:(NSArray *)otherArray;

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

- (void)subscribe:(id)subscriber onWillResetContent:(CTHMAResetNotificationBlock)notificationBlock;
- (void)subscribe:(id)subscriber onDidResetContent:(CTHMAResetNotificationBlock)notificationBlock;

- (void)subscribe:(id)subscriber onWillChangeContent:(CTHMAChangeNotificationBlock)notificationBlock;
- (void)subscribe:(id)subscriber onDidChangeContent:(CTHMAChangeNotificationBlock)notificationBlock;
- (void)subscribe:(id)subscriber onWillChangeSelection:(CTHMAChangeNotificationBlock)notificationBlock;
- (void)subscribe:(id)subscriber onDidChangeSelection:(CTHMAChangeNotificationBlock)notificationBlock;

- (void)unsubscribe:(id)subscriber;

@end
