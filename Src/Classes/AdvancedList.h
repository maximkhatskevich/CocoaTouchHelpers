//
//  AdvancedList.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvancedList;

#pragma mark - Notification blocks

typedef void (^ALChangeValuesAtIndexesBlock)(AdvancedList *list, NSIndexSet *indexes);
typedef void (^ALBlock)(AdvancedList *list);

#pragma mark - Class

@interface AdvancedList : NSObject

@property (readonly, nonatomic) NSMutableArray *items;

@property (readonly, weak, nonatomic) id currentItem;
@property (readonly) NSUInteger currentItemIndex;

@property (readonly, nonatomic) id oldCurrentItem;
@property (readonly) NSUInteger oldCurrentItemIndex;

@property (strong, nonatomic) ALChangeValuesAtIndexesBlock onWillInsertValuesAtIndexes;
@property (strong, nonatomic) ALChangeValuesAtIndexesBlock onDidInsertValuesAtIndexes;

@property (strong, nonatomic) ALChangeValuesAtIndexesBlock onWillReplaceValuesAtIndexes;
@property (strong, nonatomic) ALChangeValuesAtIndexesBlock onDidReplaceValuesAtIndexes;

@property (strong, nonatomic) ALChangeValuesAtIndexesBlock onWillRemoveValuesAtIndexes;
@property (strong, nonatomic) ALChangeValuesAtIndexesBlock onDidRemoveValuesAtIndexes;

@property (strong, nonatomic) ALBlock onDidChangeCurrentItem;

- (void)resetCurrentItem;
- (void)setItemCurrent:(id)newCurrentItem;
- (void)setItemCurrentByIndex:(NSUInteger)newCurrentItemIndex;

- (void)setPreviousItemCurrent;
- (void)setNextItemCurrent;

@end
