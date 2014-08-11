//
//  ListModel.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 09/08/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHListModel.h"

//===

@implementation CTHListModelChangeParams

@end

//===

@interface CTHListModel ()

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSHashTable *selection;

@property (strong, nonatomic) NSLock *lock;

@end

//===

@implementation CTHListModel

#pragma mark - Property accessors

- (NSArray *)selectedItems
{
    return [self.selection allObjects];
}

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _items = [NSMutableArray array];
        _selection = [NSHashTable weakObjectsHashTable];
        
        _lock = [NSLock new];
        
        //===
        
        NSKeyValueObservingOptions options = (NSKeyValueObservingOptionInitial |
                                              NSKeyValueObservingOptionNew |
                                              NSKeyValueObservingOptionOld /*|
                                              NSKeyValueObservingOptionPrior*/);
        
        [self addObserver:self
               forKeyPath:NSStringFromSelector(@selector(items))
                  options:options
                  context:nil];
    }
    
    //===
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:NSStringFromSelector(@selector(items))];
}

#pragma mark - KVO

/*
 
 typedef NS_OPTIONS(NSUInteger, NSKeyValueChange) {
    NSKeyValueChangeSetting = 1,
    NSKeyValueChangeInsertion = 2,
    NSKeyValueChangeRemoval = 3,
    NSKeyValueChangeReplacement = 4
 };
 
 */

- (void)didChange:(NSKeyValueChange)changeKind
  valuesAtIndexes:(NSIndexSet *)indexes
           forKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(items))])
    {
        switch (changeKind)
        {
            case NSKeyValueChangeInsertion:
                [self didInsertItemsAtIndexes:indexes];
                break;
                
            case NSKeyValueChangeRemoval:
                [self didRemoveItemsAtIndexes:indexes];
                break;
                
            case NSKeyValueChangeReplacement:
                [self didReplaceItemsAtIndexes:indexes];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Notifications (common)

- (void)callNotificationBlock:(CTHListModelChangeItems)targetBlock
                  withIndexes:(NSIndexSet *)indexes
{
    if (targetBlock)
    {
        CTHListModelChangeParams *params = [CTHListModelChangeParams new];
        
        params.list = self;
        params.changedItemIndexes = indexes;
        params.changedItems = [self.items objectsAtIndexes:indexes];
        
        targetBlock(params);
    }
}

#pragma mark - Items Notifications

- (void)didInsertItemsAtIndexes:(NSIndexSet *)indexes
{
    [self callNotificationBlock:self.onDidInsertItems
                    withIndexes:indexes];
}

- (void)didRemoveItemsAtIndexes:(NSIndexSet *)indexes
{
    [self deselectItemsAtIndexes:indexes];
    
    //===
    
    [self callNotificationBlock:self.onDidRemoveItems
                    withIndexes:indexes];
}

- (void)didReplaceItemsAtIndexes:(NSIndexSet *)indexes
{
    [self deselectItemsAtIndexes:indexes];
    
    //===
    
    [self callNotificationBlock:self.onDidReplaceItems
                    withIndexes:indexes];
}

#pragma mark - Selection Notifications

- (void)didSelectItemsAtIndexes:(NSIndexSet *)indexes
{
    [self callNotificationBlock:self.onDidSelectItems
                    withIndexes:indexes];
}

- (void)didDeselectItemsAtIndexes:(NSIndexSet *)indexes
{
    [self callNotificationBlock:self.onDidDeselectItems
                    withIndexes:indexes];
}

#pragma mark - Selection

- (void)selectItemsAtIndexes:(NSIndexSet *)indexes
{
    NSArray *itemsToSelect = [self.items objectsAtIndexes:indexes];
    
    for (id item in itemsToSelect)
    {
        [self.selection addObject:item];
    }
    
    //===
    
    [self didSelectItemsAtIndexes:indexes];
}

- (void)deselectItemsAtIndexes:(NSIndexSet *)indexes
{
    NSArray *itemsToDeselect = [self.items objectsAtIndexes:indexes];
    
    for (id item in itemsToDeselect)
    {
        [self.selection removeObject:item];
    }
    
    //===
    
    [self didDeselectItemsAtIndexes:indexes];
}

#pragma mark - Selection (convenience methods)

- (void)selectItemAtIndex:(NSUInteger)index
{
    [self selectItemsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)deselectItemAtIndex:(NSUInteger)index
{
    [self deselectItemsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

@end
