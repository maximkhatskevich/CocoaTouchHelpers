//
//  ListModel.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 09/08/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

//===

@class CTHListModel;

//===

@interface CTHListModelChangeParams : NSObject

@property (strong, nonatomic) CTHListModel *list;
@property (strong, nonatomic) NSIndexSet *changedItemIndexes;
@property (strong, nonatomic) NSArray *changedItems;

@end

//===

//typedef BOOL(^CTHListModelChangeItems)(CTHListModel *list, NSIndexSet *changedItemIndexes, NSArray *changedItems);

typedef BOOL(^CTHListModelChangeItems)(CTHListModelChangeParams *params);

//===

@interface CTHListModel : NSObject

@property (readonly, strong, nonatomic) NSMutableArray *items;
@property (readonly, strong, nonatomic) NSArray *selectedItems;

#pragma mark - Items change notification blocks

@property (copy, nonatomic) CTHListModelChangeItems onDidInsertItems;
@property (copy, nonatomic) CTHListModelChangeItems onDidRemoveItems;
@property (copy, nonatomic) CTHListModelChangeItems onDidReplaceItems;

#pragma mark - Selection change notification blocks

@property (copy, nonatomic) CTHListModelChangeItems onDidSelectItems;
@property (copy, nonatomic) CTHListModelChangeItems onDidDeselectItems;

#pragma mark - Selection

- (void)selectItemsAtIndexes:(NSIndexSet *)indexes;
- (void)deselectItemsAtIndexes:(NSIndexSet *)indexes;

#pragma mark - Selection (convenience methods)

- (void)selectItemAtIndex:(NSUInteger)index;
- (void)deselectItemAtIndex:(NSUInteger)index;

#pragma mark - Notification block setters (for smart autosuggestions)

- (void)setOnDidInsertItems:(CTHListModelChangeItems)onDidInsertItems;
- (void)setOnDidRemoveItems:(CTHListModelChangeItems)onDidRemoveItems;
- (void)setOnDidReplaceItems:(CTHListModelChangeItems)onDidReplaceItems;

- (void)setOnDidSelectItems:(CTHListModelChangeItems)onDidSelectItems;
- (void)setOnDidDeselectItems:(CTHListModelChangeItems)onDidDeselectItems;

@end
