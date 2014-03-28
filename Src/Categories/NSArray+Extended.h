//
//  NSArray+Extended.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 27/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extended)

@property (readonly, nonatomic) NSArray *selection;
@property (readonly, nonatomic) id selectedObject;

- (BOOL)setObjectSelected:(id)object;
- (BOOL)setObjectAtIndexSelected:(NSUInteger)index;
- (BOOL)setObjectsSelected:(NSArray *)objectList;

- (BOOL)addObjectToSelection:(id)object;
- (BOOL)addObjectAtIndexToSelection:(NSUInteger)index;
- (BOOL)addObjectsToSelection:(NSArray *)objectList;

- (void)removeObjectFromSelection:(id)object;
- (void)removeObjectAtIndexFromSelection:(NSUInteger)index;
- (void)removeObjectsFromSelection:(NSArray *)objectList;

- (void)resetSelection;

@end
