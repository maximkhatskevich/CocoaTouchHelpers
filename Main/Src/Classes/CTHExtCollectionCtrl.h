//
//  CTHCollectionCtrl.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GlobalBase.h"

//===

#define CTHExtCollectionSectionClass ExtMutableArray

//===

@class CTHExtCollectionCtrl;
@class ExtMutableArray;

typedef void(^CTHExtCollectionCtrlConfigureCell)(CTHExtCollectionCtrl *collectionCtrl,
                                              NSIndexPath *indexPath,
                                              id targetItem,
                                              UICollectionViewCell *targetCell);
typedef void(^CTHExtCollectionCtrlSelectItem)(CTHExtCollectionCtrl *collectionCtrl,
                                           NSIndexPath *indexPath,
                                           id targetItem);
typedef void(^CTHExtCollectionCtrlNeedMoreItems)(CTHExtCollectionCtrl *collectionCtrl,
                                              NSUInteger sectionNumber,
                                              CTHExtCollectionSectionClass *sectionItemList);

//===

@interface CTHExtCollectionCtrl : NSObject
<UICollectionViewDataSource, UICollectionViewDelegate>

@property(getter = isMultiselectEnabled) BOOL multiselectEnabled;

@property (copy, nonatomic) NSString *defaultCellIdentifier;

@property (copy, nonatomic) CTHExtCollectionCtrlConfigureCell onConfigureCell;
@property (copy, nonatomic) CTHExtCollectionCtrlSelectItem onDidSelectItem;
@property (copy, nonatomic) CTHExtCollectionCtrlSelectItem onDidDeselectItem;

// pagination support:
@property NSUInteger preloadOffset;
@property (copy, nonatomic) CTHExtCollectionCtrlNeedMoreItems onNeedMoreItems;

- (void)resetContent;

- (NSUInteger)numberOfItems;
- (NSUInteger)numberOfItemsForSectionAtIndex:(NSUInteger)sectionIndex;
- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (CTHExtCollectionSectionClass *)itemListForSectionAtIndex:(NSUInteger)sectionIndex;

- (void)setOnConfigureCell:(CTHExtCollectionCtrlConfigureCell)onConfigureCell;
- (void)setOnDidSelectItem:(CTHExtCollectionCtrlSelectItem)onDidSelectItem;
- (void)setOnDidDeselectItem:(CTHExtCollectionCtrlSelectItem)onDidDeselectItem;
- (void)setOnNeedMoreItems:(CTHExtCollectionCtrlNeedMoreItems)onNeedMoreItems;

@end
