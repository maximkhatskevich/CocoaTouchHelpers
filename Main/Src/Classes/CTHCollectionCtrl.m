//
//  CTHCollectionCtrl.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHCollectionCtrl.h"

#import "ExtMutableArray.h"
#import "NSObject+Helpers.h"
#import "NSArray+Helpers.h"

//===

@interface CTHCollectionCtrl ()

@property(strong, nonatomic) NSHashTable *contentStorage;

@end

//===

@implementation CTHCollectionCtrl

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        self.contentStorage =
        [NSHashTable weakObjectsHashTable];
        
        self.multiselectEnabled = NO;
        self.defaultCellIdentifier = @"Cell";
        self.moreItemsOffset = 10;
    }
    return self;
}

- (void)configureWithObject:(id)object
{
    [super configureWithObject:object];
    
    //===
    
    if ([UICollectionView isClassOfObject:object])
    {
        ((UICollectionView *)object).dataSource = self;
        ((UICollectionView *)object).delegate = self;
    }
    else if ([NSArray isClassOfObject:object])
    {
        for (id item in object)
        {
            if ([CTHCollectionSectionClass isClassOfObject:item])
            {
                [self addSection:item];
            }
        }
    }
    else if ([CTHCollectionSectionClass isClassOfObject:object])
    {
        [self addSection:object];
    }
}

#pragma mark - Custom

- (void)resetContent
{
    [self.contentStorage removeAllObjects];
}

- (void)addSection:(CTHCollectionSectionClass *)itemList
{
    if ([CTHCollectionSectionClass isClassOfObject:itemList])
    {
        [self.contentStorage addObject:itemList];
    }
}

- (NSUInteger)numberOfItems
{
    return [self numberOfItemsForSectionAtIndex:0];
}

- (NSUInteger)numberOfItemsForSectionAtIndex:(NSUInteger)sectionIndex
{
    NSUInteger result = 0;
    
    //===
    
    CTHCollectionSectionClass *sectionItemList =
    [[self.contentStorage allObjects] safeObjectAtIndex:sectionIndex];
    
    if ([CTHCollectionSectionClass isClassOfObject:sectionItemList])
    {
        // with pagination support:
        
        if (sectionItemList.totalCount > sectionItemList.count)
        {
            result = sectionItemList.totalCount;
        }
        else
        {
            result = sectionItemList.count;
        }
    }
    
    //===
    
    return result;
}

- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    return self.defaultCellIdentifier;
}

- (CTHCollectionSectionClass *)itemListForSectionAtIndex:(NSUInteger)sectionIndex
{
    CTHCollectionSectionClass *result = nil;
    
    //===
    
    CTHCollectionSectionClass *tmp =
    [[self.contentStorage allObjects] safeObjectAtIndex:sectionIndex];
    
    if ([CTHCollectionSectionClass isClassOfObject:tmp])
    {
        result = tmp;
    }
    
    //===
    
    return result;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.contentStorage.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfItemsForSectionAtIndex:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseId = nil;
    
    //===
    
    cellReuseId = [self cellReuseIdentifierForIndexPath:indexPath];
    
    UICollectionViewCell *cell   =
    [collectionView
     dequeueReusableCellWithReuseIdentifier:cellReuseId
     forIndexPath:indexPath];
    
    //===
    
    CTHCollectionSectionClass *targetSectionItemList =
    [self itemListForSectionAtIndex:indexPath.section];
    
    [cell configureWithObject:
     [targetSectionItemList safeObjectAtIndex:indexPath.item]];
    
    //===
    
    if (targetSectionItemList.moreItemsAvailalbe &&
        ((targetSectionItemList.count - indexPath.item) <= self.preloadOffset) &&
        self.onNeedMoreItems)
    {
        self.onNeedMoreItems(self, indexPath.section, targetSectionItemList);
    }
    
    //===
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTHCollectionSectionClass *targetSectionItemList =
    [self itemListForSectionAtIndex:indexPath.section];
    
    id targetItem = [targetSectionItemList safeObjectAtIndex:indexPath.item];
    
    //===
    
    if (self.isMultiselectEnabled)
    {
        [targetSectionItemList addToSelectionObjectAtIndex:indexPath.item];
    }
    else
    {
        [targetSectionItemList setSelectedObjectAtIndex:indexPath.item];
    }
    
    //===
    
    if (targetItem && self.onDidSelectItem)
    {
        self.onDidSelectItem(self, indexPath, targetItem);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTHCollectionSectionClass *targetSectionItemList =
    [self itemListForSectionAtIndex:indexPath.section];
    
    if (targetSectionItemList.selectedObjectIndex == indexPath.item)
    {
        id targetItem = [targetSectionItemList safeObjectAtIndex:indexPath.item];
        
        //===
        
        [targetSectionItemList removeFromSelectionObjectAtIndex:indexPath.item];
        
        //===
        
        if (targetItem && self.onDidDeselectItem)
        {
            self.onDidDeselectItem(self, indexPath, targetItem);
        }
    }
}

@end
