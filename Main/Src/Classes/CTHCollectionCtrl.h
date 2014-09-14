//
//  CTHCollectionCtrl.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

//===

#define CTHCollectionSectionClass ExtMutableArray

//===

@class CTHCollectionCtrl;
@class ExtMutableArray;

typedef BOOL(^CTHCollectionCtrlSelectItem)(CTHCollectionCtrl *collectionCtrl,
                                           NSIndexPath *indexPath,
                                           id targetItem);

//===

@interface CTHCollectionCtrl : NSObject
<UICollectionViewDataSource, UICollectionViewDelegate>

@property(getter = isMultiselectEnabled) BOOL multiselectEnabled;

@property (copy, nonatomic) NSString *defaultCellIdentifier;
@property (copy, nonatomic) CTHCollectionCtrlSelectItem onDidSelectItem;
@property (copy, nonatomic) CTHCollectionCtrlSelectItem onDidDeselectItem;

- (void)resetContent;

- (NSUInteger)numberOfItems;
- (NSUInteger)numberOfItemsForSectionAtIndex:(NSUInteger)sectionIndex;
- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (CTHCollectionSectionClass *)itemListForSectionAtIndex:(NSUInteger)sectionIndex;

@end
