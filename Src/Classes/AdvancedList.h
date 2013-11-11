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

typedef void (^ALIndexSetBlock)(AdvancedList *list, NSIndexSet *indexes);
typedef void (^ALChangeItemsAtIndexesBlock)(AdvancedList *list, NSKeyValueChange change, NSIndexSet *indexes);
typedef void (^ALBlock)(AdvancedList *list);

#pragma mark - Class

@interface AdvancedList : NSObject

@property (readonly, nonatomic) NSMutableArray *items;

@property (readonly, weak, nonatomic) id currentItem;
@property (readonly) NSUInteger currentItemIndex;

@property (readonly, nonatomic) id oldCurrentItem;
@property (readonly) NSUInteger oldCurrentItemIndex;

@property (strong, nonatomic) ALIndexSetBlock onWillInsertItems;
@property (strong, nonatomic) ALIndexSetBlock onDidInsertItems;

@property (strong, nonatomic) ALIndexSetBlock onWillReplaceItems;
@property (strong, nonatomic) ALIndexSetBlock onDidReplaceItems;

@property (strong, nonatomic) ALIndexSetBlock onWillRemoveItems;
@property (strong, nonatomic) ALIndexSetBlock onDidRemoveItems;

@property (strong, nonatomic) ALChangeItemsAtIndexesBlock onWillChangeItems;
@property (strong, nonatomic) ALChangeItemsAtIndexesBlock onDidChangeItems;

@property (strong, nonatomic) ALBlock onDidChangeCurrentItem;

- (void)resetCurrentItem;
- (void)setItemCurrent:(id)newCurrentItem;
- (void)setItemCurrentByIndex:(NSUInteger)newCurrentItemIndex;

- (void)setPreviousItemCurrent;
- (void)setNextItemCurrent;

@end
