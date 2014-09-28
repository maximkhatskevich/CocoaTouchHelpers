//
//  NSMutableArray+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/6/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Helpers)

- (void)safeAddObject:(id)object;
- (void)safeAddUniqueObject:(id)object;
- (void)addUniqueObjectsFromArray:(NSArray *)objects;

@end
