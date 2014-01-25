//
//  AdvancedList.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvancedList;

#pragma mark - Class

@interface AdvancedList : NSObject

@property (readonly, nonatomic) NSMutableArray *items;

@property (readonly, weak, nonatomic) id currentItem;
@property (readonly) NSUInteger currentItemIndex;

@property (readonly, nonatomic) id oldCurrentItem;
@property (readonly) NSUInteger oldCurrentItemIndex;

@property (strong, nonatomic) void (^onWillInsertItems)(AdvancedList *, NSIndexSet *);
@property (strong, nonatomic) void (^onDidInsertItems)(AdvancedList *, NSIndexSet *);

@property (strong, nonatomic) void (^onWillReplaceItems)(AdvancedList *, NSIndexSet *);
@property (strong, nonatomic) void (^onDidReplaceItems)(AdvancedList *, NSIndexSet *);

@property (strong, nonatomic) void (^onWillRemoveItems)(AdvancedList *, NSIndexSet *);
@property (strong, nonatomic) void (^onDidRemoveItems)(AdvancedList *, NSIndexSet *);

@property (strong, nonatomic) void (^onWillChangeItems)(AdvancedList *, NSKeyValueChange, NSIndexSet *);
@property (strong, nonatomic) void (^onDidChangeItems)(AdvancedList *, NSKeyValueChange, NSIndexSet *);

@property (nonatomic, copy) void (^onDidChangeCurrentItem)(AdvancedList *list);

- (void)resetCurrentItem;
- (void)setItemCurrent:(id)newCurrentItem;
- (void)setItemCurrentByIndex:(NSUInteger)newCurrentItemIndex;

- (void)setPreviousItemCurrent;
- (void)setNextItemCurrent;

@end
