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
@property (readonly, copy, nonatomic) NSArray *oldValues;
@property (readonly, copy, nonatomic) NSArray *newValues;

@end

//===

@interface CTHMAChangeParamSet : NSObject

@property (readonly, strong, nonatomic) CTHMutableArray *array;
@property (readonly) CTHMAChangeType changeType;
@property (readonly) NSUInteger targetIndex;
@property (readonly, strong, nonatomic) id oldValue;
@property (readonly, strong, nonatomic) id newValue;

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

- (NSString *)notifyOnWillResetContent:(CTHMAResetNotificationBlock)notificationBlock;
- (NSString *)notifyOnDidResetContent:(CTHMAResetNotificationBlock)notificationBlock;

- (NSString *)notifyOnWillChangeContent:(CTHMAChangeNotificationBlock)notificationBlock;
- (NSString *)notifyOnDidChangeContent:(CTHMAChangeNotificationBlock)notificationBlock;
- (NSString *)notifyOnWillChangeSelection:(CTHMAChangeNotificationBlock)notificationBlock;
- (NSString *)notifyOnDidChangeSelection:(CTHMAChangeNotificationBlock)notificationBlock;

- (BOOL)cancelNotificationWithId:(NSString *)notificationId;

@end
