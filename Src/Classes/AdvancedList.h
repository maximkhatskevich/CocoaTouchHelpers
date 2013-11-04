//
//  AdvancedList.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvancedList;

#pragma mark - Protocol

@protocol AdvancedListDelegate <NSObject>

@optional

- (void)advancedList:(AdvancedList *)list willChange:(NSKeyValueChange)change
     valuesAtIndexes:(NSIndexSet *)indexes;
- (void)advancedList:(AdvancedList *)list didChange:(NSKeyValueChange)change
     valuesAtIndexes:(NSIndexSet *)indexes;

- (void)advancedList:(AdvancedList *)list willInsertValuesAtIndexes:(NSIndexSet *)indexes;
- (void)advancedList:(AdvancedList *)list didInsertValuesAtIndexes:(NSIndexSet *)indexes;

- (void)advancedList:(AdvancedList *)list willReplaceValuesAtIndexes:(NSIndexSet *)indexes;
- (void)advancedList:(AdvancedList *)list didReplaceValuesAtIndexes:(NSIndexSet *)indexes;

- (void)advancedList:(AdvancedList *)list willRemoveValuesAtIndexes:(NSIndexSet *)indexes;
- (void)advancedList:(AdvancedList *)list didRemoveValuesAtIndexes:(NSIndexSet *)indexes;

- (void)advancedListDidChangeCurrentItem:(AdvancedList *)list;

@end

#pragma mark - Class

@interface AdvancedList : NSObject

@property (readonly, nonatomic) NSMutableArray *items;

@property (readonly, weak, nonatomic) id currentItem;
@property (readonly) NSUInteger currentItemIndex;

@property (readonly, nonatomic) id oldCurrentItem;
@property (readonly) NSUInteger oldCurrentItemIndex;

@property (nonatomic, weak) id<AdvancedListDelegate> delegate;

- (void)resetCurrentItem;
- (void)setItemCurrent:(id)newCurrentItem;
- (void)setItemCurrentByIndex:(NSUInteger)newCurrentItemIndex;

- (void)setPreviousItemCurrent;
- (void)setNextItemCurrent;

@end
