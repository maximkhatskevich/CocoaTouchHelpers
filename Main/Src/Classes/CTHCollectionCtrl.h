//
//  CTHCollectionCtrl.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalBase.h"

//===

#define CTHCollectionSectionClass ExtMutableArray

//===

@class CTHCollectionCtrl;
@class ExtMutableArray;

typedef void(^CTHCollectionCtrlSelectItem)(CTHCollectionCtrl *collectionCtrl,
                                           NSIndexPath *indexPath,
                                           id targetItem);
typedef void(^CTHCollectionCtrlNeedMoreItems)(CTHCollectionCtrl *collectionCtrl,
                                              NSUInteger sectionNumber,
                                              CTHCollectionSectionClass *sectionItemList);

//===

@interface CTHCollectionCtrl : NSObject
<UICollectionViewDataSource, UICollectionViewDelegate>

@property(getter = isMultiselectEnabled) BOOL multiselectEnabled;

@property (copy, nonatomic) NSString *defaultCellIdentifier;

@property (copy, nonatomic) CTHCollectionCtrlSelectItem onDidSelectItem;
@property (copy, nonatomic) CTHCollectionCtrlSelectItem onDidDeselectItem;

// pagination support:
@property NSUInteger preloadOffset;
@property (copy, nonatomic) CTHCollectionCtrlNeedMoreItems onNeedMoreItems;

- (void)resetContent;

- (NSUInteger)numberOfItems;
- (NSUInteger)numberOfItemsForSectionAtIndex:(NSUInteger)sectionIndex;
- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (CTHCollectionSectionClass *)itemListForSectionAtIndex:(NSUInteger)sectionIndex;

- (void)setOnDidSelectItem:(CTHCollectionCtrlSelectItem)onDidSelectItem;
- (void)setOnDidDeselectItem:(CTHCollectionCtrlSelectItem)onDidDeselectItem;
- (void)setOnNeedMoreItems:(CTHCollectionCtrlNeedMoreItems)onNeedMoreItems;

@end
