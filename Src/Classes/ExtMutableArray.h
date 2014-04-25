//
//  ExtMutableArray.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExtMutableArray;

typedef enum {
    kAddEMAChangeType,
    kRemoveEMAChangeType
} EMAChangeType;

typedef BOOL(^ExtArrayWillChangeSelection)(ExtMutableArray *array, id newObject, EMAChangeType changeType);
typedef void(^ExtArrayDidChangeSelection)(ExtMutableArray *array, id newObject, EMAChangeType changeType);

@interface ExtMutableArray : NSMutableArray

@property (readonly, nonatomic) NSArray *selection;
@property (readonly, nonatomic) id selectedObject;

@property (readonly) BOOL selectionChanged;

@property (nonatomic, copy) ExtArrayWillChangeSelection onWillChangeSelection;
@property (nonatomic, copy) ExtArrayDidChangeSelection onDidChangeSelection;

- (BOOL)setObjectSelected:(id)object;
- (BOOL)setObjectAtIndexSelected:(NSUInteger)index;
- (BOOL)setObjectsSelected:(NSArray *)objectList;

- (BOOL)addObjectToSelection:(id)object;
- (BOOL)addObjectAtIndexToSelection:(NSUInteger)index;
- (BOOL)addObjectsToSelection:(NSArray *)objectList;

- (void)removeObjectFromSelection:(id)object;
- (void)removeObjectAtIndexFromSelection:(NSUInteger)index;
- (void)removeObjectsFromSelection:(NSArray *)objectList;

- (void)resetSelection;

- (void)setOnWillChangeSelection:(ExtArrayWillChangeSelection)onWillChangeSelection;
- (void)setOnDidChangeSelection:(ExtArrayDidChangeSelection)onDidChangeSelection;

@end
