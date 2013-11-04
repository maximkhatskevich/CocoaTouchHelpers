//
//  AdvancedList.m
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "AdvancedList.h"

@interface AdvancedList ()

@property (readonly, nonatomic) NSMutableArray *content;

@property (readwrite, weak, nonatomic) id currentItem;
@property NSUInteger oldCurrentItemIndex;

@end

@implementation AdvancedList

#pragma mark - Property accessors

- (NSMutableArray *)items
{
    return [self mutableArrayValueForKey:@"content"];
}

- (id)oldCurrentItem
{
    return [self.items safeObjectAtIndex:self.oldCurrentItemIndex];
}

#pragma mark - CleanUp

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentItem"];
    [self removeObserver:self forKeyPath:@"content"];
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _oldCurrentItemIndex = _currentItemIndex = NSNotFound;
        _content = [NSMutableArray array];
        
        [self addObserver:self
               forKeyPath:@"content"
                  options:(NSKeyValueObservingOptionNew |
                           NSKeyValueObservingOptionOld)
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"currentItem"
                  options:(NSKeyValueObservingOptionNew |
                           NSKeyValueObservingOptionOld)
                  context:nil];
        
    }
    return self;
}

#pragma mark -

- (void)resetCurrentItem
{
    [self setItemCurrent:nil];
}

- (void)setItemCurrent:(id)newCurrentItem
{
    _oldCurrentItemIndex = _currentItemIndex;
    
    _currentItemIndex = [self.items indexOfObject:newCurrentItem];
    
    if (_currentItemIndex != _oldCurrentItemIndex)
    {
        self.currentItem = (_currentItemIndex == NSNotFound ? nil : newCurrentItem);
    }
}

- (void)setItemCurrentByIndex:(NSUInteger)newCurrentItemIndex
{
    [self setItemCurrent:
     [self.items safeObjectAtIndex:newCurrentItemIndex]];
}

- (void)setPreviousItemCurrent
{
    if (self.items.count > 1)
    {
        NSUInteger index = self.currentItemIndex;
        
        if (index == NSNotFound)
        {
            index = 0;
        }
        else
        {
            index = (index > 0 ? index -= 1 : (self.items.count - 1));
        }
        
        //===
        
        [self setItemCurrentByIndex:index];
    }
}

- (void)setNextItemCurrent
{
    if (self.items.count > 1)
    {
        NSUInteger index = self.currentItemIndex;
        
        if (index == NSNotFound)
        {
            index = 0;
        }
        else
        {
            index = (index < (self.items.count - 1) ? index += 1 : 0);
        }
        
        //===
        
        [self setItemCurrentByIndex:index];
    }
}

#pragma mark - Observing

- (void)didChangeValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"currentItem"])
    {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(advancedListDidChangeCurrentItem:)])
        {
            [self.delegate advancedListDidChangeCurrentItem:self];
        }
    }
}

- (void)willChange:(NSKeyValueChange)change
   valuesAtIndexes:(NSIndexSet *)indexes
            forKey:(NSString *)key
{
    if ([key isEqualToString:@"content"])
    {
        if (self.delegate)
        {
            switch (change)
            {
                case NSKeyValueChangeInsertion:
                    if ([self.delegate respondsToSelector:@selector(advancedList:willInsertValuesAtIndexes:)])
                    {
                        [self.delegate advancedList:self willInsertValuesAtIndexes:indexes];
                    }
                    break;
                    
                case NSKeyValueChangeReplacement:
                    if ([self.delegate respondsToSelector:@selector(advancedList:willReplaceValuesAtIndexes:)])
                    {
                        [self.delegate advancedList:self willReplaceValuesAtIndexes:indexes];
                    }
                    break;
                    
                case NSKeyValueChangeRemoval:
                    if ([self.delegate respondsToSelector:@selector(advancedList:willRemoveValuesAtIndexes:)])
                    {
                        [self.delegate advancedList:self willRemoveValuesAtIndexes:indexes];
                    }
                    break;
                    
                default:
                    break;
            }
            
            //===
            
            if ([self.delegate respondsToSelector:@selector(advancedList:willChange:valuesAtIndexes:)])
            {
                [self.delegate advancedList:self willChange:change valuesAtIndexes:indexes];
            }
        }
    }
}

- (void)didChange:(NSKeyValueChange)change
  valuesAtIndexes:(NSIndexSet *)indexes
           forKey:(NSString *)key
{
    if ([key isEqualToString:@"content"])
    {
        if (self.delegate)
        {
            switch (change)
            {
                case NSKeyValueChangeInsertion:
                    if ([self.delegate respondsToSelector:@selector(advancedList:didInsertValuesAtIndexes:)])
                    {
                        [self.delegate advancedList:self didInsertValuesAtIndexes:indexes];
                    }
                    break;
                    
                case NSKeyValueChangeReplacement:
                    if ([self.delegate respondsToSelector:@selector(advancedList:didReplaceValuesAtIndexes:)])
                    {
                        [self.delegate advancedList:self didReplaceValuesAtIndexes:indexes];
                    }
                    break;
                    
                case NSKeyValueChangeRemoval:
                    if ([self.delegate respondsToSelector:@selector(advancedList:didRemoveValuesAtIndexes:)])
                    {
                        [self.delegate advancedList:self didRemoveValuesAtIndexes:indexes];
                    }
                    break;
                    
                default:
                    break;
            }
            
            //===
            
            if ([self.delegate respondsToSelector:@selector(advancedList:didChange:valuesAtIndexes:)])
            {
                [self.delegate advancedList:self didChange:change valuesAtIndexes:indexes];
            }
        }
        
        //===
        
        if (change == NSKeyValueChangeRemoval)
        {
            // checkCurrentItem:
            [self setItemCurrent:self.currentItem];
        }
        else if (change == NSKeyValueChangeReplacement)
        {
            _currentItem = [self.content safeObjectAtIndex:_currentItemIndex];
        }
    }
}

@end
