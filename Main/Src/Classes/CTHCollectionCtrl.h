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

@class CTHCollectionCtrl;
@class CTHMutableArray;

//===

#define CTHCollectionSectionClass CTHMutableArray

//===

typedef void(^CTHCCConfigureCell)(CTHCollectionCtrl *collectionCtrl,
                                  NSIndexPath *indexPath,
                                  id targetItem,
                                  UICollectionViewCell *targetCell);
typedef void(^CTHCCSelectItem)(CTHCollectionCtrl *collectionCtrl,
                               NSIndexPath *indexPath,
                               id targetItem);
typedef void(^CTHCCNeedMoreItems)(CTHCollectionCtrl *collectionCtrl,
                                  NSUInteger sectionNumber,
                                  CTHCollectionSectionClass *sectionItemList);

//===

@interface CTHCollectionCtrl : NSObject
<UICollectionViewDataSource, UICollectionViewDelegate>

@property(getter = isMultiselectEnabled) BOOL multiselectEnabled;

@property (copy, nonatomic) NSString *defaultCellIdentifier;

@property (copy, nonatomic) CTHCCConfigureCell onConfigureCell;
@property (copy, nonatomic) CTHCCSelectItem onDidSelectItem;
@property (copy, nonatomic) CTHCCSelectItem onDidDeselectItem;

// pagination support:
@property NSUInteger preloadOffset;
@property (copy, nonatomic) CTHCCNeedMoreItems onNeedMoreItems;

- (void)resetContent;

- (NSUInteger)numberOfItems;
- (NSUInteger)numberOfItemsForSectionAtIndex:(NSUInteger)sectionIndex;
- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (CTHCollectionSectionClass *)itemListForSectionAtIndex:(NSUInteger)sectionIndex;

- (void)setOnConfigureCell:(CTHCCConfigureCell)onConfigureCell;
- (void)setOnDidSelectItem:(CTHCCSelectItem)onDidSelectItem;
- (void)setOnDidDeselectItem:(CTHCCSelectItem)onDidDeselectItem;
- (void)setOnNeedMoreItems:(CTHCCNeedMoreItems)onNeedMoreItems;

@end
